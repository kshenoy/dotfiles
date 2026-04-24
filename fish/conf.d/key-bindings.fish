if status is-interactive
    # Alt-F / Alt-B: WORD forward/backward (stops at whitespace only, like vim's W/B)
    # Mirrors M-F / M-B (shell-forward-word / shell-backward-word) from bash/inputrc
    bind alt-F forward-bigword
    bind alt-B backward-bigword

    # C-g C-g C-s: git status
    # C-g C-g C-l: git lg
    # Mirrors bash/key-bindings.sh
    bind           ctrl-g,ctrl-g,ctrl-s 'git st; commandline -f repaint'
    bind -M insert ctrl-g,ctrl-g,ctrl-s 'git st; commandline -f repaint'
    bind           ctrl-g,ctrl-g,ctrl-l 'git lg; commandline -f repaint'
    bind -M insert ctrl-g,ctrl-g,ctrl-l 'git lg; commandline -f repaint'
end
