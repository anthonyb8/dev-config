# dev-config

My dotfiles: shell, terminal, editor and desktop config for every machine I work on.
Every live config path is a symlink into this repository, so editing the live file edits the repository and a `git pull` is the whole update on another machine.

## Install

```sh
git clone git@github.com:anthonyb8/dev-config.git ~/dev-config
~/dev-config/link.sh            # link everything; safe to re-run
~/dev-config/link.sh --check    # report drift without changing anything
```

`link.sh` links the files that apply to the machine's OS and role.
A headless server gets the server `.zshrc` and none of the desktop config; mark one with `echo server > ~/.config/dev-config/role`.

Re-running it repairs a link an application replaced with a regular file, keeping whichever copy is newer.

## What lives where

| Path | Linked to |
|---|---|
| `nvim/` | `~/.config/nvim` |
| `tmux/` | `~/.tmux.conf`, `~/.tmux/`; the project session is described in [docs/tmux.md](docs/tmux.md) |
| `zsh/<os or role>/` | `~/.zshrc` |
| `alacritty/<os>/` | `~/.config/alacritty/alacritty.toml` |
| `linear/` | `~/.linear-tui/config.json`, `prompts.json` (never the credentials) |
| `rofi/`, `mpd/`, `rmpc/` | desktop config, Arch workstations only |
| `devproxy/` | a "Server Browser" launcher and an always-on `devproxy` user service, Linux workstations only; see harness's `docs/dev-servers.md` |
| `gnome/` | nothing: scripts run by hand that write straight to dconf |

## Kept elsewhere

- **The Claude Code setup** is its own repository, `~/harness`, with organisation packs in a private `~/harness-packs`.
  `link.sh` runs the harness's installer when it finds them.
- **Claude memory** belongs in a private `~/dev-memory`, which `link.sh` links when it exists.
  This repository is public, so nothing private or specific to a client goes in it.

[docs/setup.md](docs/setup.md) has the package install notes for a new machine.
