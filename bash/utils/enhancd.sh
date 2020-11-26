# NOTE: Source this file, don't execute it
#
# This is a wrapper around enhancd (https://github/b4b4r07/enhancd) and extends it by adding the following:
#   cd **some**path**to**search  -  Search dirs that match the glob '*some*path*to*search' (requires fzf)
#   cd . [ARG]                   -  Lists subfolders recursively (requires fzf)
#                                   If ARG is provided, shows only directories with ARG in the name
#   cd !                         -  Jumps to the Git root > Perforce root > HOME

## Provide some default aliases
alias cd=pushd
alias ..='cd ..'

if [[ ! -d $HOME/.local/install/enhancd ]]; then
  return
fi

export ENHANCD_COMMAND="enhancd"
export ENHANCD_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/enhancd"
export ENHANCD_DOT_ARG="..."
export ENHANCD_HOME_ARG="@"
export ENHANCD_HYPHEN_ARG="="

if hash fzf 2> /dev/null; then
  export ENHANCD_FILTER="fzf"
fi

. $HOME/.local/install/enhancd/init.sh

if ! hash __enhancd::cd; then
  return
fi

unalias cd
unset -f cd
cd() {
  if (( "$#" == 0 )); then
    if vcs::is_in_repo > /dev/null; then
      enhancd "$(vcs::get_root)"
    else
      enhancd "$HOME"
    fi
    return
  fi

  if hash fzf 2> /dev/null; then
    case "$1" in
      *\*\**)
        # Split $1 about the first ** into '_path' and '_pattern'.
        local _path=${1%%\*\**}; _path=${_path:-.}
        local _pattern="*$(tr -s '*' <<< ${1#*\*\*})*"

        # Find '_path' for all dirs that match the glob expr '_pattern' and select with FZF from the results
        $(FZF_ALT_C_COMMAND="find ${_path} -type d -path '${_pattern}'" __fzf_cd__)
        return
        ;;


      ',')
        $(FZF_ALT_C_OPTS="${FZF_ALT_C_OPTS}${2+ --exact --query=$2}" __fzf_cd__)
        return
        ;;
    esac
  fi

  enhancd "$@"
}
