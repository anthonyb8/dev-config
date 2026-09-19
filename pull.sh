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

# Define the GitHub repo directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS=$(os)

# Define the directories/files to restore
CONFIG_FILES=(
  "$SCRIPT_DIR/nvim"
  "$SCRIPT_DIR/tmux/.tmux.conf"
  "$SCRIPT_DIR/tmux/.tmux"
  "$SCRIPT_DIR/claude/CLAUDE.md"
  "$SCRIPT_DIR/claude/OPINIONS.md"
  "$SCRIPT_DIR/claude/VOICE.md"
  "$SCRIPT_DIR/claude/skills"
)

# Define where to move the configurations on the machine
TARGET_DIRS=(
  "$HOME/.config/nvim"
  "$HOME/.tmux.conf"
  "$HOME/.tmux"
  "$HOME/.claude/CLAUDE.md"
  "$HOME/.claude/OPINIONS.md"
  "$HOME/.claude/VOICE.md"
  "$HOME/.claude/skills"
)

git pull

update() {
  # Ensure parent dirs that may not exist on a fresh machine
  mkdir -p "$HOME/.claude"

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
      echo "Copied ${CONFIG_FILES[i]} ${TARGET_DIRS[i]}"
    elif [[ -f "${CONFIG_FILES[i]}" ]]; then
      # If source is a file, copy the file
      cp "${CONFIG_FILES[i]}" "${TARGET_DIRS[i]}"
      echo "Copied ${CONFIG_FILES[i]} ${TARGET_DIRS[i]}"
    fi
  done

  # linear-tui settings. Only config.json and prompts.json are tracked;
  # credentials.json is deliberately left alone so pulling never logs you out.
  mkdir -p "$HOME/.linear-tui"
  for f in config.json prompts.json; do
    if [[ -f "$SCRIPT_DIR/linear/$f" ]]; then
      [[ -f "$HOME/.linear-tui/$f" ]] && mv "$HOME/.linear-tui/$f" "$HOME/.linear-tui/${f}_bak"
      cp "$SCRIPT_DIR/linear/$f" "$HOME/.linear-tui/$f"
      echo "Copied $SCRIPT_DIR/linear/$f $HOME/.linear-tui/$f"
    fi
  done

  # .zshrc
  mv "$HOME/.zshrc" "$HOME/.zshrc_bak"
  mv "$HOME/.config/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml_bak"

  case "$OS" in
  "arch")
    cp "$SCRIPT_DIR/zsh/arch/.zshrc" "$HOME/.zshrc"
    cp "$SCRIPT_DIR/alacritty/arch/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

    mkdir -p "$HOME/.config/kitty"
    [[ -f "$HOME/.config/kitty/kitty.conf" ]] && mv "$HOME/.config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf_bak"
    cp "$SCRIPT_DIR/kitty/arch/kitty.conf" "$HOME/.config/kitty/kitty.conf"

    mv "$HOME/.config/rofi/config.rasi" "$HOME/.config/rofi/config.rasi_bak"
    cp "$SCRIPT_DIR/rofi/config.rasi" "$HOME/.config/rofi/config.rasi"

    mv "$HOME/.config/mpd/mpd.conf" "$HOME/.config/mpd/mpd.conf_bak"
    cp "$SCRIPT_DIR/mpd/mpd.conf" "$HOME/.config/mpd/mpd.conf"

    mv "$HOME/.config/rmpc/config.ron" "$HOME/.config/rmpc/config.ron_bak"
    cp "$SCRIPT_DIR/rmpc/config.ron" "$HOME/.config/rmpc/config.ron"

    ;;
  "debian")
    cp "$SCRIPT_DIR/zsh/debian/.zshrc" "$HOME/.zshrc"
    cp "$SCRIPT_DIR/alacritty/debian/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
    ;;
  "darwin")
    cp "$SCRIPT_DIR/zsh/macos/.zshrc" "$HOME/.zshrc"
    cp "$SCRIPT_DIR/alacritty/macos/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
    ;;
  *)
    echo "Invalid OS."
    ;;
  esac
}

# Add, commit, and push the changes to GitHub
if [ "$AUTO_YES" == true ]; then
  update
else
  read -rp "Do you want to update system config? [y/N]" answer
  if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "Skipping system update"
    exit 0
  else
    update
  fi

fi
