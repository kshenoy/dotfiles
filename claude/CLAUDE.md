# Claude Code settings

`~/.claude/settings.json` is generated — never edit it directly. Edit the global
`~/.config/dotfiles/claude/settings.json` or the machine's
`~/.config/dotfiles-priv/claude/hosts/<HOSTNAME>/settings.json`, then rerun
`~/.config/dotfiles-priv/claude/sync-settings`. For file-permission rules use `Edit(path)` only — it covers Write
too; `Write(path)` isn't a valid rule.

---

# Where to store a new rule or fact

Scope — where and to whom it applies — decides the location, not topic.

- For people (or people and Claude): the project's `README.md`.
- For Claude only — scoped by breadth: this global file or one it includes (general); the machine
  `~/.claude/CLAUDE.md` (this machine's environment); the repo's `.claude/CLAUDE.md` (one project).
- Add only what a capable agent wouldn't do by default or easily discover; over-specifying constrains judgment.
- State the intent behind a rule, not just the instruction — a capable agent may be able to infer the instruction if it
  understands the intent and handle cases the rule didn't anticipate. Never choose to preserve just the instruction
  without the intent for brevity.

---

# Notes vaults

When I say "add to notes", "log this", or similar, route by topic: homelab / self-hosting / infrastructure → the
HomeLab vault; everything else → the Coppermind vault (paths are in the machine `CLAUDE.md`). Read the target
vault's own `.claude/CLAUDE.md` first.

---

# Autonomy

"How would I do X?" / "how does X work?" is a request for an explanation, not authorization to do X. Don't execute
unless the message also contains an imperative ("do it", "go ahead") — even mid-session after I've had you execute
other changes directly.

Fix formatting problems (line length, wrapping, broken links, typos) on your own — don't ask.

---

# Commands for me to run

When I need to run something myself, give the exact, complete commands in a single code block I can paste in one
go — no paraphrased steps, placeholders, or commands split across several blocks.

---

# Consumer product claims

When I have a consumer device or its companion app in hand, don't assert its UI capabilities from docs or web
research — ask me to check, or mark the claim as unverified.

---

# Pushing Back

When I state a choice or config value is deliberate/intentional, but you have concrete technical evidence it will cause
(or is causing) a problem I don't actually want, push back explicitly and show the evidence — don't just defer and
comply. State the mechanism plainly, show the evidence (a config dump, an actual file path, a test result), and ask
whether the outcome I described is really what I want, rather than softening it into a hedge.
