# Global Instructions

## Remembered Behaviors

Keep the lines in markdown or asciidoc files to be 120 characters or less to improve readability

## Git Commits

Always stage and commit in two separate steps so the user can review what got staged before the commit runs.

## Active Plans

Give sensible names to plan files (e.g. `vault-mcp-integration.md`) instead of using auto-generated random names.

Within plan files, simple tasks may be ticked `- [x]`; complex phases get a Status sub-heading instead. Preserve the
full plan file until the user approves a git commit. When a plan is complete and committed, confirm if the plan file can
be deleted and the bullet removed from the README.

## README

If the project has a `README.md`, use it to document active plans and simple tasks.

Add a plain bullet to it mentioning each active plan

If the task is simple enough to not require a full plan, document it in the README file itself by putting it after the
main section content and use this format:

```
#### TODO <short description>

<problem statement paragraph>

**Status**
<current status / what's been tried / what's pending>
```

Remove the TODO once resolved
