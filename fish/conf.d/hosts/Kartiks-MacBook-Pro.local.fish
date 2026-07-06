# All MacBook specific configuration goes here
# This file gets sourced before config.fish
if test (hostname) != "Kartiks-MacBook-Pro.local"
    return
end

eval (/opt/homebrew/bin/brew shellenv)

set -gx FZF_GIT_HOME /opt/fzf-git.sh

function gitn --wraps git --description 'git for the Coppermind notes repo'
    git -C ~/Documents/Notes/Coppermind $argv
end
