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

# treehouse: pooled git worktrees so several agents can share one repo
# NB: the locals below are named wt, not path. In zsh, path is tied to PATH,
# so a local named path breaks command lookup inside the function.
# th <branch> [base]   lease a worktree from the pool and start a branch in it.
# Pooled worktrees are handed out detached, and no-mistakes gates a branch,
# so the branch has to exist before the gate will run.
#
# They are handed out at origin/HEAD, which is the remote's default branch.
# A repo whose work merges into anything else has to name the base, or the
# branch silently starts behind: on endo-supabase origin/dev leads
# origin/main, so `th <branch> dev` is the correct call there.
th() {
  if [[ -z "$1" ]]; then
    print -u2 "usage: th <branch> [base]"
    return 2
  fi
  local wt base="$2"
  # Validate the base before leasing. Checking after would burn a pool slot
  # and leave it held on nothing more than a typo.
  if [[ -n "$base" ]]; then
    git fetch --quiet origin || return
    if ! git rev-parse --verify --quiet "origin/$base" >/dev/null; then
      print -u2 "th: no such base branch: origin/$base"
      return 1
    fi
  fi
  wt=$(treehouse get --lease --lease-holder "${TREEHOUSE_LEASE_HOLDER:-$USER}") || return
  cd "$wt" || return
  if [[ -n "$base" ]]; then
    git switch -c "$1" "origin/$base"
  else
    git switch -c "$1"
  fi
}

# thr [path]    return a worktree to the pool, stepping back to the main
# checkout first so return does not terminate the shell you are standing in.
thr() {
  local wt="${1:-$PWD}" common
  common=$(git -C "$wt" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) \
    && cd "${common:h}"
  treehouse return "$wt"
}

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

