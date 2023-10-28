if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin

# fish_config theme save "Catppuccin Frappe"

# Use starship prompt (https://starship.rs/)
starship init fish | source

# zoxide init --cmd j fish | source
