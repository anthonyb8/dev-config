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

# Editor
export EDITOR=nvim
export VISUAL=nvim

# Tmux  
DISABLE_AUTO_TITLE="true"

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local


# Created by `pipx` on 2026-05-04 12:52:11
# export PATH="$PATH:/home/anthony/.local/bin"
