#!/bin/bash

# # menu.sh
# choice=$(gum choose \
#   "split vertical" \
#   "split horizontal" \
#   "new window" \
#   "kill pane" \
#   "toggle sidebar")
#
# case "$choice" in
#   "split vertical")    tmux split-window -v ;;
#   "split horizontal")  tmux split-window -h ;;
#   "new window")        tmux new-window ;;
#   "kill pane")         tmux kill-pane ;;
#   "toggle sidebar")    ~/.config/tmux/toggle_sidebar.sh ;;
# esac
# ```
#
# **tmux's built-in menu** — no extra tools needed
# ```
# bind ? display-menu -T "tmux menu" \
#   "New Window"       c "new-window" \
#   "Split Vertical"   % "split-window -h" \
#   "Split Horizontal" '"' "split-window -v" \
#   "Kill Pane"        x "kill-pane" \
#   "" \
#   "Toggle Sidebar"   T "run ~/.config/tmux/toggle_sidebar.sh"
