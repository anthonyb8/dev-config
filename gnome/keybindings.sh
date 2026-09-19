#!/usr/bin/env bash
#
# GNOME keyboard shortcuts, ported from the XFCE set in
#   ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
#
# Idempotent: safe to re-run, and prints the same output every time.
# Everything lands in dconf, so nothing here needs root and nothing here
# is deployed by push.sh/pull.sh - this script IS the source of truth.

set -euo pipefail

WM=org.gnome.desktop.wm.keybindings
SHELL_KB=org.gnome.shell.keybindings
MEDIA=org.gnome.settings-daemon.plugins.media-keys
MUTTER_KB=org.gnome.mutter.keybindings
CUSTOM_PATH=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings

set_key() {
  local schema=$1 key=$2 value=$3
  gsettings set "$schema" "$key" "$value"
  printf '  %-34s %s\n' "$key" "$(gsettings get "$schema" "$key")"
}

set_custom() {
  # set_custom <index> <name> <binding> <command>
  local idx=$1 name=$2 binding=$3 command=$4
  local path="$CUSTOM_PATH/custom$idx/"
  local schema="$MEDIA.custom-keybinding:$path"
  gsettings set "$schema" name "$name"
  gsettings set "$schema" binding "$binding"
  gsettings set "$schema" command "$command"
  printf '  %-34s %-18s %s\n' "custom$idx ($name)" "$binding" "$command"
}

echo "== workspaces: static, four of them =="
set_key org.gnome.mutter dynamic-workspaces false
set_key org.gnome.desktop.wm.preferences num-workspaces 4

echo
echo "== overview triggers: off =="
# The workspace dots in the top-left corner open the overview. rofi is the
# launcher here, so every way of reaching the overview by accident is disabled.
# The dots themselves are drawn by gnome-shell's panel and can only be removed
# by an extension (Just Perfection); these two kill the triggers.
set_key org.gnome.desktop.interface enable-hot-corners false   # top-left mouse corner
set_key org.gnome.mutter overlay-key "''"                      # bare Super
set_key org.gnome.shell.keybindings toggle-overview "[]"
set_key org.gnome.shell.keybindings toggle-application-view "[]"

echo
echo "== free Super+1..9 from the dash (they shadow the workspace keys) =="
for i in 1 2 3 4 5 6 7 8 9; do
  gsettings set "$SHELL_KB" "switch-to-application-$i" "[]"
done
printf '  switch-to-application-1..9         cleared\n'

echo
echo "== free Super+space from input-source switching =="
set_key org.gnome.desktop.wm.keybindings switch-input-source "[]"
set_key org.gnome.desktop.wm.keybindings switch-input-source-backward "[]"

echo
echo "== launchers =="
# rofi 2.0.0 on GNOME needs two workarounds:
#   -u WAYLAND_DISPLAY  its Wayland backend requires wlr-layer-shell, which
#                       mutter does not implement, so it SIGABRTs. Forcing the
#                       X11 backend runs it under XWayland instead.
#   -normal-window      without it rofi maps an X window with no
#                       _NET_WM_WINDOW_TYPE, so mutter never manages or focuses
#                       it: the menu appears but swallows no keys and Escape
#                       cannot dismiss it. -normal-window sets
#                       _NET_WM_WINDOW_TYPE_NORMAL and keeps _MOTIF_WM_HINTS
#                       decorations off, so it is focusable and still borderless.
set_custom 0 rofi      '<Super>space' 'env -u WAYLAND_DISPLAY rofi -show drun -normal-window'
set_custom 1 alacritty '<Super>t'     'alacritty'
set_custom 2 files     '<Super>e'     'nautilus'
set_custom 3 browser   '<Super>b'     'epiphany'
set_key "$MEDIA" custom-keybindings \
  "['$CUSTOM_PATH/custom0/', '$CUSTOM_PATH/custom1/', '$CUSTOM_PATH/custom2/', '$CUSTOM_PATH/custom3/']"

echo
echo "== switch workspace (XFCE workspace_N_key) =="
set_key "$WM" switch-to-workspace-1 "['<Super>1']"
set_key "$WM" switch-to-workspace-2 "['<Super>2']"
set_key "$WM" switch-to-workspace-3 "['<Super>3']"
set_key "$WM" switch-to-workspace-4 "['<Super>4']"
set_key "$WM" switch-to-workspace-left  "['<Control><Alt>Left']"
set_key "$WM" switch-to-workspace-right "['<Control><Alt>Right']"

echo
echo "== move window to workspace (XFCE move_window_*_workspace_key) =="
set_key "$WM" move-to-workspace-1 "['<Control><Shift>1']"
set_key "$WM" move-to-workspace-2 "['<Control><Shift>2']"
set_key "$WM" move-to-workspace-3 "['<Control><Shift>3']"
set_key "$WM" move-to-workspace-4 "['<Control><Shift>4']"
set_key "$WM" move-to-workspace-left  "['<Control><Shift>Left']"
set_key "$WM" move-to-workspace-right "['<Control><Shift>Right']"

echo
echo "== move window to monitor (XFCE move_window_to_monitor_*_key) =="
set_key "$WM" move-to-monitor-left  "['<Shift><Super>Left']"
set_key "$WM" move-to-monitor-right "['<Shift><Super>Right']"
set_key "$WM" move-to-monitor-up    "['<Shift><Super>Up']"
set_key "$WM" move-to-monitor-down  "['<Shift><Super>Down']"

echo
echo "== window management =="
set_key "$WM" close             "['<Super>q']"
set_key "$WM" minimize          "['<Super>m']"
set_key "$WM" maximize          "['<Super>f', '<Super>Up']"
set_key "$WM" unmaximize        "['<Super>Down', '<Alt>F5']"
set_key "$WM" toggle-fullscreen "['<Alt>F11']"
set_key "$WM" show-desktop      "['<Control><Alt>d']"
set_key "$WM" begin-move        "['<Alt>F7']"
set_key "$WM" begin-resize      "['<Alt>F8']"
set_key "$WM" activate-window-menu "['<Alt>space']"

echo
echo "== half-screen tiling =="
set_key "$MUTTER_KB" toggle-tiled-left  "['<Super>Left']"
set_key "$MUTTER_KB" toggle-tiled-right "['<Super>Right']"

echo
echo "== screenshot and display =="
set_key "$SHELL_KB" show-screenshot-ui "['<Super>a']"
set_key "$MUTTER_KB" switch-monitor "['<Super>p', 'XF86Display']"

# Optional: XFCE kept cycle-windows and switch-window as two distinct actions.
# GNOME puts both keys on switch-applications. Uncomment to split them.
# set_key "$WM" switch-applications "['<Super>Tab']"
# set_key "$WM" switch-windows      "['<Alt>Tab']"

echo
echo "Not portable to GNOME, deliberately dropped:"
echo "  Super+h / Super+KP_* corner tiling - mutter does halves only."
echo "  Needs a third-party extension (Tiling Shell, Forge) if you want it back."
