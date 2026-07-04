# Git

- Always use `git mv` when moving or renaming files in a git repo — plain `mv` loses history when files have been edited
- Always ask before running `git add`, `git commit`, or any command that modifies git history — don't do it autonomously.
- Always stage and commit in two separate steps so the user can review what got staged before the commit runs.
- Once confirmed, run `git commit` **and** `git push` together as one action — no need for another confirmation before the push.

---

# Remembered Behaviors

- Keep the lines in markdown files to be 120 characters or less to improve readability
- When storing a new remembered behavior or piece of information, use this guide to pick the right location:

  **CLAUDE.md files** — instructions for Claude; not intended to be read by people directly. Prefer this over memory
  files. Syncs across devices via git.
  - **Global** (`~/.config/dotfiles/claude/CLAUDE.md`, this file) — applies across all projects and machines
    (e.g. git workflow, formatting rules, README conventions)
  - **Machine-specific** (`~/.claude/CLAUDE.md`) — tied to this machine's environment (e.g. local paths,
    machine-specific tooling or shortcuts)
  - **Project-specific** (`.claude/CLAUDE.md` inside the repo) — only relevant within that project
    (e.g. vault conventions, domain-specific rules)

  **Memory files** (`~/.claude/projects/.../memory/`) — only use when the information is both project-specific AND
  machine-specific (i.e. it doesn't belong in a shared CLAUDE.md) OR when explicitly asked to.

  **README.md** — for anything that may need to be referred to by people (active plans, pending tasks, etc.)

---

# README

If the project has a `README.md`, use it to document active plans and simple tasks. Always update it (remove completed
tasks, add new ones) and any active plan files before committing.

Add a plain bullet to it mentioning each active plan.

If the task is simple enough to not require a full plan, document it in the README file itself by putting it after the
main section content and roughly use this format:

```
# Pending tasks

## TODO <short description>

<problem statement paragraph>

**Status**
<current status / what's been tried / what's pending>
```

Prepend each pending task with `TODO` and make it a sub-heading.

When a task is done, specify the resolution details by updating the plan or the sub-heading and commit the change.
Then, delete the plan or the sub-heading and commit again. Any history worth preserving will be maintained in git.

---

# Active Plans

Give sensible names to plan files (e.g. `vault-mcp-integration.md`) instead of using auto-generated random names.

Within plan files, simple tasks may be ticked `- [x]`; complex phases get a Status sub-heading instead. Preserve the
full plan file until the user approves a git commit. When a plan is complete and committed, confirm if the plan file can
be deleted and the bullet removed from the README.
