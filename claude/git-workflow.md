# Git Workflow

Before staging/committing, diff the full working tree — not just the files touched in the current session — and flag
anything unexpected to the user before bundling it in. Other Claude Code sessions may be running concurrently against
the same repo (the more common case), and the user occasionally edits the vault directly too (e.g. in Obsidian) —
either way, `git status` can include changes that aren't from the current session. If the user confirms a given
change is expected, it's fine to include in the same commit; just surface it first rather than assuming everything
staged belongs to the current session.

A concurrent session's files can already be sitting in the index (staged) before `git add` is ever run — plain
`git status` doesn't distinguish "staged just now" from "was already staged by someone else." After staging the
current session's own files, check `git diff --cached --stat` to see what's actually about to be committed, not just
`git status`. If another session's files show up staged, `git restore --staged <file>` to unstage them without
touching their working-tree content, then commit only what's actually from the current session.
