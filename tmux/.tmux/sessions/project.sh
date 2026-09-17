#!/bin/bash
# The project session: four windows, all rooted in the project directory.
#
#   1 dev      nvim | claude      3 git      lazygit
#   2 linear   linear-tui         4 deploy   build | test
#                                            -------------
#                                               deploy
#
# Override the agent command with CLAUDE_CMD, e.g.
#   CLAUDE_CMD="claude --model sonnet" tm bridg
#
# Built detached; session.sh attaches afterwards.

set -euo pipefail

name="$1"
dir="$2"
claude_cmd="${CLAUDE_CMD:-claude}"

# ── 1. dev ────────────────────────────────────────────────────────────
tmux new-session -d -s "$name" -c "$dir" -n dev
tmux send-keys -t "$name:dev" 'nvim' C-m
tmux select-pane -t "$name:dev" -T nvim

tmux split-window -t "$name:dev" -h -p 40 -c "$dir"
tmux send-keys -t "$name:dev" "$claude_cmd" C-m
tmux select-pane -t "$name:dev" -T claude

# ── 2. linear ─────────────────────────────────────────────────────────
# linear-tui: github.com/roeyazroel/linear-tui
#   go install github.com/roeyazroel/linear-tui/cmd/linear-tui@latest
#   auth: linear-tui auth login  (creds in ~/.linear-tui/credentials.json)
#
# sent as keys, not as the window command, so an exit (or a missing auth
# token) drops to a shell instead of killing the window
tmux new-window -t "$name" -c "$dir" -n linear
tmux send-keys -t "$name:linear" 'linear-tui' C-m
tmux select-pane -t "$name:linear" -T linear

# ── 3. git ────────────────────────────────────────────────────────────
tmux new-window -t "$name" -c "$dir" -n git
tmux send-keys -t "$name:git" 'lazygit' C-m
tmux select-pane -t "$name:git" -T git

# ── 4. deploy ─────────────────────────────────────────────────────────
# bottom bar first, then split the top half evenly
tmux new-window -t "$name" -c "$dir" -n deploy
tmux split-window -t "$name:deploy" -v -p 40 -c "$dir"
tmux select-pane -t "$name:deploy" -T deploy
tmux split-window -t "$name:deploy.1" -h -p 50 -c "$dir"
tmux select-pane -t "$name:deploy.1" -T build
tmux select-pane -t "$name:deploy.2" -T test
tmux select-pane -t "$name:deploy.1"

# land in nvim
tmux select-window -t "$name:dev"
tmux select-pane -t "$name:dev.1"
