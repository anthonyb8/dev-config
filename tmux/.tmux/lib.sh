#!/bin/bash
# Shared helpers for the project session preset.

PROJECTS_DIR="${PROJECTS_DIR:-$HOME/projects}"

# resolve_project <arg> -> absolute directory
# existing path wins, then ~/projects/<arg>, then the current directory
resolve_project() {
  local arg="$1"

  if [[ -z "$arg" ]]; then
    pwd
    return
  fi

  if [[ -d "$arg" ]]; then
    (cd "$arg" && pwd)
    return
  fi

  if [[ -d "$PROJECTS_DIR/$arg" ]]; then
    echo "$PROJECTS_DIR/$arg"
    return
  fi

  echo "no such project: $arg" >&2
  return 1
}

# session_name <dir> -> tmux-safe session name
# '.' and ':' are target separators in tmux, so Main.Bridg has to become Main_Bridg
session_name() {
  basename "$1" | tr '.:' '__'
}

# attach_or_switch <session>
# works the same from a shell, a popup, or a keybinding
attach_or_switch() {
  local name="$1"
  if [[ -n "${TMUX:-}" ]]; then
    tmux switch-client -t "$name"
  else
    tmux attach -t "$name"
  fi
}
