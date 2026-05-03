# Global Instructions

## Remembered Behaviors

Prefer saving remembered behaviors and project-specific information to the relevant `.claude/CLAUDE.md` (git-tracked, syncs across devices) over memory files. Only use memory files when explicitly asked to.

## Git Commits

Always stage and commit in two separate steps so the user can review what got staged before the commit runs.

## Active Plans

Active plans live in `.claude/plans/` as individual `.md` files with sensible names describing the work (e.g.
`vault-mcp-integration.md`), not auto-generated random names. If the project has a `README.md`, add a plain bullet there
pointing to each active plan.

Within plan files, simple tasks may be ticked `- [x]`; complex phases get a Status sub-heading instead. Preserve the
full plan file until the user approves a git commit. When a plan is complete and committed, delete the plan file and
remove the README bullet.

## README TODO format

If a project has a `README.md`, use that to document in-progress work. 
Placed after the main section content and use this format:

```
#### TODO <short description>

<problem statement paragraph>

**Status**
<current status / what's been tried / what's pending>
```

Remove the TODO once resolved
