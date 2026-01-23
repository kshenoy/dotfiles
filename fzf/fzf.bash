#!/usr/bin/env bash
echo "$(tput setaf 2)Sourcing$(tput sgr0) ${BASH_SOURCE[0]} ..."

if [[ -z "$FZF_PATH" ]]; then
  _fg_red=$(tput setaf 1)
  _reset=$(tput sgr0)
  echo "${_fg_red}ERROR${_reset}: FZF_PATH is not set"
  return
fi

# Setup fzf defaults - prepend to PATH to override system fzf
if [[ ! "$PATH" == *$FZF_PATH/fzf/bin* ]]; then
  export PATH="$FZF_PATH/fzf/bin${PATH:+:${PATH}}"
fi

eval "$($FZF_PATH/fzf/bin/fzf --bash)"

# Source fzf-git.sh for enhanced git integration
# (our custom VCS bindings in key-bindings.bash will override the default C-g bindings)
if [[ -f $FZF_PATH/fzf-git.sh/fzf-git.sh ]]; then
  . $FZF_PATH/fzf-git.sh/fzf-git.sh
fi

# Customizations. Source these after the fzf invocation as it overrides the default
. ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/fzf/fzf_functions.bash
. ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/fzf/key-bindings.bash

if hash fd 2> /dev/null; then
  export FZF_CTRL_T_COMMAND="fd --strip-cwd-prefix --hidden --exclude .git --type f"
  export FZF_ALT_C_COMMAND="fd --strip-cwd-prefix --hidden --exclude .git --type d"
fi

export FZF_DEFAULT_OPTS="--ansi --border --exit-0 --select-1 --multi --inline-info --reverse --tiebreak=length,end \
  --bind 'shift-tab:toggle-all,alt-p:change-preview-window(down|hidden|)' \
  --bind 'shift-page-down:preview-half-page-down,shift-page-up:preview-half-page-up'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"

# FZF colorschemes
. ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/fzf/themes/catppuccin-frappe.sh
