# Global rules

## General

- Never use the em dash "—". Use plain dash "-" instead.
- When writing commit messages, NEVER auto-add your agent name as co-author.
- Never manually modify CHANGELOG.md files or any files marked as auto-generated.
- When writing or substantially editing long Markdown files, put each full sentence on its own line.
  Preserve normal Markdown structure, but avoid wrapping multiple sentences onto one physical line.
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- When doing bug fixes, always start with reproducing the bug in an E2E test as closely aligned with
  how an end user would hit it.
  This makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be obsessed with visual
  perfection.
- Keep the diff to what was asked. If you find something broken that you were not sent to fix - a
  lint error, a failing test, an unrelated bug - report it when you finish. Do not fix it.

## Git

Never commit, push, or otherwise change git state. This includes `git commit`,
`git push`, `git add`, `git merge`, `git rebase`, `git reset`, `git checkout`,
`git stash`, `git branch -d`, `git tag`, `git config`, and any `gh` command that
creates or modifies a PR, release, or repo.

When work is finished, leave every change in the working tree and tell me:

- which files you touched and why
- the exact command I should run to commit or push it

Do not offer to commit, do not ask for permission to commit, and do not route
around this with wrappers (`bash -c`, shell scripts, aliases, `gh api`).

Read-only git is fine and encouraged: `status`, `log`, `diff`, `show`, `blame`.

## Parallel work across worktrees

When fanning work out so several agents can run at once, lease worktrees from the treehouse pool
rather than calling `git worktree add`.
`treehouse get --lease --json` prints a path and never prompts, `treehouse return <path>` releases
one and kills anything still running in it, and `treehouse status` shows the whole pool.
The pool is pre-provisioned by the `post_create` hook in `~/.config/treehouse/config.toml`, so a
leased tree already has its dependencies and env files and can build immediately.
Hooks only work in that user-level file; hooks in a repo-level `treehouse.toml` are ignored on
purpose, so never try to add them there.

Two entry points, both mine:

- `th <branch> [base]` leases one tree and starts a branch in it, `thr` returns it.
  Shell functions in `~/.zshrc`, for working in a tree myself.
- `~/.local/bin/agent-fanout` is the batch form: one tree per task, each on its own branch, an
  agent launched in each.

Treehouse hands out worktrees detached at `origin/HEAD`, so the base branch always has to be named
when the repo merges into anything else.

**Neither is a way around the Git rule above.**
Do not invoke them, or any wrapper like them, to create branches on my behalf.

`~/dev-config/docs/workflow.md` is the full loop and the source of truth; it is cloned on every
machine. Keep this section short and send me there rather than restating it.

Choosing how to launch the agents, which is a real trade-off and not a free choice.
Both halves below were tested directly:

- **`claude --bg` in a leased pool worktree.**
  Gets the named branch, the right base, and a tree already provisioned by the hook.
  The session is attachable with `claude attach <id>`, so it can be taken over mid-flight.
  Cost: these are independent top-level sessions, so they appear as siblings of the parent chat,
  not nested under it, and their results have to be read from their own transcripts.
  This is the default for real work.
- **Agent subagents.**
  These nest under the parent chat and return results directly, but they cannot be pointed at a
  worktree that already exists.
  A subagent starting at the repository root is refused: "switching is only available to sessions
  whose working directory is inside a worktree of this repository."
  Launching one with worktree isolation gives it a worktree of its own, but under
  `.claude/worktrees/` on an auto-generated branch based on `origin/HEAD`, with no dependencies
  installed, which bypasses the pool and its hook entirely.
  Good for read-only probes and analysis; not for work that has to land on a named branch.

So nesting and a provisioned named-branch worktree cannot currently be combined.
When the work becomes a PR, take `claude --bg` and accept the flat session list.

Before assuming tasks can run in parallel, check whether the project has a local service that only
runs one instance at a time, such as a database or an emulator on fixed ports.
Work that touches it has to be serialised even when the worktrees are independent.

## My opinions

When a technical decision would benefit from my viewpoint rather than a default, read
`~/.claude/OPINIONS.md` before deciding.

## My voice

Before writing anything in my name - commit messages, PR descriptions, issues, code review comments,
READMEs, docs, email, chat messages - read `~/.claude/VOICE.md`.
