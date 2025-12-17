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
    $(FZF_ALT_C_COMMAND='_dir=$PWD; while [[ -n "$_dir" ]]; do _dir="${_dir%/[^/]*}"; echo ${_dir:-/}; done' \
        FZF_ALT_C_OPTS="$FZF_ALT_C_OPTS${1+ --query=$1}" __fzf_cd__)
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


# Function: cd
# Description: Enhanced cd with fuzzy directory navigation
# Usage:
#   cd         - Go to repository root (if in repo) or $HOME
#   cd -       - Go to previous directory
#   cd =       - Select from directory stack with fzf
#   cd <path>  - Navigate to path
unset -f cd
cd() {
    if (( "$#" == 0 )); then
        if vcs::is_in_repo > /dev/null; then
            pushd "$(vcs::get_root)" > /dev/null
        else
            pushd "$HOME" > /dev/null
        fi
        return
    fi

    case "$1" in
        -)
            pushd > /dev/null
            return
            ;;

        =)
            if hash fzf 2> /dev/null; then
                FZF_ALT_C_COMMAND='builtin dirs -l -p' __fzf_cd__
            else
                dirs
            fi
            return
            ;;
    esac

    # Fall-through to the default command
    pushd "$@" > /dev/null
}

alias ..='cd ..'
