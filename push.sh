#!/bin/bash

AUTO_YES=false

# Parse the -y flag
if [ "$1" == "-y" ]; then
  AUTO_YES=true
fi

os() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [[ -f /etc/os-release ]]; then
      . /etc/os-release
      echo "$ID"
    else
      echo "unknown"
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "darwin"
  fi
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS=$(os)

cp -r "$HOME/.config/nvim" "$SCRIPT_DIR/"
cp "$HOME/.tmux.conf" "$SCRIPT_DIR/tmux/"
rsync -a --exclude='plugins/' "$HOME/.tmux/" "$SCRIPT_DIR/tmux/.tmux/"

[ -f "$HOME/.claude/CLAUDE.md" ] && cp "$HOME/.claude/CLAUDE.md" "$SCRIPT_DIR/claude/"
[ -f "$HOME/.claude/OPINIONS.md" ] && cp "$HOME/.claude/OPINIONS.md" "$SCRIPT_DIR/claude/"
[ -f "$HOME/.claude/VOICE.md" ] && cp "$HOME/.claude/VOICE.md" "$SCRIPT_DIR/claude/"
[ -d "$HOME/.claude/skills" ] && rsync -a "$HOME/.claude/skills/" "$SCRIPT_DIR/claude/skills/"

# linear-tui settings. Copy named files only, never the directory: it also
# holds credentials.json (the OAuth token) and app.log, which must not be
# committed. .gitignore backs this up in case something copies them anyway.
mkdir -p "$SCRIPT_DIR/linear"
[ -f "$HOME/.linear-tui/config.json" ] && cp "$HOME/.linear-tui/config.json" "$SCRIPT_DIR/linear/"
[ -f "$HOME/.linear-tui/prompts.json" ] && cp "$HOME/.linear-tui/prompts.json" "$SCRIPT_DIR/linear/"

case "$OS" in
"arch")
  cp "$HOME/.zshrc" "$SCRIPT_DIR/zsh/arch/"
  cp "$HOME/.config/alacritty/alacritty.toml" "$SCRIPT_DIR/alacritty/arch/"
  cp "$HOME/.config/kitty/kitty.conf" "$SCRIPT_DIR/kitty/arch/"
  cp "$HOME/.config/rofi/config.rasi" "$SCRIPT_DIR/rofi/"
  cp "$HOME/.config/mpd/mpd.conf" "$SCRIPT_DIR/mpd/"
  cp "$HOME/.config/rmpc/config.ron" "$SCRIPT_DIR/rmpc/"
  cp "$HOME/.config/rmpc/config.ron" "$SCRIPT_DIR/rmpc/"
  ;;
"debian")
  cp "$HOME/.zshrc" "$SCRIPT_DIR/zsh/debian/"
  cp "$HOME/.config/alacritty/alacritty.toml" "$SCRIPT_DIR/alacritty/debian/"
  ;;
"darwin")
  cp "$HOME/.zshrc" "$SCRIPT_DIR/zsh/macos/"
  cp "$HOME/.config/alacritty/alacritty.toml" "$SCRIPT_DIR/alacritty/macos/"
  ;;
*)
  echo "Invalid OS."
  ;;
esac

push() {
  git add .
  git commit -m "Update configuration files"
  git push origin main
}

# Add, commit, and push the changes to GitHub
if [ "$AUTO_YES" == true ]; then
  push
else
  read -rp "Do you want to push to GitHub? [y/N]" answer
  if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "Skipping GitHub push"
    exit 0
  else
    push
  fi

fi
