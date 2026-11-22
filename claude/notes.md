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

## Frontmatter tags

Multiple `tags:` use inline/flow YAML (`tags: [media, vpn]`), not a block list.

## Use real structure, not text that mimics it

A heading, a table, a callout, a numbered/checkbox list — use the actual Markdown/Obsidian syntax for what the
content is, not bold text or plain prose standing in for it. This isn't just cosmetic: a heading is what gives
content an anchor other pages can link to (`[[Page#Heading]]`) — bold-inline text has none, so anything meant to
be referenced from elsewhere has to be a real heading, not an approximation of one. A vault's own `CLAUDE.md` may
name specific content types this applies to (e.g. HomeLab's Gotchas) — those are instances of this principle, not
separate rules.
