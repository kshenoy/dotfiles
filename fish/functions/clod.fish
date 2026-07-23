function clod --description 'Create-or-resume a named Claude remote-control session, pinned to a stable session ID'
    set -l name $argv[1]
    set -l proj_dir ~/.claude/projects/(string replace -a / - -- (pwd))
    set -l id ""
    if test -d $proj_dir
        set -l match (grep -ls "\"customTitle\":\"$name\"" $proj_dir/*.jsonl 2>/dev/null | xargs -r ls -t | head -1)
        test -n "$match"; and set id (basename $match .jsonl)
    end
    if test -n "$id"
        # Resuming by session ID (not name) keeps this pinned to one exact conversation forever - names get
        # reused across many unrelated sessions over time, which eventually makes `--resume <name>` ambiguous
        # and forces an interactive picker that breaks unattended restore (e.g. tmux-resurrect after a reboot).
        claude --resume $id
    else
        claude --name $name --remote-control $name
        claude --resume $name
    end
end
