if status is-interactive
    # Alt-F / Alt-B: WORD forward/backward (stops at whitespace only, like vim's W/B)
    # Mirrors M-F / M-B (shell-forward-word / shell-backward-word) from bash/inputrc
    bind alt-F forward-bigword
    bind alt-B backward-bigword
end
