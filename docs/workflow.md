# Issue to validated branch

Three tools, one loop.

| | |
|---|---|
| **linear-tui** | pick the issue. TUI only, no CLI. |
| **treehouse** | pool of pre-warmed worktrees, one per parallel agent. |
| **no-mistakes** | gate: rebase, lint, test, review, document. Stops before origin. |

## The loop

```sh
th feature/end-353-short-slug     # lease a worktree + create the branch
claude                            # work. Claude moves the issue to In Progress.
no-mistakes axi run --intent "what you set out to do" --skip push,pr,ci
thr                               # return the worktree to the pool
```

Then push and open the PR yourself, and move the issue to In Review or In Staging.
Nothing reaches GitHub without that step.

Branch name comes from Linear (`get_issue` returns it), so the issue ID is always in the branch.
That is how the `linear-issue-start` skill knows which issue to move.
A branch with no `END-nnn` in it means no Linear update, which is the intended behaviour, not a failure.

## Two things that bite

**Pooled worktrees are handed out detached.** `th` creates the branch for you, which is why it exists.
`no-mistakes` gates a branch, so without one it has nothing to run on.

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
treehouse init                    # then set max_trees and hooks.post_create
```

Commit a `.no-mistakes.yaml` with your lint and test commands to the default branch.

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
