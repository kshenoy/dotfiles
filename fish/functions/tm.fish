function tm --wraps=tmux
    if command -q tmuxw
        tmuxw $argv
    else
        tmux $argv
    end
end
