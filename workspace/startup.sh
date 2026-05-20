#!/bin/bash
chromium &
sleep 1
wmctrl -r "Chromium" -t 0
wmctrl -r "Chromium" -b add,maximized_vert,maximized_horz

alacritty &
sleep 1
wmctrl -r "Alacritty" -t 1
wmctrl -r "Alacritty" -b add,maximized_vert,maximized_horz

thunar &
sleep 1
wmctrl -r "Thunar" -t 2
wmctrl -r "Thunar" -b add,maximized_vert,maximized_horz

alacritty --title "rmpc" -e rmpc &
sleep 1
wmctrl -r "rmpc" -t 3
wmctrl -r "rmpc" -b add,maximized_vert,maximized_horz
