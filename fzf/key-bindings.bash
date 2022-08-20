#=======================================================================================================================
fzf::lsf::bjobs() {                                                                                                #{{{1
  local selected=$(lsf_bjobs -o "id: user: stat: queue: submit_time: name" |
    FZF_DEFAULT_OPTS="--header-lines=1 $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" |
    cut -d' ' -f1 | while read -r item; do
      printf '%q ' "$item"
    done
  )

  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}


#=======================================================================================================================
fzf::cmd_opts() {                                                                                                  #{{{1
  # echo "DEBUG: '${READLINE_LINE}' Point=${READLINE_POINT}, Char='${READLINE_LINE:$READLINE_POINT:1}'"
  local pos=$READLINE_POINT

  # If cursor is on a non-whitespace char assume it's on the cmd that needs to be parsed and move pos to its end
  while [[ ${READLINE_LINE:$pos:1} != " " ]] && [[ $pos != ${#READLINE_LINE} ]]; do
    pos=$(( pos + 1 ))
  done
  local cmd=$(awk '{print $NF}' <<< "${READLINE_LINE:0:$pos}")

  local selected=$(eval "${cmd} --help || ${cmd} -h || ${cmd} -help || ${cmd} help" | \
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf +x -m "$@" | \
    while read -r item; do
      # Auto-split on whitespace
      local words=($item)
      for i in ${words[@]}; do
        if [[ "$i" == -* ]]; then
          local opt="$i"
          break
        fi
      done
      printf '%q ' $(awk '{print $1}' <<< "$opt" | sed 's/[,=].*$//')
    done; echo)

  if [[ "${READLINE_LINE:$(($pos-1)):1}" != " " ]]; then
    # If cursor doesn't have a space before it, add one
    selected=" ${selected}"
  fi

  if [[ "${READLINE_LINE:$pos:1}" == " " ]]; then
    # If cursor has a space after it, remove last space from selected
    # echo "Removing space after cursor"
    selected="${selected% }"
  fi

  READLINE_LINE="${READLINE_LINE:0:pos}${selected}${READLINE_LINE:$pos}"
  # Note that the READLINE_POINT has not moved; this makes it easier to launch this again
}


#=======================================================================================================================
fzf::tmux::select_session() {                                                                                      #{{{1
  # Create new tmux session, or switch to existing one. Works from within tmux too
  if [[ -n "$TMUX" ]]; then
    local cmd="switch-client"
  else
    local cmd="attach-session"
  fi

  local session=$(tmux list-sessions 2>/dev/null |
                  sed -e 's/ (created[^)]*)//' -e 's/:/ :/' | column -t -o ' ' |
                  fzf --nth=1 |
                  awk '{print $1}')
  if [[ -n "$session" ]]; then
    tmux $cmd -t "$session"
  fi
}


#=======================================================================================================================
# fzf::bookmarks() {                                                                                               #{{{1
  
#   local _cmd='grep filename ${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/emacs/bookmarks | cut -d " " -f4 | tr -d \'")\' | sed -e "s,/ssh:\w\+:,," -e "s,~,\$HOME," | sort -u' | while
# read -r item; do
# [[ -d "$item" ]] && printf '%q\n' "$item"
# done
#   local _cmd="cat <(command find -L ~/Notes -type f -name '*.org' 2> /dev/null) ~/bookmarks"

#   local _out=($(eval "$_cmd | sed "s:${HOME}:~:g" | fzf -m --expect=alt-v,alt-e"))
#   local _key=$(head -n1 <<< "$_out")

#   case ${_key} in
#     "alt-v")
#       _out[0]="gvim 2> /dev/null"
#       eval "$(paste -s -d' ' <<< ${_out[@]})"
#       ;;
#     "alt-e")
#       _out[0]="emacs"
#       eval "$(paste -s -d' ' <<< ${_out[@]})"
#       ;;
#     *)
#       local _selected=$(paste -s -d' ' <<< ${_out[@]})
#       READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${_selected}${READLINE_LINE:$READLINE_POINT}"
#       READLINE_POINT=$(( READLINE_POINT + ${#_selected} ))
#     ;;
#   esac
# }
# }}}1


#=======================================================================================================================
# Info on bind usage: https://stackoverflow.com/a/47878915/734153
# bind -X : List all key sequences bound to shell commands (using -x)
#      -S : Display readline key sequences bound to macros and the strings they output
#
# Unbind C-t as I want to sue C-f instead
bind '"\C-t": nop'


#=======================================================================================================================
if [[ -o vi ]]; then                                                                                               #{{{
  # CTRL-F - Paste the selected file path into the command line (changed from default CTRL-T)
  # - FIXME: Selected items are attached to the end regardless of cursor position
  if (( $BASH_VERSINFO > 3 )); then
    bind -x '"\C-f\C-f": "fzf-file-widget"'
  elif __fzf_use_tmux__; then
    bind '"\C-f\C-f": "\C-x\C-a$a \C-x\C-addi`__fzf_select_tmux__`\C-x\C-e\C-x\C-a0P$xa"'
  else
    bind '"\C-f\C-f": "\C-x\C-a$a \C-x\C-addi`__fzf_select__`\C-x\C-e\C-x\C-a0Px$a \C-x\C-r\C-x\C-axa "'
  fi
  bind -m vi-command '"\C-f\C-f": "i\C-f\C-f"'
fi # }}}


#=======================================================================================================================
if [[ -o emacs ]]; then                                                                                            #{{{
  # CTRL-F - Paste the selected file path into the command line (changed from default CTRL-T)
  if (( $BASH_VERSINFO > 3 )); then
    bind -x '"\C-f\C-f": "fzf-file-widget"'
  elif __fzf_use_tmux__; then
    bind '"\C-f\C-f": " \C-u \C-a\C-k`__fzf_select_tmux__`\e\C-e\C-y\C-a\C-d\C-y\ey\C-h"'
  else
    bind '"\C-f\C-f": " \C-u \C-a\C-k`__fzf_select__`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'
  fi

  # cd into the selected directory
  # Unbind the default one first and then create new bindings
  bind '"\ec": nop'

  bind -x '"\C-f\C-l": "fzf::lsf::bjobs"'

  # CTRL-O: Show list of options of the command before the cursor using '<cmd> -h'
  bind -x '"\C-f\C-o": "fzf::cmd_opts"'

  # CTRL-X: Experimental
  # bind -x '"\C-f\C-x": "fzf::_expt"'

  # Tmux related bindings: CTRL-F CTRL-T
  bind -x '"\C-f\C-t\C-s": "fzf::tmux::select_session"'

  # Version-control related bindings: CTRL-F CTRL-V
  bind -x '"\C-f\C-v\C-b": "fzf::git::branches"'
  bind -x '"\C-f\C-v\C-d": "fzf::git::diffs"'
  bind -x '"\C-f\C-v\C-e": "fzf::vcs::files"'
  bind -x '"\C-f\C-v\C-f": "fzf::vcs::all_files"'
  bind    '"\C-f\C-v\C-g": " \C-e\C-u`fzf::vcs::cd`\e\C-e\er\C-m"'
  bind -x '"\C-f\C-v\C-k": "fzf::vcs::commits"'
  bind -x '"\C-f\C-v\C-l": "fzf::vcs::filelog"'
  bind -x '"\C-f\C-v\C-r": "fzf::git::remotes"'
  bind -x '"\C-f\C-v\C-s": "fzf::vcs::status"'
  bind -x '"\C-f\C-v\C-t": "fzf::git::tags"'

  bind '"\er": redraw-current-line'

  # Alt-/: Repeat last command and pipe result to FZF
  # From http://brettterpstra.com/2015/07/09/shell-tricks-inputrc-binding-fun/
  bind '"\C-f\e/": "!! | fzf -m\C-m\C-m"'
fi #}}}
