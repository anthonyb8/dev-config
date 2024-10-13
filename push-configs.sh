#!/bin/bash

# Define the directories/files to back up
CONFIG_FILES=(
	"$HOME/.config/nvim"             # Neovim config
	"$HOME/.config/kitty/kitty.conf" # Kitty terminal config
	"$HOME/.tmux.conf"               # Tmux config
	"$HOME/.zshrc"                   # Zsh config file
	"$HOME/.config/starship.toml"    # Starship config
)

# Define the directory where you want to copy them in your local repo
GITHUB_REPO_DIR="$HOME/dev-environment" # Change this to your GitHub repo directory

# Check if the GitHub repo directory exists
if [ ! -d "$GITHUB_REPO_DIR" ]; then
	echo "Error: GitHub repo directory $GITHUB_REPO_DIR not found!"
	exit 1
fi

# Copy the configuration files to the GitHub repository directory
for file in "${CONFIG_FILES[@]}"; do
	cp -r "$file" "$GITHUB_REPO_DIR/"
done

# Change to the GitHub repository directory
cd "$GITHUB_REPO_DIR" || exit

# # Add, commit, and push the changes to GitHub
# git add .
# git commit -m "Update configuration files"
# git push origin main # Change 'main' if your branch name is different
