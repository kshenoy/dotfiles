# All MacBook specific configuration goes here
# This file gets sourced before config.fish
if test (hostname) != "Kartiks-MacBook-Pro.local"
    return
end

eval (/opt/homebrew/bin/brew shellenv)
