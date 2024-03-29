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
if hash fd 2> /dev/null; then
  export FZF_DEFAULT_COMMAND="fd --color=never --hidden --exclude .git --type f"
  export FZF_ALT_C_COMMAND="fd --color=never --hidden --exclude .git --type d"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
else
  export FZF_ALT_C_COMMAND="find -mindepth 1 -name '.git' -prune -o -type d -print"
fi

# Clear out old env vars
export FZF_DEFAULT_OPTS="--ansi --select-1 --exit-0 --inline-info --reverse --tiebreak=length,end --bind=shift-tab:toggle-all,ctrl-n:down,ctrl-p:up"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
unset FZF_CTRL_T_OPTS
# export FZF_CTRL_T_OPTS='--expect=alt-v,alt-e,alt-c'

# FZF colorschemes are applied by appending to the FZF_DEFAULT_OPTS env var
# Thus, I "set" FZF_DEFAULT_OPTS first before sourcing the colorscheme file which appends to it
# export BASE16_FZF=${XDG_CONFIG_HOME:-$HOME/.config}/base16-fzf
# [[ -n "$BASE16_THEME" ]] && source "${BASE16_FZF}/bash/base16-${BASE16_THEME}.config"
source ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/fzf/themes/catppuccin-frappe.sh

