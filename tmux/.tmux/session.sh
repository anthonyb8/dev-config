#!/bin/bash
# Open the project session for a directory.
#
#   session.sh [project]
#
# <project> is a path, a directory name under ~/projects, or omitted (current dir).
# If the session already exists it is attached, never rebuilt.

set -euo pipefail

TMUX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$TMUX_DIR/lib.sh"

dir="$(resolve_project "${1:-}")"
name="$(session_name "$dir")"

if ! tmux has-session -t="$name" 2>/dev/null; then
  "$TMUX_DIR/sessions/project.sh" "$name" "$dir"
fi

attach_or_switch "$name"
