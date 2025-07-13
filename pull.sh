#!/bin/bash

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

# Define the directories/files to restore
CONFIG_FILES=(
  "$SCRIPT_DIR/nvim"
  "$SCRIPT_DIR/.tmux.conf"
)

# Define where to move the configurations on the machine
TARGET_DIRS=(
  "$HOME/.config/nvim"
  "$HOME/.tmux.conf"
)
# Define the GitHub repo directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS=$(os)

git pull
echo "$OS"

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

case "$OS" in
"arch")
  cp "$SCRIPT_DIR/zsh/arch/.zshrc" "$HOME/.zshrc"
  ;;
"debian")
  cp "$SCRIPT_DIR/zsh/debian/.zshrc" "$HOME/.zshrc"
  ;;
"darwin")
  cp "$SCRIPT_DIR/zsh/macos/.zshrc" "$HOME/.zshrc"
  ;;
*)
  echo "Invalid OS."
  ;;
esac

# if [[ "$OS" == "linux-gnu"* ]]; then
#   cp "$SCRIPT_DIR/zsh/linux/.zshrc" "$HOME/.zshrc"
# elif [[ "$OSTYPE" == "darwin"* ]]; then
#   cp "$SCRIPT_DIR/zsh/macos/.zshrc" "$HOME/.zshrc"
# fi

# alacritty.toml
mv "$HOME/.config/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml_bak"

case "$OS" in
"arch")
  cp "$SCRIPT_DIR/alacritty/arch/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
  ;;
"debian")
  cp "$SCRIPT_DIR/alacritty/debian/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
  ;;
"darwin")
  cp "$SCRIPT_DIR/alacritty/macos/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
  ;;
*)
  echo "Invalid OS."
  ;;
esac

# if [[ "$OSTYPE" == "linux-gnu"* ]]; then
#   cp "$SCRIPT_DIR/alacritty/linux/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
# elif [[ "$OSTYPE" == "darwin"* ]]; then
#   cp "$SCRIPT_DIR/alacritty/macos/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
# fi
