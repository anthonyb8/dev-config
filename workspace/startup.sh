#!/bin/bash
sleep 5

chromium &
sleep 3
wmctrl -r "Chromium" -t 0
wmctrl -r "Chromium" -b add,maximized_vert,maximized_horz

alacritty &
sleep 3
wmctrl -r "Alacritty" -t 1
wmctrl -r "Alacritty" -b add,maximized_vert,maximized_horz

slack &
sleep 3
wmctrl -r "Slack" -t 2
wmctrl -r "Slack" -b add,maximized_vert,maximized_horz

alacritty --title "rmpc" -e rmpc &
sleep 3
wmctrl -r "rmpc" -t 3
wmctrl -r "rmpc" -b add,maximized_vert,maximized_horz
