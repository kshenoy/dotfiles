if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin

set -gx EDITOR nvim

# fish_config theme save "Catppuccin Frappe"

# Use starship prompt (https://starship.rs/)
starship init fish | source

zoxide init --cmd j fish | source

# FZF
fzf --fish | source
# Change default FZF bindings
bind --erase           ctrl-t alt-c shift-tab
bind --erase -M insert ctrl-t alt-c shift-tab
bind           ctrl-f,ctrl-f fzf-file-widget
bind -M insert ctrl-f,ctrl-f fzf-file-widget
bind           ctrl-f,alt-c  fzf-cd-widget
bind -M insert ctrl-f,alt-c  fzf-cd-widget
bind           ctrl-f,enter  fzf-completion
bind -M insert ctrl-f,enter  fzf-completion

eval "$(/opt/homebrew/bin/brew shellenv)"
