#!/usr/bin/env bash
#
# GNOME top bar, matched to the old XFCE panel in
#   ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
#
# That panel carried six real plugins (the rest were spacers):
#   left   battery, cpugraph, pager
#   center clock (date %B %d, %Y) + clock (time %I:%M %p)
#   right  pulseaudio, systray
#
# GNOME covers pager, pulseaudio and systray natively (the last via the
# AppIndicator extension). This script sets the rest.
#
# Idempotent: safe to re-run, prints the same output every time.

set -euo pipefail

set_key() {
  local schema=$1 key=$2 value=$3
  gsettings set "$schema" "$key" "$value"
  printf '  %-30s %s\n' "$key" "$(gsettings get "$schema" "$key")"
}

echo "== clock: 12-hour, date, no weekday, no seconds (XFCE clock plugins 5 and 11) =="
set_key org.gnome.desktop.interface clock-format "'12h'"
set_key org.gnome.desktop.interface clock-show-date true
set_key org.gnome.desktop.interface clock-show-weekday false
set_key org.gnome.desktop.interface clock-show-seconds false

echo
echo "== battery: show the percentage, as the XFCE battery plugin did =="
set_key org.gnome.desktop.interface show-battery-percentage true

echo
echo "== Vitals: stands in for the cpugraph plugin =="
# Sensor keys are built as _<type>_<label lowercased, spaces to underscores>_
# so CPU utilisation is _processor_usage_ and the coretemp package sensor is
# _temperature_package_id_0_. Additive: the memory, load and network readouts
# that were already there are kept.
set_key org.gnome.shell.extensions.vitals hot-sensors \
  "['_processor_usage_', '_memory_usage_', '_system_load_1m_', '__network-rx_max__']"
set_key org.gnome.shell.extensions.vitals show-processor true
set_key org.gnome.shell.extensions.vitals show-temperature true
set_key org.gnome.shell.extensions.vitals update-time 2   # cpugraph used a 2s interval
# 0=left 1=center 2=right. Left, beside the workspace indicator, is where
# cpugraph sat in the XFCE panel.
set_key org.gnome.shell.extensions.vitals position-in-panel 0
