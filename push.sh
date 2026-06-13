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

case "$OS" in
"arch")
  cp "$HOME/.zshrc" "$SCRIPT_DIR/zsh/arch/"
  cp "$HOME/.config/alacritty/alacritty.toml" "$SCRIPT_DIR/alacritty/arch/"
  cp "$HOME/.config/rofi/config.rasi" "$SCRIPT_DIR/rofi/"
  cp "$HOME/.config/mpd/mpd.conf" "$SCRIPT_DIR/mpd/"
  cp "$HOME/.config/rmpc/config.ron" "$SCRIPT_DIR/rmpc/"
  cp "$HOME/.config/rmpc/config.ron" "$SCRIPT_DIR/rmpc/"
  cp "$HOME/.config/xfce4/startup.sh" "$SCRIPT_DIR/workspace/"
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
