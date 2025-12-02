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
alias ln='ln -svi'
alias df='df -h'

# Directory operations
alias md='mkdir -p'

# Create new directory(ies) and enter the last one
# mcd dir1 [dir2 ...]
unset -f mcd
mcd() {
    command mkdir -p "$@" || return
    cd -- "${@: -1}"
}

alias rm='rm -vi'
alias rd='rm -rf'
# Renames files/dirs and deletes in the background. Pretty nifty as I can create another file/dir with the same name
# before the original one has been deleted
unset -f rm_rf_bg
rm_rf_bg() {
    for i in "$@"; do
        # Remove trailing slash and move to hidden
        ni=${i/%\//}
        bi=$(basename "$ni")
        ni=${ni/%$bi/.$bi}

        command mv "$i" "$ni.$$"
        command rm -rf "$ni.$$" &
    done
}
alias rdj='rm_rf_bg'

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
# Calculator Functions (wrappers for ~/.local/bin/calc)
#=======================================================================================================================
# Check if calc is available
if command -v calc &>/dev/null; then
    # Calculator with smart base detection
    # Usage: = 4 + 5
    #        = 0xFF + 0b1010
    #        echo "16 * 32" | =
    =() { calc eval "$@"; }

    # Base converter
    # Usage: =bin 10 --> 0b1010
    #        =dec 0xFF --> 255
    =bin() { calc bin "$@"; }   # Convert to binary
    =dec() { calc dec "$@"; }   # Convert to decimal
    =hex() { calc hex "$@"; }   # Convert to hexadecimal

    # Bit slicing (hardware-style syntax)
    # Usage: =slice '0xFF[7:4]'  # Extract bits 7:4
    #        =slice '255[5]'     # Extract bit 5
    =slice() { calc slice "$@"; }
fi

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
