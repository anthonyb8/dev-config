#!/bin/bash

WINDOW="sidebar"
SIZE="35%"

# Sidebar is visible, hide it
if tmux list-panes -F '#{pane_id} #{pane_title}' | grep -q "$WINDOW"; then
  pane_ids=($(tmux list-panes -F '#{pane_id} #{pane_title}' | grep "$WINDOW" | cut -d' ' -f1))

  # break first pane into new window
  tmux break-pane -d -s "${pane_ids[0]}" -n "$WINDOW"

  # move remaining panes into that window
  for pane_id in "${pane_ids[@]:1}"; do
    tmux move-pane -d -s "$pane_id" -t "$WINDOW"
  done

  tmux set -g @sidebar_visible no

elif tmux list-windows -F '#{window_name}' | grep -q "^${WINDOW}$"; then
  pane_count=$(tmux list-panes -t "$WINDOW" | wc -l)

  # join first pane horizontally to create sidebar column
  tmux join-pane -h -l "$SIZE" -s "${WINDOW}.0"
  first_pane=$(tmux list-panes -F '#{pane_id}' | tail -1)
  tmux select-pane -t "$first_pane" -T "$WINDOW"

  # always pull from .0 since indices shift after each join
  for _ in $(seq 1 $((pane_count - 1))); do
    tmux join-pane -v -l "50%" -s "${WINDOW}.0" -t "$first_pane"
    pane_id=$(tmux list-panes -F '#{pane_id}' | tail -1)
    tmux select-pane -t "$pane_id" -T "$WINDOW"
  done

  tmux set -g @sidebar_visible yes

else
  tmpfile=$(mktemp)
  tmux display-popup -E -w 30 -h 5 "gum input --placeholder 'How many panes?' --width 28 --prompt '> ' > $tmpfile"
  pane_count=$(cat "$tmpfile")
  rm "$tmpfile"

  if ! [[ "$pane_count" =~ ^[0-9]+$ ]]; then
    pane_count=1
  fi

  tmux split-window -h -p 35 -c "#{pane_current_path}"
  first_pane=$(tmux display-message -p '#{pane_id}')
  tmux select-pane -t "$first_pane" -T "$WINDOW"

  for _ in $(seq 1 $((pane_count - 1))); do
    tmux split-window -v -t "$first_pane" -c "#{pane_current_path}"
    new_pane=$(tmux display-message -p '#{pane_id}')
    tmux select-pane -t "$new_pane" -T "$WINDOW"
  done

  tmux set -g @sidebar_visible yes
fi

# -- old -
# Sidebar doesn't exist anywhere, create it
# else
#   tmux split-window -h -p 35 -c "#{pane_current_path}"
#   pane_id=$(tmux list-panes -F '#{pane_id}' | tail -1)
#   tmux select-pane -t "$pane_id" -T "$WINDOW"
#
#   # second pane inside sidebar
#   tmux split-window -v -t "$pane_id" -c "#{pane_current_path}"
#   pane_id2=$(tmux list-panes -F '#{pane_id}' | tail -1)
#   tmux select-pane -t "$pane_id2" -T "$WINDOW"
# fi

# Check if a pane with title 'sidebar' exists in current window
# Sidebar is visible, hide it
# if tmux list-panes -F '#{pane_id} #{pane_title}' | grep -q "$WINDOW"; then
#   pane_id=$(tmux list-panes -F '#{pane_id} #{pane_title}' | grep "$WINDOW" | cut -d' ' -f1)
#   tmux break-pane -d -s "$pane_id" -n "$WINDOW"
#   tmux set -g @sidebar_visible no
# # Sidebar window exists, bring it back
# elif tmux list-windows -F '#{window_name}' | grep -q "^${WINDOW}$"; then
#   tmux join-pane -h -l "${SIZE}" -s "$WINDOW".0
#   pane_id=$(tmux list-panes -F '#{pane_id}' | tail -1)
#   tmux select-pane -t "$pane_id" -T "$WINDOW"
#   tmux set -g @sidebar_visible yes
# else
#   tmux split-window -h -p 35 -c "#{pane_current_path}"
#   pane_id=$(tmux list-panes -F '#{pane_id}' | tail -1)
#   tmux select-pane -t "$pane_id" -T "$WINDOW"
#   tmux set -g @sidebar_visible yes
# fi
