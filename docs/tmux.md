# The project tmux session

Lives in `tmux/.tmux/` in this repo, linked to `~/.tmux/`.
One preset, four windows, all rooted in the project directory:

```
1 dev                        2 linear        3 git          4 deploy
┌────────────┬──────────┐    ┌──────────┐    ┌──────────┐   ┌──────┬──────┐
│            │          │    │          │    │          │   │ build│ test │
│    nvim    │  claude  │    │linear-tui│    │ lazygit  │   ├──────┴──────┤
│            │          │    │          │    │          │   │   deploy    │
└────────────┴──────────┘    └──────────┘    └──────────┘   └─────────────┘
```

Alt+1-4 jumps between them.
The three `deploy` panes are plain shells, just titled, because the stacks vary too much to prefill a command.

```sh
tm bridg          # start, or return to, the session for ~/projects/bridg
tm                # uses the current directory
tm ~/some/path    # any path works too
```

`prefix + S` opens a `gum` picker over `~/projects` and does the same thing.
Re-running attaches to the existing session rather than rebuilding it, so the same command starts work and comes back to it.
The session name is the project's directory name, with `.` turned into `_` because tmux treats it as a target separator.

`prefix + s` still switches between sessions that already exist, and `prefix + n` still makes a plain empty one.

Override the agent command per session:

```sh
CLAUDE_CMD="claude --model sonnet" tm bridg
```

The Claude Code setup itself, worktrees and session naming included, lives in `~/harness`; see its `docs/workflow.md`.

## linear-tui

Window 2 runs [linear-tui](https://github.com/roeyazroel/linear-tui), Go, talking to Linear's GraphQL API directly.
You run a personal fork at `github.com/anthonyb8/linear-tui` which keeps upstream's module path so merges stay clean.
That also means the fork URL is not `go install`-able, so it is installed from a clone:

```sh
git clone git@github.com:anthonyb8/linear-tui.git ~/projects/linear-tui
cd ~/projects/linear-tui && make install   # needs go >= 1.24, installs to ~/go/bin
linear-tui auth login                      # OAuth; --no-browser on a headless box
lt-update                                  # pull + reinstall (shell function in .zshrc)
```

`linear-tui --version` tells you which build you are on.
For keybindings press `?` in the app; they have moved between versions, so the running build is the source of truth.

Config lives in `~/.linear-tui/`.
`config.json` and `prompts.json` are tracked in this repo under `linear/` and linked by `link.sh`.
`credentials.json` holds the OAuth token and is deliberately not tracked: `.gitignore` blocks it, and `link.sh` links only the two named files, so syncing settings never logs you out.

`docs/setup.md` has the rest of the install notes, including the `density` setting and the macOS caveat about `log_file` being an absolute path.

It is launched with `send-keys` rather than as the window's command, so if it exits, or is not authenticated yet, the window drops to a shell instead of disappearing.
