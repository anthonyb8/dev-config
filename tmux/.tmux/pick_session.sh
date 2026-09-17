#!/bin/bash
# Project picker. Bound to prefix + S (runs inside a tmux popup).

set -euo pipefail

TMUX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECTS_DIR="${PROJECTS_DIR:-$HOME/projects}"

project="$(ls "$PROJECTS_DIR" | gum choose --header 'project' --height 15)" || exit 0
[[ -z "$project" ]] && exit 0

exec "$TMUX_DIR/session.sh" "$project"
