#!/usr/bin/env bash
echo "$(tput setaf 2)Sourcing$(tput sgr0) ${BASH_SOURCE[0]} ..."

if [[ -z "$FZF_HOME" ]]; then
  _fg_red=$(tput setaf 1)
  _reset=$(tput sgr0)
  echo "${_fg_red}ERROR${_reset}: FZF_HOME is not set"
  return
fi

if [[ ! "$PATH" == *$FZF_HOME/bin* ]]; then
  export PATH="${PATH:+${PATH}:}$FZF_HOME/bin"
fi

eval "$($FZF_HOME/bin/fzf --bash)"

# Source fzf-git.sh for enhanced git integration
# (our custom VCS bindings in key-bindings.bash will override the default C-g bindings)
# Note that I'm using FZF_HOME here for fzf-git as well as I'm installing fzf-git in the same dir as fzf
if [[ -f $FZF_HOME-git.sh/fzf-git.sh ]]; then
  . $FZF_HOME-git.sh/fzf-git.sh
fi

# Customizations. Source these after the fzf invocation as it overrides the default
. ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/fzf/fzf_functions.bash
. ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/fzf/key-bindings.bash

if hash fd 2> /dev/null; then
  export FZF_CTRL_T_COMMAND="fd --strip-cwd-prefix --hidden --exclude .git --type f"
  export FZF_ALT_C_COMMAND="fd --strip-cwd-prefix --hidden --exclude .git --type d"
fi

export FZF_DEFAULT_OPTS="--ansi --exit-0 --select-1 --multi --inline-info --reverse --tiebreak=length,end \
  --bind 'shift-tab:toggle-all,alt-p:change-preview-window(down|hidden|)' \
  --bind 'shift-page-down:preview-half-page-down,shift-page-up:preview-half-page-up'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"

# FZF colorschemes
. ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/fzf/themes/catppuccin-frappe.sh
