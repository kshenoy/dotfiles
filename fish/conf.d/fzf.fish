# FZF_CTRL_T_COMMAND and FZF_ALT_C_COMMAND are safe to set for all sessions
if command -q fd
    set -gx FZF_CTRL_T_COMMAND "fd --strip-cwd-prefix --hidden --exclude .git --type f"
    set -gx FZF_ALT_C_COMMAND "fd --strip-cwd-prefix --hidden --exclude .git --type d"
end

set -gx FZF_DEFAULT_OPTS "--ansi --exit-0 --select-1 --multi --inline-info --reverse --tiebreak=length,end \
  --bind 'shift-tab:toggle-all,alt-p:change-preview-window(down|hidden|)' \
  --bind 'shift-page-down:preview-half-page-down,shift-page-up:preview-half-page-up'"
set -gx FZF_ALT_C_OPTS "--preview 'tree -C {} | head -200'"

# Everything below is interactive-only
if not status is-interactive
    return
end

# FZF colorschemes (must come after FZF_DEFAULT_OPTS is set)
source ~/.config/dotfiles/fzf/themes/catppuccin-frappe.fish

fzf --fish | source

# Source fzf-git.sh for enhanced git integration
# (our custom bindings below will override some of its defaults)
# FZF_GIT_HOME should be set to the fzf-git.sh repo directory before this file is sourced.
# Machine-specific conf.d files (e.g. Kartiks-MacBook-Pro.local.fish) sort before this
# file alphabetically, so they are the right place to set FZF_GIT_HOME.
if set -q FZF_GIT_HOME; and test -f $FZF_GIT_HOME/fzf-git.fish
    source $FZF_GIT_HOME/fzf-git.fish

    # Override _fzf_git_fzf for better tmux popup sizing (must follow the source above)
    function _fzf_git_fzf
        set -l fzf_args --height 75% \
            --layout reverse --multi --min-height 20+ --border \
            --no-separator --header-border horizontal \
            --border-label-pos 2 --color 'label:blue' \
            --preview-window 'right,50%' --preview-border line \
            --bind 'ctrl-/:change-preview-window(down,50%|hidden|)'
        if set -q TMUX
            set -l pw (math (tmux display-message -p '#{pane_width}') \* 9 / 10)
            set -l ph (math (tmux display-message -p '#{pane_height}') \* 9 / 10)
            fzf --tmux "center,$pw,$ph" $fzf_args $argv
        else
            fzf $fzf_args $argv
        end
    end
end

#=======================================================================================================================
# Key bindings
# FZF uses ctrl-t, alt-c and shift-tab by default; rebind under a ctrl-f prefix (mirrors key-bindings.bash)
#=======================================================================================================================
bind --erase           ctrl-t alt-c shift-tab
bind --erase -M insert ctrl-t alt-c shift-tab

# CTRL-F CTRL-F instead of CTRL-T : Paste selected file path(s)
if set -q FZF_CTRL_T_COMMAND
    bind           ctrl-f,ctrl-f fzf-file-widget
    bind -M insert ctrl-f,ctrl-f fzf-file-widget
end

# CTRL-F CTRL-J instead of ALT-C : cd into selected directory
if set -q FZF_ALT_C_COMMAND
    bind           ctrl-f,ctrl-j fzf-cd-widget
    bind -M insert ctrl-f,ctrl-j fzf-cd-widget
end

# CTRL-F ENTER : fzf completion
bind           ctrl-f,enter fzf-completion
bind -M insert ctrl-f,enter fzf-completion

# Version-control related bindings: CTRL-G
# fzf-git.sh provides these git-specific bindings (sourced above):
#   C-g C-f / C-g f → files           C-g C-h / C-g h → hashes (commits)
#   C-g C-b / C-g b → branches        C-g C-s / C-g s → stashes
#   C-g C-t / C-g t → tags            C-g C-w / C-g w → worktrees
#   C-g C-r / C-g r → remotes         C-g C-l / C-g l → reflogs
#   C-g C-e / C-g e → each-ref        C-g ?           → help
# C-g C-s: modified files picker (overrides fzf-git.sh's stash binding)
bind           ctrl-g,ctrl-s fzf_git_status
bind -M insert ctrl-g,ctrl-s fzf_git_status

# C-f C-g: git files picker (mirrors LazyVim's convention; same as C-g C-f)
# fzf-git.sh's fish integration uses __fzf_git_sh with the command name as argument
if functions -q __fzf_git_sh
    bind           ctrl-f,ctrl-g '__fzf_git_sh files'
    bind -M insert ctrl-f,ctrl-g '__fzf_git_sh files'
end
