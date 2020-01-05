#!/usr/bin/env bash
echo "$(tput setaf 2)Sourcing$(tput sgr0) ${BASH_SOURCE[0]} ..."

if [[ -z "$FZF_PATH" ]]; then
  _fg_red=$(tput setaf 1)
  _reset=$(tput sgr0)
  echo "${_fg_red}ERROR${_reset}: FZF_PATH is not set"
  return
fi

# Setup fzf
# ---------
[[ ! "$PATH" == *$FZF_PATH/bin* ]] && export PATH="$PATH:$FZF_PATH/bin"

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$FZF_PATH/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
# Note the order is important because some functions get overridden
source $FZF_PATH/shell/key-bindings.bash
source ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/fzf/fzf_vcs.bash
source ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/fzf/key-bindings.bash

# Customisations
# --------------
if hash fd || hash fdfind 2> /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --color=never'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d . --color=never'
fi
# export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --bind=ctrl-n:down,ctrl-p:up,alt-n:next-history,alt-p:previous-history --height ${FZF_TMUX_HEIGHT:-40%} --ansi --exit-0"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --height ${FZF_TMUX_HEIGHT:-40%} --ansi --exit-0 --reverse --bind=ctrl-n:down,ctrl-p:up"
# export FZF_CTRL_T_OPTS='--expect=alt-v,alt-e,alt-c'
