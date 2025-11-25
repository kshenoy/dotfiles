#=======================================================================================================================
# COMMAND COMPLETION
#=======================================================================================================================

# Load system bash completion
if [[ -f /etc/bash_completion ]] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#=======================================================================================================================
# Essential Completions Only
#=======================================================================================================================
# Only keep completions that aren't handled by bash-completion or need special handling
complete -A directory -o default cd

#=======================================================================================================================
# Alias Completion Helper
#=======================================================================================================================
# Copy completion behavior from a command to one or more aliases
# Usage: _compl_alias <command> <alias1> [alias2 ...]
# Example: _compl_alias nvim v vi  # Makes 'v' and 'vi' use nvim's completion
_compl_alias() {
    local cmd="$1"; shift
    local spec="$(complete -p "$cmd" 2>/dev/null)" || return
    for alias_name in "$@"; do
        eval "${spec//$cmd/$alias_name}"
    done
}

# Apply completions to active aliases only
_compl_alias grep  g gi
if hash rg 2> /dev/null; then
    _compl_alias grep  rg
fi
if hash nvim 2> /dev/null; then
    _compl_alias nvim  v vi
else
    _compl_alias vim   v vi
fi
_compl_alias diff  vd
_compl_alias cat   C
_compl_alias less  P
_compl_alias tmux  tm
