__fzf_select__() {                                                                                                # {{{1
  local _arg=${1:-'.'}
  local _cmd="${FZF_CTRL_T_COMMAND:-"command find -L ${_arg} \\( -path '*/\\.*' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | sed -e '1d' -e 's:$_arg/::' "}"

  # The while loop is required to print them all out in one line
  # eval "$_cmd | fzf -m $FZF_CTRL_T_OPTS" | while read -r item; do
  #   printf '%q ' "$item"
  # done
  # echo
  local _out=($(eval "$_cmd | fzf -m $FZF_CTRL_T_OPTS --expect=alt-v,alt-e,alt-c"))
  local _key=$(head -n1 <<< "$_out")

  case ${_key} in
    "alt-v")
      _out[0]="gvim"
      ;;
    "alt-e")
      _out[0]="emacs"
      ;;
    "alt-c")
      if [[ -d ${_out[1]} ]]; then
        _out[0]="cd"
      fi
      ;;
  esac

  paste -s -d' ' <<< ${_out[@]}
}

__fzf_select_work__() {
  local _arg=${1:-'.'}
  if [[ -n "$REPO_PATH" ]] && [[ $_arg =~ $REPO_PATH ]]; then
    local cmd="find -L ${_arg} -type d \\( -iname .svn -o -iname .git -o -iname .hg \\) -prune \
                      -o -type d \\( -name build -o -name .ccache -o -name dfx -o -name emu -o -name _env -o \
                                     -name env_squash -o -name fp -o -name import -o -name libs -o -name powerPro -o \
                                     -name release_gate_tmp -o -name sdpx -o -name sim -o -name tools -o \
                                     -wholename '*/ch/syn' -o -wholename '*/ch/rtl/defines/old' -o \
                                     -wholename '*/ch/variants' -o -wholename '*/ch/verif/dft' -o \
                                     -wholename '*/txn/gen' -o -wholename '*/ch/verif/txn/yml' \\) -prune \
                      -o -type f \\( -name '.*' -o -iname '*.log' -o -iname '*.out' -o -iname '*.so' -o \
                                     -iname '*.cc.o' -o -iname '*tags*' \\) -prune \
                      -o -type f -print -o -type d -print -o -type l -print 2> /dev/null | sed -e '1d' -e 's:$_arg/::' "
  else
    local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . \\( -path '*/\\.*' -o -fstype 'dev' -o -fstype 'proc' \\) -prune \
      -o -type f -print \
      -o -type d -print \
      -o -type l -print "}"
  fi
  eval "$cmd 2> /dev/null | sed 1d | cut -b3- | fzf -m $FZF_CTRL_T_OPTS" | while read -r item; do
    printf '%q ' "$item"
  done
  echo
}
# }}}1

[[ ! $- =~ i ]] && return

__fzf_use_tmux__() {
  [[ -n "$TMUX_PANE" ]] && [[ "${FZF_TMUX:-1}" != 0 ]] && [[ ${LINES:-40} -gt 15 ]]
}


[[ $BASH_VERSINFO -gt 3 ]] && __use_bind_x=1 || __use_bind_x=0
__fzf_use_tmux__ && __use_tmux=1 || __use_tmux=0


__fzf_cmd__() {                                                                                                   # {{{1
  [[ "${FZF_TMUX:-1}" != 0 ]] && echo "fzf-tmux -d${FZF_TMUX_HEIGHT:-40%}" || echo "fzf"
}


__fzf_select_tmux__() {                                                                                           # {{{1
  local _arg=${1:-'.'}
  local _height=${FZF_TMUX_HEIGHT:-40%}
  if [[ $_height =~ %$ ]]; then
    _height="-p ${_height%\%}"
  else
    _height="-l $_height"
  fi

  tmux split-window $_height "cd $(printf %q "$PWD"); FZF_DEFAULT_OPTS=$(printf %q "$FZF_DEFAULT_OPTS") PATH=$(printf %q "$PATH") FZF_CTRL_T_COMMAND=$(printf %q "$FZF_CTRL_T_COMMAND") FZF_CTRL_T_OPTS=$(printf %q "$FZF_CTRL_T_OPTS") bash -c 'source \"${BASH_SOURCE[0]}\"; RESULT=\"\$(__fzf_select__ $_arg)\"; tmux setb -b fzf \"\$RESULT\" \\; pasteb -b fzf -t $TMUX_PANE \\; deleteb -b fzf || tmux send-keys -t $TMUX_PANE \"\$RESULT\"'"
}


__fzf_cd__() {                                                                                                    # {{{1
  local _arg=${1:-'.'}
  local _cmd="${FZF_ALT_C_COMMAND:-"command find -L ${_arg} \\( -path '*/\\.*' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type d -print 2> /dev/null | sed -e '1d' -e 's:$_arg/::' "}"
  local _dir=$(eval "$_cmd | $(__fzf_cmd__) +m $FZF_ALT_C_OPTS") && printf 'cd %q' "$_dir"
}


__fzf_history__() (                                                                                               # {{{1
  shopt -u nocaseglob nocasematch
  # The pipe after history is to remove duplicate items and keep the last one
  local _line=$(
    HISTTIMEFORMAT= command history | command tac | command sort -k2 -u | command sort -n |
    eval "$(__fzf_cmd__) +s --tac +m -n2.. --tiebreak=index --toggle-sort=ctrl-r $FZF_CTRL_R_OPTS" |
    command grep '^ *[0-9]') &&
    if [[ $- =~ H ]]; then
      command sed 's/^ *\([0-9]*\)\** .*/!\1/' <<< "$_line"
    else
      command sed 's/^ *\([0-9]*\)\** *//' <<< "$_line"
    fi
)


__fzf_history_all__() {                                                                                           # {{{1
  command grep -rash --color=never "" ~/.history_bash | command grep -v '^#' | command sort -u |
    eval "$(__fzf_cmd__) +s +m --tiebreak=index --toggle-sort=ctrl-r $FZF_CTRL_R_OPTS"
}


__fzf_file_widget__() {                                                                                           # {{{1
  local _arg=${1:-'.'}
  if __fzf_use_tmux__; then
    __fzf_select_tmux__ ${_arg}
  else
    local _selected="$(__fzf_select__ ${_arg})"
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${_selected}${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$(( READLINE_POINT + ${#_selected} ))
  fi
}


__fzf_bookmarks__() {                                                                                             # {{{1
  local _cmd="cat <(command find -L ~/Notes -type f -name '*.org' 2> /dev/null) ~/bookmarks"

  local _out=($(eval "$_cmd | sed "s:${HOME}:~:g" | fzf -m --expect=alt-v,alt-e"))
  local _key=$(head -n1 <<< "$_out")

  case ${_key} in
    "alt-v")
      _out[0]="gvim 2> /dev/null"
      eval "$(paste -s -d' ' <<< ${_out[@]})"
      ;;
    "alt-e")
      _out[0]="emacs"
      eval "$(paste -s -d' ' <<< ${_out[@]})"
      ;;
    *)
      local _selected=$(paste -s -d' ' <<< ${_out[@]})
      READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${_selected}${READLINE_LINE:$READLINE_POINT}"
      READLINE_POINT=$(( READLINE_POINT + ${#_selected} ))
    ;;
  esac
}
# }}}1


if [[ ! -o vi ]]; then                                                                                            # {{{1
  # Required to refresh the prompt after fzf
  bind '"\er": redraw-current-line'
  bind '"\e^": history-expand-line'

  # CTRL-T - Paste the selected file path into the command line
  if (( $__use_bind_x == 1 )); then
    bind -x '"\C-f\C-f": "__fzf_file_widget__"'
  elif (( $__use_tmux == 1 )); then
    bind '"\C-f\C-f": " \C-u \C-a\C-k$(__fzf_select_tmux__)\e\C-e\C-y\C-a\C-d\C-y\ey\C-h"'
  else
    bind '"\C-f\C-f": " \C-u \C-a\C-k$(__fzf_select__)\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'
  fi

  # CTRL-R - Paste the selected command from history into the command line
  bind '"\C-r": " \C-e\C-u`__fzf_history__`\e\C-e\e^\er"'
  # CTRL-F CTRL-R - Global history
  bind '"\C-f\C-r": " \C-e\C-u`__fzf_history_all__`\e\C-e\e^\er"'

  # ALT-C - cd into the selected directory
  bind '"\C-f\ec": " \C-e\C-u`__fzf_cd__`\e\C-e\er\C-m"'

  # CTRL-B - Bookmarks and notes
  if (( $__use_bind_x == 1 )); then
    bind -x '"\C-f\C-b": "__fzf_bookmarks__"'
  fi
else                                                                                                              # {{{1
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
    bind -x '"\C-t": "__fzf_file_widget__"'
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
# }}}1

unset -v __use_tmux __use_bind_x
