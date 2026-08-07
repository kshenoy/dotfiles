function clod --description 'Create-or-resume a named Claude remote-control session, pinned to a stable session ID'
    set -l name $argv[1]
    set -l proj_dir ~/.claude/projects/(string replace -a / - -- (pwd))
    set -l id ""
    if test -d $proj_dir
        set -l match (find $proj_dir -maxdepth 1 -name '*.jsonl' 2>/dev/null | xargs -r grep -ls "\"customTitle\":\"$name\"" 2>/dev/null | grep -v '\.orphaned-' | xargs -r ls -t | head -1)
        test -n "$match"; and set id (basename $match .jsonl)
    end
    if test -z "$id"
        # No existing session under this name yet - just start one fresh. (No bootstrap dance here: that
        # used to exist purely so tmux-resurrect would always have a stable `--resume` argv to replay even
        # if a reboot landed mid-bootstrap. Callers are static now (tmuxp), so nothing captures/replays argv.)
        claude --name $name --permission-mode auto
    else
        # Resuming by session ID (not name) keeps this pinned to one exact conversation forever - names get
        # reused across many unrelated sessions over time, which eventually makes `--resume <name>` ambiguous
        # and forces an interactive picker.
        # --resume alone doesn't restore customTitle, so pass --name explicitly - otherwise the session comes
        # back nameless (needing a manual /rename) and drops out of future grep-by-name lookups above.
        # Remote Control comes from the `remoteControlAtStartup` setting now, so it doesn't need to be
        # passed explicitly here - it starts automatically and picks up the name from --name above.
        claude --resume $id --name $name --permission-mode auto
    end
end
