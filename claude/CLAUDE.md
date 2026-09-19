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

## My opinions

When a technical decision would benefit from my viewpoint rather than a default, read
`~/.claude/OPINIONS.md` before deciding.

## My voice

Before writing anything in my name - commit messages, PR descriptions, issues, code review comments,
READMEs, docs, email, chat messages - read `~/.claude/VOICE.md`.
