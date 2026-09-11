# Git

- Always use `git mv` when moving or renaming files in a git repo — plain `mv` loses history when files have been edited
- Always ask before running `git add`, `git commit`, or any command that modifies git history — don't do it
  autonomously.
- Always stage and commit in two separate steps so the user can review what got staged before the commit runs.

---

# Hierarchical settings — never edit ~/.claude/settings.json directly

`~/.claude/settings.json` is generated output, not a source file — `~/.config/dotfiles-priv/claude/sync-settings`
merges the version-controlled global (`~/.config/dotfiles/claude/settings.json`) with the machine-specific
`~/.config/dotfiles-priv/claude/hosts/<HOSTNAME>/settings.json` via `jq`, concatenating and deduping
`permissions.allow`/`deny`/`ask` from both rather than letting one overwrite the other. The machine-name argument
(e.g. `FOO`) selects `dotfiles-priv/claude/hosts/FOO/` and defaults to `hostname` when omitted.

Editing `~/.claude/settings.json` directly still works, so it silently drifts from the sources — a later
`sync-settings` run overwrites it without warning. Always edit the appropriate source file and rerun
`sync-settings` instead.

---

# Claude Code settings.json permissions

`Write(path)` is not a valid permission rule — Claude Code only matches file-editing checks against `Edit(path)`,
which already covers both the Edit and Write tools (it warns on startup that `Write(path)` "is not matched by file
permission checks"). Never add a separate `Write(path)` entry; a single `Edit(path)` rule is sufficient for a path
that needs both editing and full-file-rewrite permission.

---

# Formatting

Keep the lines in markdown files to be 120 characters or less to improve readability. Exception: never wrap a
`[[wikilink]]` across a line break to hit the limit — keep the whole `[[...]]` on one line even if it runs over.

---

# Preferences storage

When storing a new remembered behavior, rule, or piece of information, pick the location on two axes.

**Target — who is it for?**
- **Claude only** — workflow rules, formatting rules, authoring conventions (e.g. "state a fact once, link don't
  restate"; a service-page vs. strategy-page content split). → a `CLAUDE.md`, or one of the files it `@include`s
  (`notes.md`, `git-workflow.md`, …). Not meant to be read by people directly. Prefer this over memory — it
  version-controls and syncs across devices.
- **People, or people and Claude both** — a project's structure and service list, active plans, pending tasks.
  → `README.md`.

**Scope — how broadly does it apply?**
- **Generally**, across projects and machines (git workflow, formatting, README conventions, how to write a
  note). → the global `CLAUDE.md` (`~/.config/dotfiles/claude/CLAUDE.md`) or a file it includes.
- **This machine's environment** — local paths, machine-specific tooling or shortcuts. → the machine `CLAUDE.md`
  (`~/.claude/CLAUDE.md`).
- **One project only** — that repo's conventions, domain rules. → the repo's `.claude/CLAUDE.md`.

**Memory files** (`~/.claude/projects/.../memory/`) — only when the information is both project-specific AND
machine-specific (so it fits no shared `CLAUDE.md`), or when explicitly asked to.

---

# Task Tracking

Give sensible names to plan files (e.g. `vault-mcp-integration.md`) instead of using auto-generated random names.

List any pending tasks under a 'Pending Tasks' heading. Simple tasks may be ticked `- [x]`; for more complex
phases use a status-keyword-prefixed sub-heading instead using this format:

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
