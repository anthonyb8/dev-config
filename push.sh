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

# Define the directories/files to back up
CONFIG_FILES=(
  "$HOME/.config/nvim" # Neovim config
  "$HOME/.tmux.conf"   # Tmux config
  # "$HOME/.config/starship.toml" # Starship config
  # "$HOME/.config/kitty"         # Kitty terminal config
)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS=$(os)

# Copy the configuration files to the GitHub repository directory
for file in "${CONFIG_FILES[@]}"; do
  cp -r "$file" "$SCRIPT_DIR/"
done

case "$OS" in
"arch")
  cp "$HOME/.zshrc" "$SCRIPT_DIR/zsh/arch/"
  cp "$HOME/.config/alacritty/alacritty.toml" "$SCRIPT_DIR/alacritty/arch/"
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
