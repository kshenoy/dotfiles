# Git Workflow

Ask before running `git add`, `git commit`, `git push`, or anything else that modifies history — an instruction to
edit files is not an instruction to commit or push them.

Other Claude sessions often work concurrently in the same repo, and I edit vaults directly in Obsidian, so the
working tree and even the index can hold changes that aren't yours. Stage only the hunks this session edited —
including within a file you touched — without asking about the rest. After staging, check `git diff --cached
--stat`; `git restore --staged` anything already staged by someone else.

Many live config files under `$HOME` (`~/.claude/CLAUDE.md`, skills, settings) are symlinks into the git repos
under `~/.config/dotfiles*` — resolve with `readlink -f` before judging whether a file is version-controlled.
