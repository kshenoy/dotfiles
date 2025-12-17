#!/usr/bin/env bash
echo "$(tput setaf 2)Sourcing$(tput sgr0) ${BASH_SOURCE[0]} ..."

if [[ -z "$FZF_PATH" ]]; then
  _fg_red=$(tput setaf 1)
  _reset=$(tput sgr0)
  echo "${_fg_red}ERROR${_reset}: FZF_PATH is not set"
  return
fi

# Setup fzf defaults
if [[ ! "$PATH" == *$FZF_PATH/bin* ]]; then
  PATH="${PATH:+${PATH}:}$FZF_PATH/bin"
fi

eval "$(fzf --bash)"

# Customizations. Source these after the fzf invocation as it overrides the default
source ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/fzf/fzf_functions.bash
source ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/fzf/key-bindings.bash

if hash fd 2> /dev/null; then
  export FZF_CTRL_T_COMMAND="fd --strip-cwd-prefix --hidden --exclude .git --type f"
  export FZF_ALT_C_COMMAND="fd --strip-cwd-prefix --hidden --exclude .git --type d"
fi

export FZF_DEFAULT_OPTS="--ansi --exit-0 --inline-info --reverse --tiebreak=length,end \
  --bind 'shift-tab:toggle-all,alt-p:change-preview-window(down|hidden|)' \
  --bind 'shift-page-down:preview-half-page-down,shift-page-up:preview-half-page-up'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"

# FZF colorschemes
source ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/fzf/themes/catppuccin-frappe.sh
