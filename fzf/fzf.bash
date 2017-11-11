# Setup fzf
# ---------
if [[ ! "$PATH" == *$FZF_PATH/bin* ]]; then
  export PATH="$PATH:$FZF_PATH/bin"
fi

# Man path
# --------
if [[ ! "$MANPATH" == *$FZF_PATH/man* ]] && [[ -d "$FZF_PATH/man" ]]; then
  export MANPATH="$MANPATH:$FZF_PATH/man"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$FZF_PATH/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
# Note the order is important because some functions get overridden
. ~/install/fzf/shell/key-bindings.bash
. ~/.dotfiles/fzf/key-bindings.bash

# Customisations
# --------------
export FZF_DEFAULT_OPTS='--ansi'
# export FZF_CTRL_T_OPTS='--expect=alt-v,alt-e,alt-c'
