#========================================================================================================================
# DIRECTORY NAVIGATION
#========================================================================================================================
# Enhanced directory navigation with fuzzy finding and directory stack management

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
    builtin pushd "$@" > /dev/null;

    # Remove any duplicate entries. The 1st entry will be the PWD so skip it
    local _dir_pos=$(dirs -l -v | tail -n+2 | grep "$PWD$" | sed 's/^\s*//' | cut -d ' ' -f1 | paste -s)
    command popd -n +$_dir_pos &> /dev/null
}

# Function: cd
# Description: Enhanced cd with fuzzy directory navigation
# Usage:
#   cd              - Go to repository root (if in repo) or $HOME
#   cd -            - Go to previous directory
#   cd =            - Select from directory stack with fzf
#   cd ... [TARG]   - Navigate up directory tree with fzf, optionally filtered by TARG
#   cd path**glob   - Fuzzy search subdirectories matching glob pattern
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

        ...)
            if hash fzf 2> /dev/null; then
                local _selected=$(_dir=$PWD;
                                  while [[ -n "$_dir" ]]; do
                                      _dir="${_dir%/[^/]*}";
                                      echo ${_dir:-/};
                                  done | fzf::_down --select-1 --delimiter='/' --nth=-1 ${2+ --query=$2})
                pushd $_selected
            fi
            return
            ;;

        *\*\**)
            # Split $1 about the first ** into '_path' and '_pattern' and replace all '**' in _pattern with '*'
            local _path=${1%%\*\**}; _path=${_path:-.}
            local _pattern="*$(tr -s '*' <<< ${1#*\*\*})"

            local _selected
            if hash fzf 2> /dev/null; then
                # Find '_path' for all dirs that match the glob expr '_pattern' and select with FZF from the results
                _selected=$(if hash fd 2> /dev/null; then
                                ${FZF_ALT_C_COMMAND} --full-path --glob "${_pattern}" "${_path}"
                            else
                                find "${_path}" -type d -path "${_pattern}"
                            fi | fzf::_down --select-1)
            else
                # Select only the first match since without FZF we don't have a good way of handling multiple matches
                if hash fd 2> /dev/null; then
                    _selected=$(fd --color=never --hidden --exclude .git --type d --glob "${_pattern}" ${_path} | head -n 1)
                else
                    _selected=$(find $_path -type d -path "${_pattern}" -print -quit)
                fi
            fi

            pushd "$_selected"
            return
            ;;
    esac

    # Fall-through to the default command
    pushd "$@"
}

alias ..='cd ..'
