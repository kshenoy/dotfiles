function fzf_cd_parent
    set -l d $PWD
    set -l parents

    while true
        set d (string replace -r '/[^/]+$' '' -- $d)
        test -z "$d" -o "$d" = /; and break
        set -a parents $d
    end

    test (count $parents) -eq 0; and return

    set -l dir (printf '%s\n' $parents | fzf --delimiter / --nth -1 --no-multi)
    test -n "$dir"; and cd $dir
    commandline -f repaint
end
