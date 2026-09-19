# Git / Curl / Nvim
sudo apt update 
sudo apt upgrade
sudo apt install curl 
sudo apt install git 
sudo apt install neovim
sudo apt install gnome-tweaks
sudo apt install gnome-shell-extensions
sudo apt install gnome-shell-extension-prefs
sudo apt install neofetch 

# Shell 
sudo apt install zsh 
https://ohmyz.sh/#install

# Tmux 
sudo apt install tmux

# SSH git
ssh-keygen -t rsa -b 4096 -f ~/.ssh/git
cat ~/.ssh/git.pub

#add to github
ssh -T git@github.com

# Rust 
https://www.rust-lang.org/tools/install
source "$HOME/.cargo/env"

# NVM/NODE/NPM/YARN
https://github.com/nvm-sh/nvm?tab=readme-ov-file
nvm install node
npm install --global yarn

# Lazy git 
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

# Nerd Fonts
# Download desired and unzip
https://www.nerdfonts.com/font-downloads 

mkdir -p ~/.local/share/fonts
mv ~/Downloads/FiraCode/* ~/.local/share/fonts/
fc-cache -fv

fc-list | grep "FiraCode"

# Linear TUI -- personal fork (github.com/anthonyb8/linear-tui)
# requires go >= 1.24; installs to ~/go/bin (on PATH via .zshrc)
#
# Installed from a clone, not `go install <url>@latest`: the fork keeps
# upstream's module path (github.com/roeyazroel/linear-tui) so merging
# upstream stays clean, which means the fork URL is not `go install`-able.
git clone git@github.com:anthonyb8/linear-tui.git ~/projects/linear-tui
cd ~/projects/linear-tui && make install

# auth (OAuth, opens a browser; creds -> ~/.linear-tui/credentials.json, 0600)
linear-tui auth login

# update: lt-update  (shell function in .zshrc; pulls and reinstalls)
# which build am I running: linear-tui --version

# settings are tracked in this repo under linear/ and synced by push.sh/pull.sh:
#   linear/config.json    theme, density, default_team, agent settings
#   linear/prompts.json   agent prompt templates
# credentials.json is deliberately NOT tracked (it holds the OAuth token) and
# pull.sh never touches it, so syncing configs will not log you out.
# note: config.json's log_file is an absolute path, so it needs adjusting if
# this is ever pulled onto macOS.

# ui: the details pane is padded under the default "comfortable" density and
# sits inset vs the nav/issue panes -- "compact" drops that padding and the
# blank lines between detail sections (also tightens modals + status bar)
#   set "density": "compact" in ~/.linear-tui/config.json
