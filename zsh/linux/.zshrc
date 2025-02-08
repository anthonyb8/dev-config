# if [ -z "$TMUX" ]; then
#   while true; do
#     read -k 1 "REPLY?Start tmux? [Yn]: "
#     case $REPLY in
#       "y"|"Y"|$'\n') exec tmux new-session -A -s && break ;;
#       "n"|"N") echo "\ntmux not selected" && break;;
#       *) clear && continue ;;
#     esac
#   done
# fi
#
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# source /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export TERM=xterm-256color

# Start tmux automatically
# if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
#   tmux attach -t default || tmux new -s default
# fi


# Map nvim as vim
alias vim='nvim'
export EDITOR='nvim'
alias openfile='/home/linuxbrew/.linuxbrew/bin/nvim'
export NVIM_LISTEN_ADDRESS=/tmp/nvim.sock

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Midas Containers
export POSTGRES_USER="anthony"
export POSTGRES_PASSWORD="password"
export POSTGRES_HOST="172.17.0.1"
export TRADING_DATABASE_URL="postgres://postgres:password@172.17.0.1:5432/trading_data"
export HISTORICAL_DATABASE_URL="postgres://postgres:password@172.17.0.1:5432/market_data"
export INSTRUMENT_DATABASE_URL="postgres://postgres:password@172.17.0.1:5432/market_data"
export HISTORICAL_PORT="8080"
export TRADING_PORT="8081"
export INSTRUMENT_PORT="8082"

export LOG_DIR=/opt/midas/logs
export DATA_DIR=/opt/midas/data
# export POSTGRES_DIR=/opt/midas/postgres
export SCRIPTS_DIR=/opt/midas/scripts
export PROCESSED_DIR=/opt/midas/data/processed_data/
export RAW_DIR=/opt/midas/data/raw_data/
export CONFIG_DIR=~/.config/midas
export BIN_DIR=/usr/local/bin
export LIB_DIR=/usr/local/lib



export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/home/linuxbrew/.linuxbrew/opt/postgresql@16/bin:$PATH"
export PATH="/home/linuxbrew/.linuxbrew/opt/postgresql@14/bin:$PATH"

KITTY_OS="linux"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# # Start tmux automatically
# sleep 0.5
#
# if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
#   export TERM=xterm-256color
#   tmux attach -t default || tmux new -s default
# fi
