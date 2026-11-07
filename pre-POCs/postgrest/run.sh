#!/usr/bin/env bash
###############################################################################
# Runs the PostgREST pre-POC end to end, then removes every container it made.
#
# Usage:
#   GODOT=/path/to/Godot_v4.7.2-stable_linux.x86_64 ./run.sh
#
# Needs Docker. Publishes PostgREST on 127.0.0.1:3399 only.
###############################################################################
set -euo pipefail

cd "$(dirname "$0")"
: "${GODOT:?Set GODOT to a Godot 4.7.2 binary}"

cleanup() {
	docker rm -f wt-poc-api wt-poc-db >/dev/null 2>&1 || true
	docker network rm wt-poc >/dev/null 2>&1 || true
}
trap cleanup EXIT

docker network create wt-poc >/dev/null
docker run -d --name wt-poc-db --network wt-poc \
	-e POSTGRES_DB=wt -e POSTGRES_PASSWORD="$(head -c 18 /dev/urandom | base64)" \
	-v "$PWD/schema.sql:/docker-entrypoint-initdb.d/01-schema.sql:ro" \
	postgres:17-alpine >/dev/null

for _ in $(seq 60); do
	docker logs wt-poc-db 2>&1 | grep -q 'PostgreSQL init process complete' && break
	sleep 1
done
sleep 2

docker run -d --name wt-poc-api --network wt-poc -p 127.0.0.1:3399:3000 \
	-e PGRST_DB_URI=postgres://authenticator:spike-only@wt-poc-db:5432/wt \
	-e PGRST_DB_SCHEMAS=api -e PGRST_DB_ANON_ROLE=game_server \
	postgrest/postgrest:v16.5 >/dev/null
sleep 3

"$GODOT" --headless --script spike.gd
"$GODOT" --headless --script latency.gd
