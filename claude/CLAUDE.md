# Git

- Always use `git mv` when moving or renaming files in a git repo — plain `mv` loses history when files have been edited
- Always ask before running `git add`, `git commit`, or any command that modifies git history — don't do it autonomously.
- Always stage and commit in two separate steps so the user can review what got staged before the commit runs.
- When staging, restrict to only the hunks I actually edited this session — including within a file I otherwise
  touched, if other hunks in that same file came from elsewhere (a concurrent session, a direct edit). Don't ask
  each time whether to include other files/hunks found in the working tree; default to mine-only. Only stage
  something else if explicitly told to for that instance — this default doesn't change without being told again.

---

# Hierarchical settings — never edit ~/.claude/settings.json directly

`~/.claude/settings.json` is generated output, not a source file — it's produced by
`~/.config/dotfiles-priv/claude/sync-settings` script, which merges
`~/.config/dotfiles/claude/settings.json` (global) with
`~/.config/dotfiles-priv/claude/<HOSTNAME>/settings.json` (machine-specific) via `jq`, concatenating and
deduping `permissions.allow` from both. Both source files are version-controlled; the generated file is not.

The machine-name argument eg. `FOO`, selects the `dotfiles-priv/claude/FOO/` directory and defaults to `hostname` when omitted

Editing `~/.claude/settings.json` directly still works (nothing enforces the "AUTO-GENERATED" comment at the top), which
makes it easy to silently drift from the version-controlled source — the change looks like it stuck, but a future
`sync-settings` run overwrites it without warning. Always edit the appropriate source file and rerun `sync-settings`
instead.

---

# Formatting

Keep the lines in markdown files to be 120 characters or less to improve readability

---

# Preferences storage

When storing a new remembered behavior or piece of information, use this guide to pick the right location:

**CLAUDE.md files** — instructions for Claude; not intended to be read by people directly. Use this instead of memory
wherever possible as it syncs across devices via git.
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

Give sensible names to plan files (e.g. `vault-mcp-integration.md`) instead of using auto-generated random names.

List any pending tasks under a 'Pending Tasks' heading. Simple tasks may be ticked `- [x]`; for more complex phases use a status-keyword-prefixed sub-heading instead using this format:

```
# Pending tasks

- [Vault MCP integration](vault-mcp-integration.md) — DOING, blocked on auth

## DOING <short description>

<problem statement paragraph>

<what's been tried / what's pending, as plain prose — folded into the body, not a separate **Status** label>

## TODO <short description>

<problem statement paragraph>
```

The task status follows org-mode syntax:
- `TODO` means work hasn't started — the problem statement alone is enough.
- `DOING`, `DONE`, and `CANCEL` all represent progress made, so they get a short paragraph describing what's been
  tried, what's pending, or (for `DONE`/`CANCEL`) the resolution, folded directly into the body. Don't include a
  resolution date — git history already has it.
- Order tasks within a section as `DONE`/`CANCEL` -> `DOING` -> `TODO`, so resolved/active work sits above untouched
  items.

Note that the sub-heading level denoted above is just an example. Create individual TODOs one level lower than
whatever heading is used to track them in the document.

---

# Autonomy

"How would I do X?" / "how does X work?" is a request for an explanation, not authorization to go do X. Answer the
question; don't execute the change unless the message also contains an actual imperative ("do it", "go ahead") or I've
set a standing policy that these questions are green lights. This holds even mid-session after I've had you execute
other changes directly — each request's own phrasing governs whether to act or just explain, on top of the usual bar
for risky/hard-to-reverse actions.

---

# Pushing Back

When I state a choice or config value is deliberate/intentional, but you have concrete technical evidence it will cause
(or is causing) a problem I don't actually want, push back explicitly and show the evidence — don't just defer and
comply. State the mechanism plainly, show the evidence (a config dump, an actual file path, a test result), and ask
whether the outcome I described is really what I want, rather than softening it into a hedge.
