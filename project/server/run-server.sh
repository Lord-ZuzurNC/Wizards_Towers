#!/usr/bin/env bash
###############################################################################
# Starts a headless game server from the project sources, for development.
# Stop it with Ctrl+C.
#
# Usage:
#   server/run-server.sh
#     Listen on the default port, 7777
#   server/run-server.sh --port=7800
#     Listen on another port
#
# The Godot binary is $GODOT if set, otherwise `godot` from the PATH.
###############################################################################
set -euo pipefail

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
godot="${GODOT:-godot}"

if ! command -v "$godot" >/dev/null 2>&1; then
	echo "Godot not found: set GODOT to a Godot 4.7.x binary, or put godot on the PATH." >&2
	exit 2
fi

# A fresh clone has no class cache: without it, class_name does not resolve.
"$godot" --headless --path "$project_dir" --import >/dev/null 2>&1

exec "$godot" --headless --path "$project_dir" -- --server "$@"
