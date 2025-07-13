# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="/Users/anthony/.oh-my-zsh"

# Set Theme 
ZSH_THEME="powerlevel10k/powerlevel10k"


# Which plugins would you like to load?
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Reset cursor style (add this if not present)
export TERM=xterm-256color

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh


export PATH="$HOME/.local/bin:$PATH"
export PATH="/Users/anthony/.vscode-dotnet-sdk/.dotnet:$PATH"
export PATH="/usr/local/Cellar/node/21.1.0/lib/node_modules:$PATH"

# Function to activate a virtual environment
ax() {
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

# LLVM environment variables
export PATH="/usr/local/opt/llvm/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
export DYLD_LIBRARY_PATH="/usr/local/opt/llvm/lib:$DYLD_LIBRARY_PATH"
export CC="/usr/local/opt/llvm/bin/clang"
export CXX="/usr/local/opt/llvm/bin/clang++"

# Vcpkg (C++ package manager)
export PATH="$HOME/vcpkg:$PATH"
export CMAKE_TOOLCHAIN_FILE="$HOME/vcpkg/scripts/buildsystems/vcpkg.cmake"

# Java
# export JAVA_HOME=$(/usr/libexec/java_home -v 13)
# export PATH="/usr/local/opt/openjdk/bin:$PATH"
# export JAVA_HOME=$(/usr/libexec/java_home -v 24)
# export PATH="/usr/local/opt/openjdk/bin:$PATH"
# export JAVA_HOME=$(/usr/libexec/java_home -v 24)
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-24.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Kitty
KITTY_OS="macos"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
export PATH="$HOME/.forge/bin:$PATH"
export MACOSX_DEPLOYMENT_TARGET=13.0
export PATH="$HOME/.config/midas/bin:$PATH"

