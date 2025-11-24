#========================================================================================================================
# VERSION CONTROL SYSTEM HELPERS & ALIASES
#========================================================================================================================
# All git and perforce related code in one place for easy maintenance

#========================================================================================================================
# VCS Detection Functions
#========================================================================================================================

# Git Detection
vcs::is_in_git_repo() {
    local _cwd=$PWD
    if (( $# > 0 )); then
        command cd $1
    fi

    git rev-parse HEAD &> /dev/null
    local _ret=$?

    if (( $# > 0 )); then
        command cd $_cwd
    fi

    return $_ret
}

# Perforce Detection
vcs::is_in_perforce_repo() {
    [[ -n "$STEM" ]] && [[ ${1-$PWD} =~ $STEM ]];
}

vcs::get_p4_branch() {
  local top=${REPO_PATH-$PWD}
  if [[ -f "$top/configuration_id" ]]; then
    echo "$(sed 's/@.*//' "$top/configuration_id" 2> /dev/null)"
  fi
}

# Combined VCS Functions
vcs::is_in_repo() {
    vcs::is_in_git_repo "$@" || vcs::is_in_perforce_repo "$@"
}

vcs::get_branch() {
    # Description: If PWD is under a VCS, return the branch. If not, return an empty string

    if vcs::is_in_git_repo; then
        git symbolic-ref --short HEAD 2> /dev/null
    elif vcs::is_in_perforce_repo; then
        vcs::get_p4_branch
    else
        echo ""
    fi
}

vcs::get_status() {
    # Description: Get the status of the VCS - works only for git at the moment

    if vcs::is_in_git_repo; then
        local _vcs_branch=$(vcs::get_branch)
        if $(echo "$(git log origin/$_vcs_branch..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
            echo "staged"
        elif [[ -n $(git status -s --ignore-submodules=dirty  2> /dev/null) ]]; then
            echo "modified"
        else
            echo "committed"
        fi
    fi
}

vcs::get_root() {
    if vcs::is_in_git_repo "$@"; then
        echo "$(git rev-parse --show-toplevel)"
    elif vcs::is_in_perforce_repo "$@"; then
        echo "$REPO_PATH"
    else
        echo ""
    fi
}

#========================================================================================================================
# Git Aliases
#========================================================================================================================
alias ga='git add'
alias gA='git add -A .'
alias gh='git help'
alias gs='git status'

#========================================================================================================================
# Perforce Aliases
#========================================================================================================================
alias pf='p4'
alias pfd='pf diff'
alias pfdg='P4DIFF= pf diff -du | grepdiff --output-matching=hunk --remove-timestamps'
alias pfe='pf edit'
alias pflog='pf filelog -stl -m 5'

#========================================================================================================================
# Perforce Helper Functions
#========================================================================================================================

# Format opened files with aligned columns
pfo() {
    pf opened "$@" | command column -s# -o ' #' -t | command column -o ' ' -t | command sed 's/#/   #/'
}

# Convert perforce paths to relative paths
pfrel() {
    if [[ ! -t 0 ]]; then
        pf where $(command sed -e 's/#.*//' < /dev/stdin)
    elif [[ -n "$1" ]]; then
        pf where $(command sed -e 's/#.*//' "$@")
    else
        return
    fi |  awk "{ if (\$3 != \"$REPO_PATH/...\") { print \$3; } }" | sed -e "s:$REPO_PATH/::"
}

# Combination of pfo and pfrel
pfor() {
    pfo "$@" | pfrel
}

# Show top N (default=10) changes
pftop() {
    local num=10
    if (( $# > 0 )) && [[ "$1" =~ ^[0-9]+$ ]]; then
        num=$1
        shift
    fi
    pf changes -m $num "$@" $STEM/...
}
