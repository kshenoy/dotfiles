#=======================================================================================================================
# DIRECTORY NAVIGATION
#=======================================================================================================================
# Enhanced directory navigation with fuzzy finding and directory stack management

# Function: ...
# Description: Interactively navigate up the directory tree with fzf
# Usage:
#   ...          - Select parent directory with fzf
#   ... pattern  - Filter parent directories by pattern
...() {
    if ! hash fzf 2> /dev/null; then
        echo "Error: fzf is required for this function" >&2
        return 1
    fi

    local _selected=$(_dir=$PWD
                      while [[ -n "$_dir" ]]; do
                          _dir="${_dir%/[^/]*}"
                          echo ${_dir:-/}
                      done | fzf::_down --select-1 --delimiter='/' --nth=-1 ${1+ --query=$1})

    [[ -n "$_selected" ]] && pushd "$_selected"
}

# Function: dirs
# Description: Enhanced directory stack viewer
# Usage:
#   dirs        - List directory stack
#   dirs +N/-N  - Show specific entry (uses long format to avoid ~ expansion)
dirs() {
    if (( $# == 0 )); then
        builtin dirs -v
    elif [[ "$*" =~ [-+][0-9]+ ]]; then
        # Use long-listing format. Without this, the home directory is display as '~' preventing me from doing something
        # like `cp $(dirs +1)` as it results in an error: pushd: ~/.vim: No such file or directory
        builtin dirs "$@" -l
    else
        builtin dirs "$@"
    fi
}

# Function: pushd
# Description: Silent pushd that removes duplicate entries from directory stack
# Note: pushd calls cd under the hood, so cdable_vars and cdspell apply here too
pushd() {
    builtin pushd "$@" > /dev/null

    # Remove any duplicate entries. The 1st entry will be the PWD so skip it
    local _dir_pos=$(dirs -l -v | tail -n+2 | grep -F "$PWD" | awk '{print $1}')
    [[ -n "$_dir_pos" ]] && command popd -n +$_dir_pos &> /dev/null
}

# Function: cd
# Description: Enhanced cd with fuzzy directory navigation
# Usage:
#   cd         - Go to repository root (if in repo) or $HOME
#   cd -       - Go to previous directory
#   cd =       - Select from directory stack with fzf
#   cd <path>  - Navigate to path
cd() {
    if (( "$#" == 0 )); then
        if vcs::is_in_repo > /dev/null; then
            pushd "$(vcs::get_root)"
        else
            pushd "$HOME"
        fi
        return
    fi

    case "$1" in
        -)
            pushd
            return
            ;;

        =)
            if hash fzf 2> /dev/null; then
                $(FZF_ALT_C_COMMAND='command dirs -l -p' __fzf_cd__)
            else
                dirs
            fi
            return
            ;;
    esac

    # Fall-through to the default command
    pushd "$@"
}

alias ..='cd ..'
