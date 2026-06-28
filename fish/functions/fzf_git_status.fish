function fzf_git_status --description 'Modified files picker (C-g C-s)'
    set -l selected (git -c color.status=always status --short | \
        sed 's/"\([^"]*\)"/\1/g' | \
        fzf --nth '2..' \
        --preview 'set f (string sub --start 4 -- {}); set f (string replace -r ".* -> " "" -- $f); begin; git diff --color=always -- $f | sed 1,4d; cat $f; end | head -500' | \
        cut -c4- | string replace -r '.* -> ' '')
    if test (count $selected) -gt 0
        commandline -i -- (string escape -- $selected | string join ' ')
    end
    commandline -f repaint
end
