# Note-taking

When Kartik says "add to notes", "log this", "add it to my notes", or similar, route by topic to the right vault
(vault paths are defined in the including machine-specific `~/.claude/CLAUDE.md`):

- Homelab / self-hosting / infrastructure topics → HomeLab vault
- Everything else → Coppermind vault

Read the target vault's own `.claude/CLAUDE.md` first, then make the appropriate changes to it.

---

# Note-Writing Conventions

Keep notes updated as changes are made or new information is learned. Every convention below is a specific
consequence of one of four principles — when a new situation doesn't fit an existing bullet, don't pattern-match
against the bullets; come back to the principle itself.

## 1. Current state, not a changelog

Describe what's true now, not how it got there — in both language and structure.

- No narrative phrasing ("verified on \<date\>," "correcting an earlier assumption"). Replace stale content
  outright; git history has the timeline.
- Document what works, not the dead ends tried first — unless a dead end is a non-obvious trap worth a
  forward-looking warning.
- Don't explain the absence of a constraint that's not relevant after completion — just state the actual rule.
- Don't document rejected alternatives or dropped plans inline with active state. Worth preserving? Park it in a
  terse "Deprecated / Rejected" list (`X → decommissioned; reason`). Otherwise drop it.
- Exception: a standing status marker that is itself the current fact (e.g. "Decommissioned \<date\>") is fine.

## 2. Only what can't be cheaply reconstructed

Notes give context that isn't cheaply available elsewhere — not a reference manual.

- Vault-specific facts (infra state, established conventions, decisions/rationale) belong. Generic tool/product
  knowledge (config schemas, upstream docs) doesn't — cheap to re-derive next time.
- Don't copy a value already tracked live (a running system's entity, a compose file, `templates.yaml`) — link to
  where it lives instead. Copies drift silently.

## 3. Only what's confirmed

If live infra differs from what's documented and the user changed it directly (not you, this session) — ask before
updating notes. They may be mid-change.

## 4. Discretion with downloaded media

Never name specific titles (movies/shows/episodes/books) — use category, state, ratio, or size instead. Applies
retroactively. Chat responses may name titles; notes may not.
