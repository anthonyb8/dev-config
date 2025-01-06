#!/bin/bash

# Define the directories/files to back up
CONFIG_FILES=(
	"$HOME/.config/nvim"          # Neovim config
	"$HOME/.config/kitty"         # Kitty terminal config
	"$HOME/.tmux.conf"            # Tmux config
	"$HOME/.zshrc"                # Zsh config file
	"$HOME/.config/starship.toml" # Starship config
)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy the configuration files to the GitHub repository directory
for file in "${CONFIG_FILES[@]}"; do
	cp -r "$file" "$SCRIPT_DIR/"
done

# Add, commit, and push the changes to GitHub
git add .
git commit -m "Update configuration files"
git push origin main
