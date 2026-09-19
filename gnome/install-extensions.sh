#!/usr/bin/env bash
#
# Link the locally-written GNOME extensions in this repo into the place
# gnome-shell looks, and mark them enabled.
#
# gnome-shell only scans ~/.local/share/gnome-shell/extensions at startup, and
# on Wayland the shell cannot be restarted in place, so a new extension does
# not appear until the next log out and back in. Enabling it in dconf ahead of
# time (as this does) means it comes up active on that first login.
#
# Idempotent: safe to re-run.

set -euo pipefail

SRC_DIR="$(dirname "${BASH_SOURCE[0]}")/extensions"
if [ ! -d "$SRC_DIR" ]; then
  echo "  no extensions/ directory next to this script; nothing to link."
  exit 0
fi
SRC_DIR="$(cd "$SRC_DIR" && pwd)"
DST_DIR="$HOME/.local/share/gnome-shell/extensions"
mkdir -p "$DST_DIR"

declare -a uuids=()
for src in "$SRC_DIR"/*@*; do
  [ -d "$src" ] || continue
  uuid="$(basename "$src")"
  uuids+=("$uuid")
  dst="$DST_DIR/$uuid"
  if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$src" ]; then
    printf '  %-32s already linked\n' "$uuid"
  else
    rm -rf "$dst"
    ln -s "$src" "$dst"
    printf '  %-32s linked\n' "$uuid"
  fi
done

# Merge our uuids into whatever is already enabled, without dropping others.
current="$(gsettings get org.gnome.shell enabled-extensions)"
python3 - "$current" "${uuids[@]}" <<'PY' > /tmp/.gnome-ext-list
import ast, sys
cur = sys.argv[1].strip()
cur = [] if cur in ('@as []', '[]') else ast.literal_eval(cur)
for u in sys.argv[2:]:
    if u not in cur:
        cur.append(u)
print('[' + ', '.join(f"'{u}'" for u in cur) + ']')
PY
gsettings set org.gnome.shell enabled-extensions "$(cat /tmp/.gnome-ext-list)"
rm -f /tmp/.gnome-ext-list
echo
echo "  enabled-extensions: $(gsettings get org.gnome.shell enabled-extensions)"
echo
if [ ${#uuids[@]} -eq 0 ]; then
  echo "  No local extensions in $SRC_DIR yet."
  exit 0
fi

echo "  Log out and back in for a newly-added extension to load."
echo "  Then check each came up clean:"
for uuid in "${uuids[@]}"; do
  echo "    gnome-extensions info $uuid | grep State"
  echo "    journalctl --user -b /usr/bin/gnome-shell | grep ${uuid%%@*}"
done
