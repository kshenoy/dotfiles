# All services VM specific configuration goes here

function gitn --wraps git --description 'git for the Coppermind notes repo'
    git -C ~/Coppermind $argv
end

function git_repo_sync --description 'Sync all tracked repos (pull --ff-only, then push if ahead)'
    set -l repos ~/HomeLab ~/Coppermind ~/.config/dotfiles ~/.config/dotfiles-priv ~/.config/nvim
    set -l prev_dir (pwd)
    set -l dirty

    for dir in $repos
        if not test -d $dir/.git
            echo "==> $dir (missing, skipping)"
            continue
        end

        echo "==> $dir"
        cd $dir

        if test (git status --porcelain | count) -gt 0
            echo "  dirty working tree — skipped pull/push"
            set -a dirty $dir
            continue
        end

        git pull --ff-only
        or begin
            echo "  pull failed — skipped push"
            continue
        end

        if test (git rev-list --count '@{u}..HEAD') -gt 0
            git push
        end
    end

    cd $prev_dir

    if test (count $dirty) -gt 0
        echo ""
        echo "Skipped (uncommitted changes):"
        for dir in $dirty
            echo "  $dir"
        end
    end
end
