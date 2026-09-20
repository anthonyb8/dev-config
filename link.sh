#!/bin/bash
# Point every live config location at its file in this repo, so editing the
# live path edits the repo and a `git pull` is the whole update on another
# machine. Idempotent: safe to re-run, and safe on a timer.
#
# Re-running also repairs links that an application broke. An app that saves
# by writing a temp file and renaming it over the target replaces the symlink
# with a regular file, and the two copies drift apart silently from then on.

set -uo pipefail

MODE="link"
case "${1:-}" in
--check) MODE="check" ;;
--help)
  echo "Usage: link.sh [--check]"
  echo "  --check  report drift without changing anything"
  exit 0
  ;;
esac

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

# Memory lives in its own repository, never in this one. This repo is public;
# memory files describe private client codebases, so a copy here would publish
# them. Override the location with DEV_MEMORY_REPO.
MEMORY_REPO="${DEV_MEMORY_REPO:-$HOME/dev-memory}"

LINKED=0
ADOPTED=0
RESTORED=0
DRIFT=0

# Repo path and live path, one pair per line. Directories are linked as
# directories so a file added on one machine appears on the others without
# re-running this script.
PAIRS=(
  "$SCRIPT_DIR/nvim|$HOME/.config/nvim"
  "$SCRIPT_DIR/tmux/.tmux.conf|$HOME/.tmux.conf"
  "$SCRIPT_DIR/tmux/.tmux|$HOME/.tmux"
  "$SCRIPT_DIR/claude/CLAUDE.md|$HOME/.claude/CLAUDE.md"
  "$SCRIPT_DIR/claude/OPINIONS.md|$HOME/.claude/OPINIONS.md"
  "$SCRIPT_DIR/claude/VOICE.md|$HOME/.claude/VOICE.md"
  "$SCRIPT_DIR/claude/settings.json|$HOME/.claude/settings.json"
  "$SCRIPT_DIR/claude/skills|$HOME/.claude/skills"
  "$SCRIPT_DIR/treehouse/config.toml|$HOME/.config/treehouse/config.toml"
  "$SCRIPT_DIR/bin/agent-fanout|$HOME/.local/bin/agent-fanout"
  "$SCRIPT_DIR/linear/config.json|$HOME/.linear-tui/config.json"
  "$SCRIPT_DIR/linear/prompts.json|$HOME/.linear-tui/prompts.json"
)

# Per-OS variants stay separate files; each machine links the one that applies.
case "$OS" in
"arch")
  PAIRS+=(
    "$SCRIPT_DIR/zsh/arch/.zshrc|$HOME/.zshrc"
    "$SCRIPT_DIR/alacritty/arch/alacritty.toml|$HOME/.config/alacritty/alacritty.toml"
    "$SCRIPT_DIR/kitty/arch/kitty.conf|$HOME/.config/kitty/kitty.conf"
    "$SCRIPT_DIR/rofi/config.rasi|$HOME/.config/rofi/config.rasi"
    "$SCRIPT_DIR/mpd/mpd.conf|$HOME/.config/mpd/mpd.conf"
    "$SCRIPT_DIR/rmpc/config.ron|$HOME/.config/rmpc/config.ron"
  )
  ;;
"debian")
  PAIRS+=(
    "$SCRIPT_DIR/zsh/debian/.zshrc|$HOME/.zshrc"
    "$SCRIPT_DIR/alacritty/debian/alacritty.toml|$HOME/.config/alacritty/alacritty.toml"
  )
  ;;
"darwin")
  PAIRS+=(
    "$SCRIPT_DIR/zsh/macos/.zshrc|$HOME/.zshrc"
    "$SCRIPT_DIR/alacritty/macos/alacritty.toml|$HOME/.config/alacritty/alacritty.toml"
  )
  ;;
*)
  echo "Unknown OS; linking the OS-neutral files only."
  ;;
esac

# Claude writes per-project memory under a directory named for the project's
# absolute path, so the paths have to match across machines for these to line
# up. Linking both directions means memory pulled from another machine is in
# place before Claude first runs against that project here.
memory_pairs() {
  local d enc
  for d in "$HOME"/.claude/projects/*/memory; do
    [[ -e "$d" || -L "$d" ]] || continue
    enc=$(basename "$(dirname "$d")")
    echo "$MEMORY_REPO/$enc|$d"
  done
  for d in "$MEMORY_REPO"/*; do
    [[ -d "$d" ]] || continue
    enc=$(basename "$d")
    echo "$d|$HOME/.claude/projects/$enc/memory"
  done
}

# Newer wins. A file the repo just pulled is newer than the live one and should
# replace it; a file an app just rewrote is newer than the repo's and its
# content is taken into the repo instead of being thrown away. Either way the
# displaced copy is kept as .bak.
adopt_or_restore() {
  local repo="$1" live="$2"

  if [[ "$live" -nt "$repo" ]]; then
    [[ "$MODE" == "check" ]] && {
      echo "DRIFT (live is newer): $live"
      DRIFT=$((DRIFT + 1))
      return
    }
    rm -rf "${repo}.bak"
    cp -a "$repo" "${repo}.bak"
    rm -rf "$repo"
    cp -a "$live" "$repo"
    rm -rf "$live"
    ln -s "$repo" "$live"
    echo "adopted  $live -> $repo (live was newer; previous repo copy at ${repo}.bak)"
    ADOPTED=$((ADOPTED + 1))
  else
    [[ "$MODE" == "check" ]] && {
      echo "DRIFT (repo is newer): $live"
      DRIFT=$((DRIFT + 1))
      return
    }
    rm -rf "${live}.bak"
    mv "$live" "${live}.bak"
    ln -s "$repo" "$live"
    echo "restored $live -> $repo (displaced copy at ${live}.bak)"
    RESTORED=$((RESTORED + 1))
  fi
}

link_one() {
  local repo="$1" live="$2"

  if [[ ! -e "$repo" ]]; then
    # Nothing tracked yet. A live file here is the one to keep, so move it in.
    if [[ -e "$live" && ! -L "$live" ]]; then
      [[ "$MODE" == "check" ]] && {
        echo "UNTRACKED: $live"
        DRIFT=$((DRIFT + 1))
        return
      }
      mkdir -p "$(dirname "$repo")"
      mv "$live" "$repo"
      ln -s "$repo" "$live"
      echo "adopted  $live -> $repo (was untracked)"
      ADOPTED=$((ADOPTED + 1))
    fi
    return
  fi

  # Compared against the raw link text, not a resolved path: BSD readlink has
  # no portable -f, and every link here is created with the absolute repo path.
  if [[ -L "$live" && "$(readlink "$live")" == "$repo" ]]; then
    LINKED=$((LINKED + 1))
    return
  fi

  [[ "$MODE" == "link" ]] && mkdir -p "$(dirname "$live")"

  # A stale or wrong symlink carries no content worth keeping.
  if [[ -L "$live" ]]; then
    [[ "$MODE" == "check" ]] && {
      echo "WRONG LINK: $live -> $(readlink "$live")"
      DRIFT=$((DRIFT + 1))
      return
    }
    rm "$live"
    ln -s "$repo" "$live"
    echo "relinked $live -> $repo"
    LINKED=$((LINKED + 1))
    return
  fi

  if [[ -e "$live" ]]; then
    adopt_or_restore "$repo" "$live"
    return
  fi

  [[ "$MODE" == "check" ]] && {
    echo "MISSING: $live"
    DRIFT=$((DRIFT + 1))
    return
  }
  ln -s "$repo" "$live"
  echo "linked   $live -> $repo"
  LINKED=$((LINKED + 1))
}

if [[ "$MODE" == "link" ]]; then
  mkdir -p "$HOME/.claude" "$HOME/.config/treehouse" "$HOME/.local/bin" \
    "$HOME/.linear-tui"
fi

for pair in "${PAIRS[@]}"; do
  link_one "${pair%%|*}" "${pair##*|}"
done

if [[ -d "$MEMORY_REPO" ]]; then
  while IFS= read -r pair; do
    [[ -n "$pair" ]] || continue
    link_one "${pair%%|*}" "${pair##*|}"
  done < <(memory_pairs | sort -u)
else
  echo "Skipping memory: $MEMORY_REPO does not exist."
  echo "  Create it as a PRIVATE repo, then re-run. Memory must not go in this public repo."
fi

if [[ "$MODE" == "check" ]]; then
  echo
  echo "$DRIFT item(s) need attention. Run link.sh to fix."
  [[ "$DRIFT" -gt 0 ]] && exit 1
  exit 0
fi

echo
echo "linked $LINKED, adopted $ADOPTED, restored $RESTORED"
echo "Review with: git -C $SCRIPT_DIR status"
