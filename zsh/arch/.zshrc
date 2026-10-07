#.zshrc

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="$HOME/.secretz/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"          # go install binaries (linear-tui)

# linear-tui: personal fork at github.com/anthonyb8/linear-tui.
# Installed from the clone rather than `go install <url>@latest`, because the
# fork keeps upstream's module path so merges stay clean.
export LINEAR_TUI_SRC="${LINEAR_TUI_SRC:-$HOME/projects/linear-tui}"

# Pull and reinstall, without leaving the current directory.
lt-update() {
  if [[ ! -d "$LINEAR_TUI_SRC" ]]; then
    print -u2 "lt-update: no clone at $LINEAR_TUI_SRC"
    print -u2 "  git clone git@github.com:anthonyb8/linear-tui.git $LINEAR_TUI_SRC"
    return 1
  fi
  make -C "$LINEAR_TUI_SRC" update
}

# Editor
export EDITOR=nvim
export VISUAL=nvim

# Tmux  
DISABLE_AUTO_TITLE="true"

# Project tmux session (~/.tmux/sessions/project.sh)
tm() { ~/.tmux/session.sh "$1"; }

# no-mistakes: local validation gate (config in ~/.no-mistakes/config.yaml)
export NO_MISTAKES_TELEMETRY=off
export NO_MISTAKES_NO_UPDATE_CHECK=1

# Claude Code harness: th, thr, and the harness tools on PATH. See ~/harness.
[[ -f ~/harness/shell/harness.zsh ]] && source ~/harness/shell/harness.zsh

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

