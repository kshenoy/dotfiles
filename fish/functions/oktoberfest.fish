# Usage: oktoberfest [--doctor]
# Updates and upgrades all Homebrew and Mac App Store packages, removes old
# versions, and snapshots installed packages to the Brewfile in dotfiles.
# Options:
#   --doctor  Run `brew doctor` to check for common Homebrew issues
function oktoberfest --wraps=brew --desc="One-liner for all HomeBrew maintenance"
    brew update                                                       # Fetch latest formulae/cask metadata
    and brew upgrade                                                  # Upgrade all outdated Homebrew packages
    and mas upgrade                                                   # Upgrade all outdated Mac App Store apps
    and brew cleanup                                                  # Remove old versions and stale downloads
    brew bundle dump -f --file=$HOME/.config/dotfiles/Brewfile       # Snapshot installed packages to Brewfile
    if contains -- --doctor $argv
        brew doctor                                                   # Check for common Homebrew issues
    end
end
