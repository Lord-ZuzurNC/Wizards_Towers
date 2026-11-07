# Pre-POC — PostgREST

- [Pre-POC — PostgREST](#pre-poc--postgrest)
  - [Question](#question)
  - [Setup](#setup)
  - [Results](#results)
  - [Conclusions](#conclusions)
  - [Run it](#run-it)

## Question

Can a Godot 4.7.2 dedicated server reach PostgreSQL with no driver, no GDExtension and no second programming language, while keeping every value-moving write atomic?

## Setup

| Part       | Version                                   |
| ---------- | ----------------------------------------- |
| Engine     | Godot 4.7.2 stable, `--headless --script` |
| Database   | `postgres:17-alpine`                      |
| HTTP layer | `postgrest/postgrest:v16.5`               |

`schema.sql` keeps the tables in a `core` schema that PostgREST never exposes.
Only the functions in the `api` schema are callable, and each value-moving write is one function, so one call is one transaction.
`buy_village` locks the rows it touches with `FOR UPDATE`; its `p_hold_lock_s` parameter exists only to widen the race window on purpose.

## Results

Measured on 2026-11-07, twice, with identical results; the raw output of the second run is in `results.log`.

| Case | What it checks                                      | Result                                                         |
| ---- | --------------------------------------------------- | -------------------------------------------------------------- |
| A    | A purchase the wizard can afford.                   | HTTP 200, gold 100 → 50.                                       |
| B    | A purchase the wizard cannot afford.                | HTTP 400 `not enough gold`, nothing changed.                   |
| C    | A function that debits, then fails.                 | HTTP 400, gold and ownership untouched, no ledger row.         |
| D    | Two purchases in the same frame, gold for only one. | One HTTP 200 at 338 ms, one HTTP 400 at 642 ms after the lock. |
| E    | A direct write to a table.                          | HTTP 404, the table is not reachable.                          |
| F    | Latency of 20 sequential calls.                     | 1 ms at PostgREST, 34 ms from Godot, 7 ms with `use_threads`.  |

## Conclusions

PostgREST is retained, as recorded in `docs/TECH_STACK.md`.
`HTTPRequest.use_threads` must be on: without it, every call waits on the frame loop.
Under `--script`, `root` accepts children only after the first `process_frame`.
This pre-POC covers no authentication; in production the game server authenticates to PostgREST with a signed token.

## Run it

```bash
GODOT=/path/to/Godot_v4.7.2-stable_linux.x86_64 ./run.sh
```

It needs Docker, publishes PostgREST on `127.0.0.1:3399` only, and removes its containers and network on exit.
