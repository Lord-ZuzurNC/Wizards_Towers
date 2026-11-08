#!/usr/bin/env bash
###############################################################################
# Runs every test of the Godot project, headless.
#
# Usage:
#   tests/run-tests.sh
#     Run every test under res://tests, exit non-zero if any fails
#   tests/run-tests.sh res://tests/framework_checks
#     Run only the tests under one folder
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

# A fresh clone has no class cache: without it, class_name does not resolve in --script mode.
"$godot" --headless --path "$project_dir" --import >/dev/null 2>&1

# Leaks are only reported as the engine exits, after the runner has given its verdict,
# so the script reads them from the output and fails the run itself.
output="$(mktemp)"
trap 'rm -f "$output"' EXIT
"$godot" --headless --path "$project_dir" --script res://tests/run.gd -- "$@" 2>&1 | tee "$output"
if grep -qE "instances were leaked|resources still in use" "$output"; then
	echo "Objects leaked at exit: rerun with --verbose to see which." >&2
	exit 1
fi
