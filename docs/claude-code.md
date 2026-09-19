# Claude Code notes

Reference for the three things that are easy to forget: what config files do what,
how to run more than one version, and the tmux project session in this repo.

---

## 1. CLAUDE.md vs skills vs commands vs settings.json

Four different mechanisms, often confused. The difference is **when they enter the
context window** and **who executes them**.

| File | Loaded | Executed by | Use for |
|---|---|---|---|
| `CLAUDE.md` | every turn, always | the model (as instructions) | rules that must always hold |
| `skills/<name>/SKILL.md` | description always, body on demand | the model | procedures used occasionally |
| `commands/<name>.md` | only when you type `/<name>` | the model | prompt templates you invoke |
| `settings.json` | at startup | **the harness**, not the model | permissions, hooks, env, statusline |

### CLAUDE.md

Auto-loaded instruction files. Precedence, all of which stack:

```
~/.claude/CLAUDE.md          every project on this machine  (currently: the git rules)
<repo>/CLAUDE.md             checked in, shared with the team
<repo>/sub/dir/CLAUDE.md     loaded when files under that dir are touched
```

`/init` generates a starter one from the codebase. Costs context on *every* turn, so
keep it short — long CLAUDE.md files are the most common cause of a bloated context.
`#` at the start of a prompt appends a line to memory without editing the file by hand.

### Skills

A folder, not a file:

```
~/.claude/skills/<name>/SKILL.md      all projects
<repo>/.claude/skills/<name>/SKILL.md project-local, checked in
```

```markdown
---
name: deploy-endo
description: Deploy the endo app to staging or prod. Use when asked to deploy, ship, or release endo.
---

1. Run the migration check: `npm run db:check`
2. ...
```

Only the `description` sits in context; the body loads when the description matches what
you asked, or when you type `/deploy-endo` explicitly. That is the whole point — it's how
you add a dozen procedures without paying a dozen procedures' worth of context every turn.
The `description` is what gets matched, so write it in terms of trigger words, not prose.

A skill folder can also carry scripts and reference files next to `SKILL.md`, which the
model reads or runs only if it needs them.

### settings.json

The only one the harness itself acts on. `~/.claude/settings.json` currently holds the
`deny` list for git write commands, `defaultMode: plan`, the statusline command, and the
theme. **Hooks go here** — anything phrased "every time X happens, do Y" cannot be a
memory or a CLAUDE.md line, because the model isn't guaranteed to be the one running.

Precedence: enterprise policy → `.claude/settings.local.json` → `.claude/settings.json`
→ `~/.claude/settings.json`.

`~/.claude/settings.json` is tracked in this repo as `claude/settings.json` and synced by
`push.sh` and `pull.sh`, so the git deny list comes up on a fresh machine rather than
having to be rebuilt by hand.

---

## 2. Running multiple versions on one machine

Yes, several ways. The catch is that `~/.claude` (auth, history, settings, projects) is
**shared** unless you isolate it with `CLAUDE_CONFIG_DIR`.

Current install here: npm global under nvm, with `autoUpdates: false`.
`claude --version` says which build you are on.

### Throwaway pin — no install

```sh
npx -y @anthropic-ai/claude-code@<version>
```

### Native side-by-side builds

```sh
claude install <version>   # specific version
claude install stable
claude install latest
```

### Per-nvm-node globals

Each node version has its own global prefix, so this already gives you isolation:

```sh
nvm install 20 && nvm use 20 && npm i -g @anthropic-ai/claude-code@<version>
nvm use 22    # back to the everyday install
```

### Isolating config as well as binary

```sh
# ~/.zshrc
claude-next()   { CLAUDE_CONFIG_DIR="$HOME/.claude-next" npx -y @anthropic-ai/claude-code@latest "$@"; }
claude-stable() { CLAUDE_CONFIG_DIR="$HOME/.claude"      command claude "$@"; }
```

A separate `CLAUDE_CONFIG_DIR` means separate auth, history, MCP servers and settings —
useful when testing a version you don't want touching your real session history.

### Before installing a second version, try these

Most "is it the version?" questions are really "is it my config?":

```sh
claude --safe-mode    # disables CLAUDE.md, skills, plugins, hooks, MCP, commands, themes
claude --bare         # even more minimal; skips hooks, LSP, plugin sync, CLAUDE.md discovery
claude doctor         # health check of the install
```

---

## 3. The project tmux session

Lives in `tmux/.tmux/` in this repo, mirrored to `~/.tmux/`. One preset, four windows,
all rooted in the project directory:

```
1 dev                        2 linear        3 git          4 deploy
┌────────────┬──────────┐    ┌──────────┐    ┌──────────┐   ┌──────┬──────┐
│            │          │    │          │    │          │   │ build│ test │
│    nvim    │  claude  │    │linear-tui│    │ lazygit  │   ├──────┴──────┤
│            │          │    │          │    │          │   │   deploy    │
└────────────┴──────────┘    └──────────┘    └──────────┘   └─────────────┘
```

Alt+1–4 jumps between them. The three `deploy` panes are plain shells, just titled — the
stacks here vary too much to prefill a command.

```sh
tm bridg          # start, or return to, the session for ~/projects/bridg
tm                # uses the current directory
tm ~/some/path    # any path works too
```

`prefix + S` opens a `gum` picker over `~/projects` and does the same thing. Re-running
attaches to the existing session rather than rebuilding it — same command to start work and
to come back to it. Session name is the project's directory name (`.` becomes `_`, because
tmux treats it as a target separator).

`prefix + s` still does what it always did: switch between sessions that already exist.
`prefix + n` still makes a plain empty one.

Override the agent command per session:

```sh
CLAUDE_CMD="claude --model sonnet" tm bridg
```

### linear-tui

Window 2 runs [linear-tui](https://github.com/roeyazroel/linear-tui), Go, talking to Linear's
GraphQL API directly. You run a personal fork at `github.com/anthonyb8/linear-tui` which keeps
upstream's module path so merges stay clean. That also means the fork URL is not
`go install`-able, so it is installed from a clone:

```sh
git clone git@github.com:anthonyb8/linear-tui.git ~/projects/linear-tui
cd ~/projects/linear-tui && make install   # needs go >= 1.24, installs to ~/go/bin
linear-tui auth login                      # OAuth, opens a browser
lt-update                                  # pull + reinstall (shell function in .zshrc)
```

`linear-tui --version` tells you which build you are on.

For keybindings press `?` in the app. They have moved between versions, so the running build
is the source of truth rather than a table here.

Config lives in `~/.linear-tui/`. `config.json` and `prompts.json` are tracked in this repo
under `linear/` and synced by `push.sh` and `pull.sh`. `credentials.json` holds the OAuth
token and is deliberately not tracked: `.gitignore` blocks it, and `pull.sh` never touches
it, so syncing settings will not log you out.

`docs/setup.md` has the rest of the install notes, including the `density` setting and the
macOS caveat about `log_file` being an absolute path.

It's launched with `send-keys` rather than as the window's command, so if it exits, or isn't
authenticated yet, the window drops to a shell instead of disappearing.

### Related built-ins worth knowing

```sh
claude --worktree feature-x --tmux=classic   # git worktree + its own tmux session
claude --name endo-refactor                  # labels the session in the terminal title
```
