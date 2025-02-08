#!/bin/bash

# Define the GitHub repo directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define the directories/files to restore
CONFIG_FILES=(
	"$SCRIPT_DIR/nvim"       # Example: Neovim config
	"$SCRIPT_DIR/kitty"      # Example: Kitty terminal config
	"$SCRIPT_DIR/.tmux.conf" # Example: Tmux config
	"$SCRIPT_DIR/alacritty/alacritty.toml"
	"$SCRIPT_DIR/starship.toml" # Starship config
)

# Define where to move the configurations on the machine
TARGET_DIRS=(
	"$HOME/.config/nvim"
	"$HOME/.config/kitty"
	"$HOME/.tmux.conf"
	"$HOME/.config/alacritty/alacritty.toml"
	"$HOME/.config/starship.toml"
)

# Pull the latest changes from GitHub
cd "$SCRIPT_DIR" || exit
# git pull

# Restore the configuration files by movi# Restore the configuration files with backups
for i in "${!CONFIG_FILES[@]}"; do
	# Check if the target exists
	if [[ -e "${TARGET_DIRS[i]}" ]]; then
		# If a backup already exists, remove it to avoid errors
		if [[ -e "${TARGET_DIRS[i]}_bak" ]]; then
			rm -rf "${TARGET_DIRS[i]}_bak"
		fi
		# Rename the existing target to a backup
		mv "${TARGET_DIRS[i]}" "${TARGET_DIRS[i]}_bak"
		echo "Backup created: ${TARGET_DIRS[i]} -> ${TARGET_DIRS[i]}_bak"
	fi

	# Copy the new configuration to the target
	if [[ -d "${CONFIG_FILES[i]}" ]]; then
		# If source is a directory, copy the directory
		cp -r "${CONFIG_FILES[i]}" "${TARGET_DIRS[i]}"
	elif [[ -f "${CONFIG_FILES[i]}" ]]; then
		# If source is a file, copy the file
		cp "${CONFIG_FILES[i]}" "${TARGET_DIRS[i]}"
	fi
done

# .zshrc
mv "$HOME/.zshrc" "$HOME/.zshrc_bak"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	cp "$SCRIPT_DIR/zsh/linux/.zshrc" "$HOME/.zshrc"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	cp "$SCRIPT_DIR/zsh/macos/.zshrc" "$HOME/.zshrc"
fi
