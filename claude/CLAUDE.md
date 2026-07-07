# Git

- Always use `git mv` when moving or renaming files in a git repo — plain `mv` loses history when files have been edited
- Always ask before running `git add`, `git commit`, or any command that modifies git history — don't do it autonomously.
- Always stage and commit in two separate steps so the user can review what got staged before the commit runs.
- Once confirmed, run `git commit` **and** `git push` together as one action — no need for another confirmation before the push.

---

# Permissions

Before adding a Bash/tool permission rule anywhere (project `.claude/settings.json`, `settings.local.json`, etc.), check
the global `~/.claude/settings.json` first. Don't duplicate an existing global rule into a project-local file; add
genuinely new rules to the global file instead unless there's a specific reason to scope one to a single project.

---

# Formatting

Keep the lines in markdown files to be 120 characters or less to improve readability

---

# Preferences storage

When storing a new remembered behavior or piece of information, use this guide to pick the right location:

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

# Task Tracking

If the project has a `README.md`, use it to document active plans and simple tasks.

Always update it and any active plan files before committing.

When a task is done, specify the resolution details by updating the plan or the sub-heading and commit the change.
Then, delete the plan or the sub-heading and commit again. Any history worth preserving will be maintained in git.

## Simple tasks

If the task is simple enough to not require a full plan, document it in the README file itself by putting it after the
main section content and roughly use this format:

```
## Pending tasks

### DOING <short description>

<problem statement paragraph>

**Status**
<current status / what's been tried / what's pending>

### TODO <short description>

<problem statement paragraph>
```

Prepend each pending task with a status keyword and make it a sub-heading. Track status via `TODO` -> `DOING` ->
`DONE`/`CANCEL`.

- `TODO` means work hasn't started — no `**Status**` section needed, the problem statement is enough.
- `DOING`, `DONE`, and `CANCEL` all represent progress made, so they get a `**Status**` section describing what's been
  tried, what's pending, or (for `DONE`/`CANCEL`) the resolution. Don't include a resolution date in the status text —
  git history already has it, and it's not useful in the note itself.
- Order tasks within a section as `DONE`/`CANCEL` -> `DOING` -> `TODO`, so resolved/active work sits above untouched
  items.

Note that the sub-heading level denoted above is just an example. Create individual TODOs one level lower than whatever
heading is used to track them in the document.

## Plans

Use plans for more complicated multi-step tasks

Give sensible names to plan files (e.g. `vault-mcp-integration.md`) instead of using auto-generated random names.

Within plan files, simple tasks may be ticked `- [x]`; complex phases get a Status sub-heading instead using the same
format described in the previous section.

---

# Pushing Back

When I state a choice or config value is deliberate/intentional, but you have concrete technical evidence it will cause
(or is causing) a problem I don't actually want, push back explicitly and show the evidence — don't just defer and
comply. State the mechanism plainly, show the evidence (a config dump, an actual file path, a test result), and ask
whether the outcome I described is really what I want, rather than softening it into a hedge.
