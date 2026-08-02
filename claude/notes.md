# Note-taking

When Kartik says "add to notes", "log this", "add it to my notes", or similar, route by topic to the right vault
(vault paths are defined in the including machine-specific `~/.claude/CLAUDE.md`):

- Homelab / self-hosting / infrastructure topics → HomeLab vault
- Everything else → Coppermind vault

Read the target vault's own `.claude/CLAUDE.md` first, then make the appropriate changes to it.

---

# Note-Writing Conventions

Keep notes updated as changes are made or new information is learned. Notes exist to give context that can't be
cheaply reconstructed — not to be a reference manual. Before adding something, ask whether it's vault-specific
(infrastructure state, conventions established, decisions/rationale for a setup) or generic tool/product knowledge
(how some software's config schema works, upstream behavior documented in its own docs). Only the former belongs in
notes; the latter can be re-derived or re-looked-up next time with little effort. This extends to config content and
live system state: if a value is already tracked by a running system (e.g. an entity a Home Assistant integration
exposes) or lives in a named, directly-readable file (a compose file, a `templates.yaml`), don't keep a static copy
of it in notes — point to where it lives instead. A copied value drifts silently out of sync with the live source.

Write notes as clean current-state documentation, not a changelog — don't add phrases like "correcting an earlier
assumption," "verified on \<date\>," or narrate what an audit found and when. When new information supersedes what's
written, replace the stale content outright rather than appending a dated correction on top of it. Git history
already captures when something changed. Exception: a standing status marker that is itself the current fact (e.g. a
"Decommissioned \<date\>" callout) is fine — that's describing state, not narrating a correction. The same applies to
describing multiple approaches that were tried before landing on the one that works — just document what works;
don't narrate the dead ends (unless a dead end is a non-obvious trap someone would naturally reach for and waste time
on — that's a forward-looking gotcha worth a short warning, not backward-looking narration).

Don't document something that isn't actually part of the current setup — a rejected alternative, an integration that
was tried and removed, a feature that was never adopted. If the rationale is worth preserving so it doesn't get
relitigated, it belongs as a terse entry in a dedicated "Deprecated / Rejected" list (`X → decommissioned; reason`),
not woven inline into a section describing
what's currently active. Similarly, don't explain the absence of a constraint or rule that was never actually a real
option (e.g. "no fixed length requirement" when no one ever proposed one) — just state the actual rule.

If live infrastructure (compose files, configs, etc.) differs from what's documented, and the change was made by the
user directly rather than by Claude in the current session — ask before updating notes to match. Don't proactively
rewrite documentation to reflect changes only observed by reading files; the user may still be mid-change, and
documenting it early bakes in assumptions about unfinished or unconfirmed work.

When writing a specific name, ID, or label into notes, only state it if it was confirmed against the system that
actually owns/defines it — not inferred from a downstream artifact produced by a different system (e.g. a
path-prefix segment observed in another system's object keys or log lines, which merely implies the fact rather
than confirming it). If it's only inferred, either verify against the owning system first or state the fact
generically without the unconfirmed specific (e.g. "syncs via a dedicated per-folder job" rather than naming the
job).

Never name specific downloaded files/titles (movies, shows, episodes, books) in notes — neither the raw release name
nor the cleaned-up title. Refer to items generically instead: by category (Movie/Show/Book), state
(seeding/stopped/downloading), ratio, or size. This applies retroactively too — fix any notes that already name
specific titles rather than leaving them as-is. Chat responses are fine to name titles in — the restriction is
notes-only.
