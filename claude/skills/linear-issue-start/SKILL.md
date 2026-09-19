---
name: linear-issue-start
description: Move a Linear issue to In Progress when work on it begins. Use when starting work on a Linear issue, working on an issue like END-123, implementing or picking up an issue, or beginning a session on a branch whose name contains a Linear issue ID.
---

# Start work on a Linear issue

Moves the issue to **In Progress** and nothing else.
Run this once, when work begins. It is not a status sync and it does not run again at the end.

## 1. Resolve the issue ID

```sh
git rev-parse --abbrev-ref HEAD
```

Match `[A-Za-z]+-[0-9]+` against the branch name, **case-insensitively**, and uppercase the result before using it.
Linear's own suggested branch names are lowercase and prefixed, so a real branch looks like
`feature/end-353-upcoming_birthdays-throws-on-a-29-february-date-of-birth`
and the identifier to extract from it is `END-353`.
A case-sensitive match finds nothing on these branches.

If the branch has no ID, use the identifier the user named in their message.

If neither gives an ID, stop. Say there is no issue to update and carry on with the actual task.
Never guess an ID, and never search Linear for an issue that "looks like" the work.

## 2. Read before writing

Call `mcp__claude_ai_Linear__get_issue` with that identifier.

This confirms the issue exists and shows its current state.
If the tool is unavailable, the Linear connector is not authenticated in this session.
Say so in one line and continue with the task. Do not treat it as an error worth stopping for.

## 3. Transition, but only from a not-started state

| Current state | Action |
|---|---|
| `Backlog`, `Todo` | set to `In Progress` |
| `In Progress` | nothing, already correct |
| `In Review`, `In Staging`, `Done` | **nothing** |
| `Canceled`, `Duplicate` | nothing, and say so: the work may not be wanted |

To transition:

```
mcp__claude_ai_Linear__save_issue(id: "END-123", state: "In Progress")
```

Report what happened in one line, then get on with the task. This is a side effect, not the job.

## 4. Never move an issue forward past In Progress

`In Review`, `In Staging`, and `Done` are earned by an actual push or pull request, which is a manual step here: the no-mistakes pipeline runs with `--skip push,pr,ci` and stops before origin.
A green pipeline means validated locally, not ready for review.

So do not set those states from a skill, a gate result, or a finished task.
Do not move an issue backwards either. Dragging a reviewed issue back to In Progress is worse than leaving the board stale.

## Branch naming

`get_issue` returns Linear's own suggested git branch name for the issue.
Prefer it when creating the branch, since it carries the ID by construction:

```sh
th <branch-name-from-linear>
```

`th` leases a pooled treehouse worktree and creates the branch in it.
