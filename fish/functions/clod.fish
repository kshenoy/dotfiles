function clod --description 'Create-or-resume a named Claude remote-control session, pinned to a stable session ID'
    set -l name $argv[1]
    set -l proj_dir ~/.claude/projects/(string replace -a / - -- (pwd))
    set -l id ""
    if test -d $proj_dir
        set -l match (grep -ls "\"customTitle\":\"$name\"" $proj_dir/*.jsonl 2>/dev/null | xargs -r ls -t | head -1)
        test -n "$match"; and set id (basename $match .jsonl)
    end
    if test -z "$id"
        # -p forces this bootstrap call to exit on its own once it gets a response, instead of leaving an
        # interactive session that has to be manually /exit'd. It still needs some prompt text (-p errors out
        # without one) and still writes customTitle from --name, which is all this call exists for -
        # --remote-control is meaningless here since the process exits right away.
        #
        # Tried pre-choosing the ID with --session-id instead, to avoid this leaving a permanent "clod
        # bootstrap - ignore" turn at the top of the session's history - but reusing an existing --session-id
        # errors out ("already in use") rather than resuming it. tmux-resurrect replays whatever argv the
        # pane's claude process last had at save time, which could still be this fresh --session-id form if a
        # reboot lands before the pane ever transitions to --resume - so that form has to error-proof itself
        # by never being left as the long-lived command. The -p bootstrap avoids that: the foreground process
        # is always the --resume form below, which is safe to replay indefinitely. One-time cosmetic bootstrap
        # turn in the history is the trade-off.
        claude -p "clod bootstrap - ignore" --name $name >/dev/null 2>&1
        # -p sessions are tagged with a different entrypoint ("sdk-cli") than a real interactive one ("cli"),
        # and `claude --resume <name>`'s interactive picker only lists "cli" sessions - it silently shows zero
        # matches for one it just created via -p. Grab the ID with the same grep used above instead of trusting
        # the picker to find it by name.
        set -l match (grep -ls "\"customTitle\":\"$name\"" $proj_dir/*.jsonl 2>/dev/null | xargs -r ls -t | head -1)
        set id (basename $match .jsonl)
    end
    # Resuming by session ID (not name) keeps this pinned to one exact conversation forever - names get
    # reused across many unrelated sessions over time, which eventually makes `--resume <name>` ambiguous
    # and forces an interactive picker that breaks unattended restore (e.g. tmux-resurrect after a reboot).
    # --resume alone doesn't restore customTitle, so pass --name explicitly - otherwise the session comes
    # back nameless (needing a manual /rename) and drops out of future grep-by-name lookups above.
    # Remote Control is likewise a runtime flag, not persisted session state - pass --remote-control too,
    # or the resumed pane needs a manual /remote-control before it's reachable again.
    claude --resume $id --name $name --remote-control $name
end
