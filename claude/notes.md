# Note-Writing Conventions

Keep notes updated as changes are made or new information is learned. When a situation doesn't fit a convention
below, reason from the principle behind it rather than pattern-matching.

## Avoid changelog language

- Only describe current state and don't record anything that is not going to be helpful later.
- Only capture what can't be cheaply reconstructed.
- Notes must give context that isn't cheaply available elsewhere — not a reference manual.

## Line length

Max 120 characters; never wrap a `[[wikilink]]` across lines, even if it runs over.

## One home per fact

State a fact once, on the page it belongs to. Everywhere else references it with a link, not a paraphrase — a
shorter restatement is still a duplicate, and duplicates drift apart.

## Tasks

Track tasks as [Obsidian Tasks](https://publish.obsidian.md/tasks/) checkboxes in the plugin's Dataview format, under
a `## Tasks` heading on the page they belong to: `[ ]` todo, `[/]` doing, `[x]` done, `[-]` cancelled. Add fields
(`[due:: …]`, `[priority:: …]`) only when they mean something. Context (the problem, progress, a link to a plan)
goes in indented lines beneath the task. Multi-step plans live in the vault's `plans/` folder, each linked from a
task; the vault README's `tasks` query lists what's open.

To finish one, check it off with the plugin's date field (`[completion:: YYYY-MM-DD]` or
`[cancelled:: YYYY-MM-DD]`), write the resolution in its indented lines, and commit. Then move any lasting fact into
the page, delete the task, and commit again. The intent here is to capture details of the completed task in git history
and clean it up once done.

## Frontmatter tags

Multiple `tags:` use inline/flow YAML (`tags: [media, vpn]`), not a block list.

## Use real structure, not text that mimics it

A heading, a table, a callout, a numbered/checkbox list — use the actual Markdown/Obsidian syntax for what the
content is, not bold text or plain prose standing in for it. This isn't just cosmetic: a heading is what gives
content an anchor other pages can link to (`[[Page#Heading]]`) — bold-inline text has none, so anything meant to
be referenced from elsewhere has to be a real heading, not an approximation of one. A vault's own `CLAUDE.md` may
name specific content types this applies to (e.g. HomeLab's Gotchas) — those are instances of this principle, not
separate rules.
