#=======================================================================================================================
# ALIASES & UTILITY FUNCTIONS
#=======================================================================================================================
# Non-VCS related aliases and helper functions

#=======================================================================================================================
# File Operations
#=======================================================================================================================
alias ls='ls -FLH --color=auto'
alias la='ls -A'
alias ll='ls -lh'
alias lla='ll -A'

alias cl="clear;ls"
alias mv='mv -vi'
alias cp='cp -vi'
alias rm='rm -vi'
alias ln='ln -svi'
alias df='df -h'
alias pppath='tr ":" "\n" <<< $PATH'
alias clnpath='export PATH=$(tr ":" "\n" <<< $PATH | perl -ne "print unless \$seen{\$_}++" | paste -s -d":")'

# Directory operations
alias md='mkdir -p'

# Create new directory(ies) and enter the last one
# mcd dir1 [dir2 ...]
unset -f mcd
mcd() {
    command mkdir -p "$@" || return
    cd -- "${@: -1}"
}

#=======================================================================================================================
# File Viewers & Pagers
#=======================================================================================================================
if command -v bat >/dev/null 2>&1; then
    alias C="bat --paging=never"
else
    alias C=cat
fi
alias P=$PAGER

#=======================================================================================================================
# Editors
#=======================================================================================================================
alias v=$EDITOR
if [[ $EDITOR == "nvim" ]]; then
    alias vi='nvim --clean'
else
    alias vi="vim -u NORC -U NORC -N --cmd 'set rtp="'$VIM,$VIMRUNTIME,$VIM/after'"'"
fi

# Conditional vimdiff - only runs if files exist and differ
gvim_diff() {
    # Check to see if all files are present. If not, return.
    for i in "$@"; do
        [[ ! -f "$i" ]] && return
    done

    # If there are no differences, print that files are identical and return
    command diff -qs "$@" && return

    # Run vimdiff only if there are differences and all files are present
    gvim -df -c 'set nobackup' "$@"
}
alias vd=gvim_diff

#=======================================================================================================================
# Miscellaneous Utilities
#=======================================================================================================================
# Notify when a command completes
# eg. sleep 10 && alert ["custom message"]
unset -f alert
alert() {
    # Pick up display message if provided as argument. If not show the last command that was run
    local _msg=${1:-"'$(fc -nl -1 | sed -e 's/^\s*//' -e 's/\s*[;&|]\+\s*alert$//')' has completed"}

    # Add TMUX information if available
    if [[ -n $TMUX ]]; then
        _msg="$(tmux display-message -p "[#S:#I.#P]") $_msg"
    else
        _msg="[$$] $_msg"
    fi

    # Indicate normal completion or error
    local _icon=$( (($? == 0)) && echo terminal || echo error)

    notify-send --urgency=low -i $_icon "$_msg"
}

#=======================================================================================================================
# Config File Shortcuts
#=======================================================================================================================
alias sosc='. ~/.bashrc && clnpath'

#=======================================================================================================================
# grep
#=======================================================================================================================
export GREP_COLORS='1;32'
alias grep='grep -sP --color=auto'

# ripgrep integration
if hash rg 2> /dev/null; then
    export RIPGREP_CONFIG_PATH=${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/ripgrep/config
    alias g='command rg'
else
    alias g=grep
fi
alias gi='g -i'

#=======================================================================================================================
# tmux
#=======================================================================================================================
[[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/tmux/tmuxw.bash ]] &&
    . ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/tmux/tmuxw.bash

alias tmux='tmuxw'
alias tm='tmux'
