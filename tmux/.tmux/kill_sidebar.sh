#!/bin/bash
#
# if tmux list-windows -F "#{window_name}" | grep -q "^sidebar$"; then
#   tmux kill-window -t sidebar
# else
#   tmux list-panes -F "#{pane_id} #{pane_title}" | grep sidebar | cut -d" " -f1 | xargs -I{} tmux kill-pane -t {}
# fi
