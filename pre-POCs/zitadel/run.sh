#!/usr/bin/env bash
###############################################################################
# ZITADEL pre-POC: starts a local ZITADEL, registers the Godot client and a
# test player, then runs the Godot login.
#
# Usage:
#   GODOT=/path/to/Godot_v4.7.2-stable_linux.x86_64 ./run.sh        # login
#   HEADLESS=1 GODOT=... ./run.sh                                   # no window
#   ./run.sh down                                                   # wipe
#
# Needs Docker. Everything listens on 127.0.0.1:8080 only.
# With a display, Godot opens the system browser; headless, open the printed
# URL by hand. Test player: merlin / Wiz4rd-Towers!poc
###############################################################################
set -euo pipefail

cd "$(dirname "$0")"
UPSTREAM=https://raw.githubusercontent.com/zitadel/zitadel/main/deploy/compose
COMPOSE=(docker compose --env-file .env -f docker-compose.yml -f docker-compose.poc.yml)
BASE=http://localhost:8080

if [[ "${1:-}" == "down" ]]; then
	"${COMPOSE[@]}" down --volumes
	rm -f admin.pat client_id.txt
	exit 0
fi
: "${GODOT:?Set GODOT to a Godot 4.7.x binary}"

# 1. Upstream files and fresh secrets, once.
[[ -f docker-compose.yml ]] || curl -fsSLO "$UPSTREAM/docker-compose.yml"
[[ -f .env.example ]] || curl -fsSLO "$UPSTREAM/.env.example"
if [[ ! -f .env ]]; then
	# Not `tr </dev/urandom | head`: under pipefail, tr dies of SIGPIPE and aborts the script.
	rand() { python3 -c 'import secrets, string, sys; print("".join(secrets.choice(string.ascii_letters + string.digits) for _ in range(int(sys.argv[1]))), end="")' "$1"; }
	pg=$(rand 32)
	sed -e "s|^ZITADEL_MASTERKEY=.*|ZITADEL_MASTERKEY=$(rand 32)|" \
		-e "s|^LOGIN_SESSION_COOKIE_SECRET=.*|LOGIN_SESSION_COOKIE_SECRET=$(rand 44)|" \
		-e "s|^POSTGRES_ADMIN_PASSWORD=.*|POSTGRES_ADMIN_PASSWORD=$pg|" \
		-e "s|^PROXY_HTTP_PUBLISHED_PORT=.*|PROXY_HTTP_PUBLISHED_PORT=127.0.0.1:8080|" \
		-e "s|^ZITADEL_DATABASE_POSTGRES_DSN=.*|ZITADEL_DATABASE_POSTGRES_DSN=postgresql://postgres:$pg@postgres:5432/zitadel?sslmode=disable|" \
		.env.example >.env
	echo "ZITADEL_FIRSTINSTANCE_ORG_HUMAN_PASSWORD=$(rand 20)aA1!" >>.env
	chmod 600 .env
fi

# 2. Stack up.
"${COMPOSE[@]}" up -d --wait

# 3. Register the client and the test player, once.
if [[ ! -f client_id.txt ]]; then
	"${COMPOSE[@]}" cp zitadel-api:/zitadel/bootstrap/admin.pat ./admin.pat >/dev/null
	chmod 600 admin.pat
	auth=(-H "Authorization: Bearer $(cat admin.pat)" -H 'Content-Type: application/json')
	project=$(curl -fsS "${auth[@]}" -X POST "$BASE/management/v1/projects" \
		-d '{"name":"wizards-towers-poc"}' | python3 -c 'import json,sys;print(json.load(sys.stdin)["id"])')
	curl -fsS "${auth[@]}" -X POST "$BASE/management/v1/projects/$project/apps/oidc" -d '{
		"name": "godot-client",
		"redirectUris": ["http://127.0.0.1:47123/callback"],
		"responseTypes": ["OIDC_RESPONSE_TYPE_CODE"],
		"grantTypes": ["OIDC_GRANT_TYPE_AUTHORIZATION_CODE"],
		"appType": "OIDC_APP_TYPE_NATIVE",
		"authMethodType": "OIDC_AUTH_METHOD_TYPE_NONE",
		"devMode": false,
		"accessTokenType": "OIDC_TOKEN_TYPE_BEARER"
	}' | python3 -c 'import json,sys;print(json.load(sys.stdin)["clientId"])' >client_id.txt
	curl -fsS "${auth[@]}" -X POST "$BASE/v2/users/human" -d '{
		"username": "merlin",
		"profile": {"givenName": "Merlin", "familyName": "Test"},
		"email": {"email": "merlin@example.test", "isVerified": true},
		"password": {"password": "Wiz4rd-Towers!poc", "changeRequired": false}
	}' >/dev/null
fi

# 4. The login itself.
"$GODOT" ${HEADLESS:+--headless} --script login.gd -- "$BASE" "$(cat client_id.txt)"
