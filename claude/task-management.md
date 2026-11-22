# Task Management

Track a project's active plans and tasks in its `README.md` under a `Pending Tasks` heading, and update it (and any
active plan files) before committing. The section holds, in order:

1. Links to plans that live in their own file, each with its status (`- [Vault MCP integration](vault-mcp.md) —
   DOING, blocked on auth`).
2. Simple tasks as a checkbox list.
3. One sub-heading per complex task, one level below the `Pending Tasks` heading, prefixed with an org-mode status:

```
### DOING <short description>

<problem statement>

<what's been tried / what's pending, as plain prose in the body — not a separate **Status** label>
```

`TODO` needs only the problem statement. `DOING` adds progress; `DONE`/`CANCEL` add the resolution (no date — git
has it). Once a task is finished, move anything still useful into the project's permanent documentation, then
delete the task entry and commit that deletion separately.
