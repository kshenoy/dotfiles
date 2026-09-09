# Git Workflow

Before staging/committing, diff the full working tree — not just the files touched in the current session. Other
Claude Code sessions may be running concurrently against the same repo (the more common case), and the user
occasionally edits the vault directly too (e.g. in Obsidian) — either way, `git status` can include changes that
aren't from the current session. Stage only the hunks the current session actually edited — including within a file
it otherwise touched, if other hunks in that same file came from elsewhere. Don't ask each time whether to include
the other files/hunks found in the working tree; default to mine-only and leave them out. Only stage something else
if explicitly told to for that instance — this default doesn't change without being told again.

A concurrent session's files can already be sitting in the index (staged) before `git add` is ever run — plain
`git status` doesn't distinguish "staged just now" from "was already staged by someone else." After staging the
current session's own files, check `git diff --cached --stat` to see what's actually about to be committed, not just
`git status`. If another session's files show up staged, `git restore --staged <file>` to unstage them without
touching their working-tree content, then commit only what's actually from the current session.
