#!/bin/bash

# Define the GitHub repo directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define the directories/files to restore
CONFIG_FILES=(
	"$SCRIPT_DIR/nvim"             # Example: Neovim config
	"$SCRIPT_DIR/kitty/kitty.conf" # Example: Kitty terminal config
	"$SCRIPT_DIR/.tmux.conf"       # Example: Tmux config
	# "$SCRIPT_DIR/.zshrc"           # Example: Zsh config file
	"$SCRIPT_DIR/starhip.toml" # Starship config
)

# Define where to move the configurations on the machine
TARGET_DIRS=(
	"$HOME/.config/nvim"
	"$HOME/.config/kitty/kitty.conf"
	"$HOME/.tmux.conf"
	# "$HOME/.zshrc"
	"$HOME/.config/starship.toml"
)

# Pull the latest changes from GitHub
cd "$SCRIPT_DIR" || exit
git pull origin main # Change 'main' if your branch name is different

# Restore the configuration files by moving them to the correct locations
for i in "${!CONFIG_FILES[@]}"; do
	cp -r "${CONFIG_FILES[i]}" "${TARGET_DIRS[i]}"
done
