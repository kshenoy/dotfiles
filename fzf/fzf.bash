# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$FZF_PATH/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
# Note the order is important because some functions get overridden
. $FZF_PATH/shell/key-bindings.bash
. $HOME/.dotfiles/fzf/fzf_vcs.bash
. $HOME/.dotfiles/fzf/key-bindings.bash

# Customisations
# --------------
export FZF_DEFAULT_OPTS='--ansi --reverse --exit-0'
# export FZF_CTRL_T_OPTS='--expect=alt-v,alt-e,alt-c'
