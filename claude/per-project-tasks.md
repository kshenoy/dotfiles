# Per-project Task Tracking

If the project has a `README.md`, use it to document active plans and simple tasks.

Always update it and any active plan files before committing.

When a task is done, specify the resolution details by updating the plan or the sub-heading and commit the change.
Before deleting it, apply this test: would the information be genuinely useful in the future, or is it just a
record of what happened (no matter how non-specific)? Migrate anything that passes the test into the project's
permanent documentation; delete everything else outright, then commit the deletion separately — git history
already preserves what isn't worth keeping in notes.

The README's `Pending tasks` section holds two things, in this order:

1. A flat, unordered list of links to anything not tracked inline in README.md — a complex plan living in its
   own file

2. A flat, unordered list of simple tasks that may be ticked `- [x]` to indicate completion.

3. Sub-headings for more complicated tasks that do not live elsewhere and are more complicated than a simple inline
   task. Follow the same format as the org-style sub-heading mentioned previously.

## Plans

Plan-mode's plan file is written relative to the current working directory — `<project>/.claude/plans/` if cwd is
inside a project (so the plan is version-controlled with it), falling back to `~/.claude/plans/` otherwise. Before
invoking plan mode for a task that belongs to a specific project, `cd` into that project first so the plan lands
in its repo rather than the global, unversioned directory.
