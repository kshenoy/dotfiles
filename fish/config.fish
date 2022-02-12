# config.fish
# :PROPERTIES:
# :header-args+: :tangle (concat (or (getenv "XDG_CONFIG_HOME") (concat (getenv "HOME") "/.config")) "/fish/config.fish")
# :END:

# Use [[https://starship.rs/][starship prompt]]

# [[file:../dotfiles/fish.org::*config.fish][config.fish:1]]
starship init fish | source
# config.fish:1 ends here



# Set the theme. Check if ~$BASE16_THEME~ is defined and set the theme only if it isn't

# [[file:../dotfiles/fish.org::*config.fish][config.fish:2]]
if status --is-interactive
    if set -q XDG_CONFIG_HOME
        set -Ux BASE16_SHELL $XDG_CONFIG_HOME/base16-shell
    else
        set -Ux BASE16_SHELL ~/.config/base16-shell
    end

    if set -q BASE16_SHELL
        source "$BASE16_SHELL/profile_helper.fish"
    end
end
# config.fish:2 ends here

# [[file:../dotfiles/fish.org::*config.fish][config.fish:3]]
fish_add_path ~/bin
# config.fish:3 ends here
