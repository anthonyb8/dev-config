# Issue to validated branch

Four tools, one loop.

| | |
|---|---|
| **linear-tui** | pick the issue. TUI only, no CLI. |
| **treehouse** | pool of pre-warmed worktrees, one per parallel agent. |
| **no-mistakes** | gate: rebase, lint, test, review, document. Stops before origin. |
| **agent-fanout** | the batch form of `th`: one leased tree per task, each on its own branch, an agent launched in each. |

## The loop

```sh
th feature/end-353-short-slug dev # lease a worktree + create the branch off origin/dev
claude                            # work. Claude moves the issue to In Progress.
no-mistakes axi run --intent "what you set out to do" --skip push,pr,ci
thr                               # return the worktree to the pool
```

The base is optional and defaults to whatever the pool hands out, which is `origin/HEAD`.
Name it whenever the repo merges into something other than its default branch; see "Three things that bite".

Then push and open the PR yourself, and move the issue to In Review or In Staging.
Nothing reaches GitHub without that step.

Branch name comes from Linear (`get_issue` returns it), so the issue ID is always in the branch.
That is how the `linear-issue-start` skill knows which issue to move.
A branch with no `END-nnn` in it means no Linear update, which is the intended behaviour, not a failure.

## Three things that bite

**Pooled worktrees are handed out detached.** `th` creates the branch for you, which is why it exists.
`no-mistakes` gates a branch, so without one it has nothing to run on.

**They are handed out at `origin/HEAD`, not at your integration branch.**
`th <branch>` with no base therefore starts from the remote's default branch.
On endo-supabase that is `main`, while work merges into `dev`, and `dev` runs ahead of it - so a bare `th` there produces a branch that is already behind before you start.
Pass the base: `th <branch> dev`.

**`.no-mistakes.yaml` is read from the default branch.** Put it on a feature branch and it silently does nothing.
Its `commands:` block is what the lint and test steps actually run.

## Where things live

```
~/projects/<repo>                 primary checkout. The gate is init'd here, once.
~/.treehouse/<repo>-<hash>/N/     pool worktrees. You work here.
~/.no-mistakes/worktrees/         the gate's own run trees. Internal, leave alone.
```

The pool worktrees share the primary checkout's `.git`, so the `no-mistakes` remote is visible from all of them.
That is why the gate is only ever initialized once.

## Per repo, first time

```sh
cd ~/projects/<repo>
no-mistakes init                  # primary checkout ONLY
treehouse init                    # writes treehouse.toml: max_trees and root only
```

Commit a `.no-mistakes.yaml` with your lint and test commands to the default branch.

**Hooks do not go in the repo's `treehouse.toml`.** Treehouse ignores them there on purpose, so that running it in an untrusted clone cannot execute checked-in shell.
They live in `~/.config/treehouse/config.toml`, which is machine-wide and tracked in this repo as `treehouse/config.toml`:

```toml
max_trees = 8

[hooks]
post_create = [
  "if [ -f package.json ]; then npm ci; fi",
  "if [ -f ui/package.json ]; then npm ci --prefix ui; fi",
  "if [ -f doppler.yaml ]; then doppler setup --no-interactive && npm run env:pull; fi",
]
```

Each entry is a shell command run in the new worktree, in order.
Guard every one, because this file applies to every repo.
A failing entry is logged but does not abort the lease, so glance at `node_modules` before trusting a fresh tree.

`max_trees` can live here too, which means a repo needs no `treehouse.toml` of its own at all.

The Doppler line is the one that is easy to miss: Doppler's scope is per-directory, so a fresh worktree resolves no project and `npm run env:pull` fails until `doppler setup` has run in it.

## Several issues at once

`agent-fanout` is `th` in batch: it leases one tree per task, branches each off the base you name, and launches an agent in each.

```sh
agent-fanout --base dev \
  "feature/end-296-commission-cap=Implement END-296 ..." \
  "feature/end-356-contract-statuses=Implement END-356 ..."
```

`--serial` runs them one at a time instead, `--dry-run` shows what it would lease, `--holder` labels the leases in `treehouse status`.
It prints a `treehouse return` line per tree when it finishes.

Agents are launched with `claude --bg`, so they are independent sessions: attachable with `claude attach <id>`, but siblings of your session rather than nested under it.
Agent subagents nest, but cannot be pointed at an existing worktree, so they are no use for work that has to land on a named branch.

Before fanning out, check whether the repo has a local service that only runs one instance.
On endo-supabase every worktree shares one Supabase stack on fixed ports, so anything touching the database has to be run serially after the agents finish.

## Useful

```sh
treehouse status                  # what is leased, what is free
treehouse enter <n>               # attach to a tree an agent is using, without disturbing it
treehouse prune                   # dry run by default
no-mistakes axi status            # current run detail
no-mistakes doctor                # health check
```

`gh` is not installed, so the PR and CI steps cannot run even if unskipped.

`docs/claude-code.md` covers the other half: what the tmux project session gives you, and
which Claude Code config file does what.
