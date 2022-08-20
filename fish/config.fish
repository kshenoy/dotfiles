# config.fish
# :PROPERTIES:
# :header-args+: :tangle config.fish
# :END:

# Use [[https://starship.rs/][starship prompt]]

# [[file:../../fish.org::*config.fish][config.fish:1]]
starship init fish | source
# config.fish:1 ends here

# login options
# These options need to be set only when logging in i.e. the first time

# Set the theme. Check if ~$BASE16_THEME~ is defined and set the theme only if it isn't
# I need to figure out when this should be called. I probably don't want to invoke this for non-login shells

# [[file:../../fish.org::*login options][login options:1]]
if status --is-login
    if set -q XDG_CONFIG_HOME
        set -Ux BASE16_SHELL $XDG_CONFIG_HOME/base16-shell
    else
        set -Ux BASE16_SHELL ~/.config/base16-shell
    end

    if set -q BASE16_SHELL
        source "$BASE16_SHELL/profile_helper.fish"
    end
end
# login options:1 ends here

# [[file:../../fish.org::*login options][login options:2]]
fish_add_path ~/bin
# login options:2 ends here
