# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/install/fzf/bin* ]]; then
  export PATH="$PATH:/usr/local/install/fzf/bin"
fi

# Man path
# --------
if [[ ! "$MANPATH" == */usr/local/install/fzf/man* && -d "/usr/local/install/fzf/man" ]]; then
  export MANPATH="$MANPATH:/usr/local/install/fzf/man"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/install/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source ~/.dotfiles/fzf/key-bindings.bash
