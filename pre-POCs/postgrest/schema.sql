-- Wizards Towers — PostgREST spike. Throwaway.
-- Tables live in `core` (never exposed); PostgREST only exposes functions in `api`.

CREATE ROLE authenticator LOGIN NOINHERIT PASSWORD 'spike-only';
CREATE ROLE game_server NOLOGIN;
GRANT game_server TO authenticator;

CREATE SCHEMA core;
CREATE SCHEMA api;

CREATE TABLE core.wizards (
	id   int  PRIMARY KEY,
	name text NOT NULL,
	gold int  NOT NULL CHECK (gold >= 0)
);

CREATE TABLE core.villages (
	id       int PRIMARY KEY,
	owner_id int REFERENCES core.wizards (id),
	price    int NOT NULL
);

CREATE TABLE core.ledger (
	id         bigserial   PRIMARY KEY,
	wizard_id  int         NOT NULL,
	village_id int         NOT NULL,
	amount     int         NOT NULL,
	at         timestamptz NOT NULL DEFAULT now()
);

INSERT INTO core.wizards VALUES (1, 'Alba', 5000), (2, 'Brann', 100);
INSERT INTO core.villages VALUES (1, NULL, 3000), (2, NULL, 3000), (3, NULL, 50);

-- One value-moving write = one function = one transaction.
CREATE FUNCTION api.buy_village(p_wizard int, p_village int, p_hold_lock_s float DEFAULT 0)
RETURNS json LANGUAGE plpgsql SECURITY DEFINER SET search_path = core, pg_temp AS $$
DECLARE
	v_price int;
	v_owner int;
	v_gold  int;
BEGIN
	SELECT price, owner_id INTO v_price, v_owner FROM villages WHERE id = p_village FOR UPDATE;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'no such village' USING ERRCODE = 'P0002';
	END IF;
	IF v_owner IS NOT NULL THEN
		RAISE EXCEPTION 'village already owned' USING ERRCODE = 'P0001';
	END IF;
	SELECT gold INTO v_gold FROM wizards WHERE id = p_wizard FOR UPDATE;
	PERFORM pg_sleep(p_hold_lock_s);  -- spike only: widen the race window on purpose
	IF v_gold < v_price THEN
		RAISE EXCEPTION 'not enough gold' USING ERRCODE = 'P0001';
	END IF;
	UPDATE wizards SET gold = gold - v_price WHERE id = p_wizard;
	UPDATE villages SET owner_id = p_wizard WHERE id = p_village;
	INSERT INTO ledger (wizard_id, village_id, amount) VALUES (p_wizard, p_village, -v_price);
	RETURN json_build_object('wizard', p_wizard, 'village', p_village, 'gold_left', v_gold - v_price);
END $$;

-- Debits, then fails: proves a failed call leaves nothing behind.
CREATE FUNCTION api.buy_then_crash(p_wizard int, p_village int)
RETURNS json LANGUAGE plpgsql SECURITY DEFINER SET search_path = core, pg_temp AS $$
BEGIN
	UPDATE wizards SET gold = gold - 3000 WHERE id = p_wizard;
	UPDATE villages SET owner_id = p_wizard WHERE id = p_village;
	RAISE EXCEPTION 'simulated crash after the debit' USING ERRCODE = 'P0001';
END $$;

CREATE FUNCTION api.world_state()
RETURNS json LANGUAGE sql STABLE SECURITY DEFINER SET search_path = core, pg_temp AS $$
	SELECT json_build_object(
		'wizards',  (SELECT json_agg(w ORDER BY id) FROM wizards w),
		'villages', (SELECT json_agg(v ORDER BY id) FROM villages v),
		'ledger_rows', (SELECT count(*) FROM ledger)
	);
$$;

REVOKE ALL ON FUNCTION api.buy_village(int, int, float), api.buy_then_crash(int, int), api.world_state() FROM PUBLIC;
GRANT USAGE ON SCHEMA api TO game_server;
GRANT EXECUTE ON FUNCTION api.buy_village(int, int, float), api.buy_then_crash(int, int), api.world_state() TO game_server;
