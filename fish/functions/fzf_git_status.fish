function fzf_git_status --description 'Modified files picker (C-g C-s)'
    set -l selected (git -c color.status=always status --short | \
        fzf --nth '2..' \
        --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' | \
        cut -c4- | string replace -r '.* -> ' '')
    if test (count $selected) -gt 0
        commandline -i -- (string escape -- $selected | string join ' ')
    end
    commandline -f repaint
end
