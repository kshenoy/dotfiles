# Use [[https://starship.rs/][starship prompt]]
starship init fish | source

fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin
# fish_config theme save "Catppuccin Macchiato"

zoxide init --cmd j fish | source
