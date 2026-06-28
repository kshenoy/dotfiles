if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin

set -gx EDITOR nvim

fish_config theme choose "Catppuccin Frappe"

# Use starship prompt (https://starship.rs/)
starship init fish | source

command -q zoxide && zoxide init --cmd j fish | source
