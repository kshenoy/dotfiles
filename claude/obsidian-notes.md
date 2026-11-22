# Obsidian Note Conventions

Keep notes updated as changes are made or new information is learned. When a situation doesn't fit a convention
below, reason from the principle behind it rather than pattern-matching.

## Vaults

There are two: HomeLab (homelab, self-hosting, infrastructure) and Coppermind (everything else); their paths are in
the machine `CLAUDE.md`. When asked to "add to notes", "log this", or similar, route by topic, and read the target
vault's own `.claude/CLAUDE.md` first — it holds the conventions specific to that vault.

A vault's README, and any index its `CLAUDE.md` adds (like HomeLab's Known Gotchas Index), records where
information lives rather than summarizing it, so the details that matter are only on the linked page. Before
answering, proposing, editing, or diagnosing anything an index covers, read the linked page in full instead of
reasoning from the index line, and don't wait to be told where to look.

## Avoid changelog language

A topic page describes the current state, so a reader gets the truth without replaying how it got there — "moved X
to Y" makes them reconstruct the present from its history. What happened, step by step, goes in that day's daily
note instead, where the vault keeps one: git holds the complete record but is cumbersome to search, so the daily
note is the browsable one.

Either way, capture only what can't be cheaply reconstructed and will help later — context that isn't available
elsewhere, not a reference manual.

## One home per fact

State a fact once, on the page it belongs to. Everywhere else references it with a link, not a paraphrase — a
shorter restatement is still a duplicate, and duplicates drift apart.

## Use real structure, not text that mimics it

A heading, a table, a callout, a numbered/checkbox list — use the actual Markdown/Obsidian syntax for what the
content is, not bold text or plain prose standing in for it. This isn't just cosmetic: a heading is what gives
content an anchor other pages can link to (`[[Page#Heading]]`) — bold-inline text has none, so anything meant to
be referenced from elsewhere has to be a real heading, not an approximation of one. A vault's own `CLAUDE.md` may
name specific content types this applies to (e.g. HomeLab's Gotchas) — those are instances of this principle, not
separate rules.

## Tasks

Track tasks as [Obsidian Tasks](https://publish.obsidian.md/tasks/) checkboxes in the plugin's Dataview format, under
a `## Tasks` heading on the page they belong to: `[ ]` todo, `[/]` doing, `[x]` done, `[-]` cancelled. Add fields
(`[due:: …]`, `[priority:: …]`) only when they mean something. Context (the problem, progress, a link to a plan)
goes in indented lines beneath the task. Multi-step plans live in the vault's `plans/` folder, each linked from a
task; the vault README's `tasks` query lists what's open.

To finish one, mark it `[x]` (done) or `[-]` (cancelled), write the resolution in its indented lines, and commit.

Task status and knowledge retention are orthogonal. Whether something is tracked with a status annotation and whether
its content is worth retaining are two separate questions — don't conflate "the task is done/cancelled" with "this is
now just history." The intent here is to capture details of the completed task in git history and clean it up once done.
So, if it's worth preserving, remove the status annotation and keep it as ordinary content on the page; if not, delete
it. In either case, commit again.

## Formatting

- Wrap lines at 120 characters, so an edit shows up in git diffs and terminals as a changed line rather than a
  changed paragraph. Obsidian reflows paragraphs regardless, with its "Strict line breaks" setting on. Never wrap a
  `[[wikilink]]` across lines, even if it runs over — a split link stops being a link.
- Multiple `tags:` use inline/flow YAML (`tags: [media, vpn]`), not a block list.
