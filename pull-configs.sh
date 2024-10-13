#!/bin/bash

# Define the GitHub repo directory
GITHUB_REPO_DIR="$HOME/dev-environment" # Change this to your GitHub repo directory

# Define the directories/files to restore
CONFIG_FILES=(
	"$GITHUB_REPO_DIR/nvim"   # Example: Neovim config
	"$GITHUB_REPO_DIR/kitty"  # Example: Kitty terminal config
	"$GITHUB_REPO_DIR/tmux"   # Example: Tmux config
	"$GITHUB_REPO_DIR/.zshrc" # Example: Zsh config file
)

# Define where to move the configurations on the machine
TARGET_DIRS=(
	"$HOME/.config/nvim"
	"$HOME/.config/kitty"
	"$HOME/.config/tmux"
	"$HOME/.zshrc"
)

# Pull the latest changes from GitHub
cd "$GITHUB_REPO_DIR" || exit
git pull origin main # Change 'main' if your branch name is different

# Restore the configuration files by moving them to the correct locations
for i in "${!CONFIG_FILES[@]}"; do
	cp -r "${CONFIG_FILES[i]}" "${TARGET_DIRS[i]}"
done
