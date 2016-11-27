########################################################################################################################
# SETUP FZF
##
if [[ ! "$PATH" == */usr/local/install/fzf/bin* ]]; then
  export PATH="$PATH:/usr/local/install/fzf/bin"
fi

if [[ ! "$MANPATH" == */usr/local/install/fzf/man* && -d "/usr/local/install/fzf/man" ]]; then
  export MANPATH="$MANPATH:/usr/local/install/fzf/man"
fi

[[ $- == *i* ]] && source "/usr/local/install/fzf/shell/completion.bash" 2> /dev/null

########################################################################################################################
# Key bindings
##
source "/usr/local/install/fzf/shell/key-bindings.bash"

# Return if shell is non-interactive
[[ ! $- =~ i ]] && return
(( $BASH_VERSINFO > 3 )) && __use_bind_x=1 || __use_bind_x=0
__fzf_use_tmux__ && __use_tmux=1 || __use_tmux=0


# __fzf_history_all__() {

# }

if [[ -o emacs ]]; then
  # Required to refresh the prompt after fzf
  bind '"\er": redraw-current-line'
  bind '"\e^": history-expand-line'

  # CTRL-T - Paste the selected file path into the command line
  if (( $__use_bind_x == 1 )); then
    bind -x '"\C-f\C-f": "fzf-file-widget"'
  elif (( $__use_tmux == 1 )); then
    bind '"\C-f\C-f": " \C-u \C-a\C-k$(__fzf_select_tmux__)\e\C-e\C-y\C-a\C-d\C-y\ey\C-h"'
  else
    bind '"\C-f\C-f": " \C-u \C-a\C-k$(__fzf_select__)\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'
  fi

  # CTRL-R - Paste the selected command from history into the command line
  bind '"\C-r": " \C-e\C-u`__fzf_history__`\e\C-e\e^\er"'

  # ALT-C - cd into the selected directory
  bind '"\C-f\ec": " \C-e\C-u`__fzf_cd__`\e\C-e\er\C-m"'
else
  # We'd usually use "\e" to enter vi-movement-mode so we can do our magic,
  # but this incurs a very noticeable delay of a half second or so,
  # because many other commands start with "\e".
  # Instead, we bind an unused key, "\C-x\C-a",
  # to also enter vi-movement-mode,
  # and then use that thereafter.
  # (We imagine that "\C-x\C-a" is relatively unlikely to be in use.)
  bind '"\C-x\C-a": vi-movement-mode'

  bind '"\C-x\C-e": shell-expand-line'
  bind '"\C-x\C-r": redraw-current-line'
  bind '"\C-x^": history-expand-line'

  # CTRL-T - Paste the selected file path into the command line
  # - FIXME: Selected items are attached to the end regardless of cursor position
  if [ $__use_bind_x -eq 1 ]; then
    bind -x '"\C-t": "fzf-file-widget"'
  elif [ $__use_tmux -eq 1 ]; then
    bind '"\C-t": "\C-x\C-a$a \C-x\C-addi$(__fzf_select_tmux__)\C-x\C-e\C-x\C-a0P$xa"'
  else
    bind '"\C-t": "\C-x\C-a$a \C-x\C-addi$(__fzf_select__)\C-x\C-e\C-x\C-a0Px$a \C-x\C-r\C-x\C-axa "'
  fi
  bind -m vi-command '"\C-t": "i\C-t"'

  # CTRL-R - Paste the selected command from history into the command line
  bind '"\C-r": "\C-x\C-addi$(__fzf_history__)\C-x\C-e\C-x^\C-x\C-a$a\C-x\C-r"'
  bind -m vi-command '"\C-r": "i\C-r"'

  # ALT-C - cd into the selected directory
  bind '"\ec": "\C-x\C-addi$(__fzf_cd__)\C-x\C-e\C-x\C-r\C-m"'
  bind -m vi-command '"\ec": "ddi$(__fzf_cd__)\C-x\C-e\C-x\C-r\C-m"'
fi

unset -v __use_tmux __use_bind_x
