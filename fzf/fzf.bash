#!/usr/bin/env bash
echo "$(tput setaf 2)Sourcing$(tput sgr0) ${BASH_SOURCE[0]} ..."

if [[ -z "$FZF_HOME" ]]; then
  _fg_red=$(tput setaf 1)
  _reset=$(tput sgr0)
  echo "${_fg_red}ERROR${_reset}: FZF_HOME is not set"
  return
fi

export PATH="$FZF_HOME/bin${PATH:+:${PATH}}"

if hash fd 2>/dev/null; then
  export FZF_CTRL_T_COMMAND="fd --strip-cwd-prefix --hidden --exclude .git --type f"
  export FZF_ALT_C_COMMAND="fd --strip-cwd-prefix --hidden --exclude .git --type d"
fi

export FZF_DEFAULT_OPTS="--ansi --exit-0 --select-1 --multi --inline-info --reverse --tiebreak=length,end \
  --bind 'shift-tab:toggle-all,alt-p:change-preview-window(down|hidden|)' \
  --bind 'shift-page-down:preview-half-page-down,shift-page-up:preview-half-page-up'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# FZF colorschemes (appends --color flags to FZF_DEFAULT_OPTS)
. ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/fzf/themes/catppuccin-frappe.sh

eval "$($FZF_HOME/bin/fzf --bash)"

# Source fzf-git.sh for enhanced git integration
# (our custom VCS bindings in key-bindings.bash will override the default C-g bindings)
# Set FZF_GIT_HOME to the fzf-git.sh repo directory (e.g. ~/.local/share/fzf-git.sh)
if [[ -n "$FZF_GIT_HOME" ]] && [[ -f $FZF_GIT_HOME/fzf-git.sh ]]; then
  . $FZF_GIT_HOME/fzf-git.sh
fi

# Source after fzf-git.sh: fzf_functions.bash overrides _fzf_git_fzf defined there
. ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/fzf/fzf_functions.bash
. ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/fzf/key-bindings.bash
