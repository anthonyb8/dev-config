# If you come from bash you might have to change your $PATH.
# export PATH="/usr/local/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="/Users/anthony/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

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

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
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
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export PATH="$HOME/.local/bin:$PATH"
export PATH="/Users/anthony/.vscode-dotnet-sdk/.dotnet:$PATH"
export PATH="/usr/local/Cellar/node/21.1.0/lib/node_modules:$PATH"

export PATH="/usr/local/opt/python@3.12/bin:$PATH"
alias python3='/usr/local/opt/python@3.12/bin/python3.12'
alias pip3='/usr/local/opt/python@3.12/bin/pip3'

# alias vim='lvim'
# export EDITOR='lvim'
# alias openfile='/usr/local/bin/lvim-open' 
# export NVIM_LISTEN_ADDRESS=/tmp/nvim.sock

alias vim='nvim'
export EDITOR='nvim'
alias openfile='/usr/local/bin/nvim'
export NVIM_LISTEN_ADDRESS=/tmp/nvim.sock


# Reset cursor style (add this if not present)
export TERM=xterm-256color

# Function to activate a virtual environment
act() {
  if [ -f "venv/bin/activate" ]; then
    source "venv/bin/activate"
    # echo "Activated virtual environment: venv"
  else
    echo "No virtual environment found in the current directory."
  fi
}
export NVIM_TUI_ENABLE_TRUE_COLOR=1
unalias deactivate 2>/dev/null

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Load NVM
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Load NVM bash_completion

# PostgreSQL 15 binaries and libraries
export PATH="/usr/local/opt/postgresql@15/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/postgresql@15/lib"
export CPPFLAGS="-I/usr/local/opt/postgresql@15/include"
export PKG_CONFIG_PATH="/usr/local/opt/postgresql@15/lib/pkgconfig"
export DYLD_LIBRARY_PATH="/usr/local/opt/postgresql@15/lib:$DYLD_LIBRARY_PATH"
export PG_HOME="/usr/local/opt/postgresql@15"

# Environment variables for PyO3 (Python-Rust bindings)
export LIBRARY_PATH="/usr/local/opt/openssl/lib:/usr/local/opt/llvm/lib:/usr/local/opt/python@3.12/lib"
export CPATH="/usr/local/opt/openssl/include:/usr/local/opt/llvm/include:/usr/local/opt/python@3.12/include/python3.12"
export PATH="/usr/local/opt/llvm/bin:/usr/local/opt/python@3.12/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl/lib -L/usr/local/opt/llvm/lib -L/usr/local/opt/python@3.12/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include -I/usr/local/opt/llvm/include -I/usr/local/opt/python@3.12/include/python3.12"
export PYO3_PYTHON="/usr/local/opt/python@3.12/bin/python3.12"

# Midas-CLI tool
# export PATH="/usr/local/midas:$PATH"

# Starship prompt
eval "$(starship init zsh)"

# LLVM environment variables
export PATH="/usr/local/opt/llvm/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
export DYLD_LIBRARY_PATH="/usr/local/opt/llvm/lib:$DYLD_LIBRARY_PATH"
export CC="/usr/local/opt/llvm/bin/clang"
export CXX="/usr/local/opt/llvm/bin/clang++"

# Vcpkg (C++ package manager)
export PATH="$HOME/vcpkg:$PATH"
export VCPKG_ROOT="$HOME/vcpkg"
export CMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake"
export CMAKE_PREFIX_PATH="$VCPKG_ROOT/installed/x64-osx:$CMAKE_PREFIX_PATH"

# Alias to deactivate the virtual environment
# alias deactivate="deactivate"

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#
# # PostgreSQL 15 binaries and libraries
# export PATH="/usr/local/opt/postgresql@15/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/postgresql@15/lib"
# export CPPFLAGS="-I/usr/local/opt/postgresql@15/include"
# export PKG_CONFIG_PATH="/usr/local/opt/postgresql@15/lib/pkgconfig"
# export DYLD_LIBRARY_PATH="/usr/local/opt/postgresql@15/lib:$DYLD_LIBRARY_PATH"
# export PG_HOME="/usr/local/opt/postgresql@15"
#
# # Additional environment variables for pyo3 build
# export LIBRARY_PATH="/usr/local/opt/openssl/lib:/usr/local/opt/llvm/lib:/usr/local/opt/python@3.12/lib"
# export CPATH="/usr/local/opt/openssl/include:/usr/local/opt/llvm/include:/usr/local/opt/python@3.12/include/python3.12"
# export PATH="/usr/local/opt/llvm/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/openssl/lib -L/usr/local/opt/llvm/lib -L/usr/local/opt/python@3.12/lib"
# export CPPFLAGS="-I/usr/local/opt/openssl/include -I/usr/local/opt/llvm/include -I/usr/local/opt/python@3.12/include/python3.12"
# export PYO3_PYTHON=/usr/local/opt/python@3.12/bin/python3.12
#
# # Midas-cli tool
# export PATH=$PATH:/usr/local/midas
#
# # Starship
# eval "$(starship init zsh)"
#
# #DELETE
# export MIDAS_URL="http://127.0.0.1:8080"
#
# # LLVM
# export PATH="/usr/local/opt/llvm/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/llvm/lib"
# export CPPFLAGS="-I/usr/local/opt/llvm/include"
#
# # export PATH="/usr/local/opt/llvm/bin:$PATH"
# # export DYLD_LIBRARY_PATH="/usr/local/opt/llvm/lib:$DYLD_LIBRARY_PATH"
# # export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
# # export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
# # export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
# # export CC=clang
# # export CXX=clang++
#
# #Vcpkg 
# export PATH="$HOME/vcpkg:$PATH"
# export VCPKG_ROOT=/Users/anthony/vcpkg
# export CMAKE_TOOLCHAIN_FILE=/Users/anthony/vcpkg/scripts/buildsystems/vcpkg.cmake
#
# export DYLD_LIBRARY_PATH=/usr/local/opt/llvm/lib:$DYLD_LIBRARY_PATH
