fzf-recent-dirs() {                                                                                               # {{{1
  local out=($(command dirs -p | fzf --expect=alt-c "$@"))

  case $(head -n1 <<< "$out") in
    "alt-c")
      # echo "cd ${out[1]}"
      echo "cd $(sed 's:~:/home/kshenoy:' <<< ${out[1]})"
      eval "cd $(sed 's:~:/home/kshenoy:' <<< ${out[1]})"
      ;;
    *)
      local dir="${out[0]}"
      READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${dir}${READLINE_LINE:$READLINE_POINT}"
      READLINE_POINT=$(( READLINE_POINT + ${#dir} ))
      ;;
  esac
  # echo "Key=${key}, Dir=${dir}"
}


fzf-lsf-bjobs() {                                                                                                  #{{{1
  local selected=$(lsf_bjobs -w |
    FZF_DEFAULT_OPTS="--header-lines=1 --height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" |
    cut -d' ' -f1 | while read -r item; do
      printf '%q ' "$item"
    done
  )

  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}


__fzf_cmd_opts__() {                                                                                               #{{{1
  # echo "DEBUG: >>>${READLINE_LINE}<<< Point=${READLINE_POINT}, Char=${READLINE_LINE:$READLINE_POINT:0}"
  local pos=$READLINE_POINT

  # If cursor is on a non-whitespace char assume it's on the cmd that needs to be parsed and move pos to its end
  while [[ ${READLINE_LINE:$pos:0} != " " ]] && [[ $pos != ${#READLINE_LINE} ]]; do
    pos=$(( pos + 1 ))
  done

  # Try to get the command behind all aliases
  local cmd=$(awk '{print $NF}' <<< "${READLINE_LINE:0:$pos}")
  # echo "DEBUG: Cmd=$cmd"

  local sanityCount=1
  for sanityCount in {1..20}; do
    command alias | command which --read-alias $cmd | while read line; do
      if [[ $line =~ ^alias ]]; then
        cmd=$(cut -d"'" -f2 <<< "$line" | awk '{print $1}');
      else
        cmd=$(awk '{print $1}' <<< "$line")
        echo "DEBUG: Cmd=$cmd"
      fi
    done
    echo "DEBUG: Cmd=$cmd"
    if [[ -x $cmd ]]; then
      break
    fi
  done
  # echo "DEBUG: Cmd=$cmd"
  if [[ ! -x $cmd ]]; then
    return
  fi

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
    # echo "Needs space before cursor"
    selected=" ${selected}"
  fi

  if [[ "${READLINE_LINE:$pos:1}" == " " ]]; then
    # If cursor has a space after it, remove last space from selected
    # echo "Removing space after cursor"
    selected="${selected% }"
  fi

  READLINE_LINE="${READLINE_LINE:0:pos}${selected}${READLINE_LINE:$pos}"
  # Not moving the READLINE_POINT makes it easier to launch this again
  # READLINE_POINT=$((READLINE_POINT + ${#selected}))
}


# __fzf_bookmarks__() {                                                                                            #{{{1
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


# Info on bind usage: https://stackoverflow.com/a/47878915/734153
# bind -X : List all key sequences bound to shell commands (using -x)
#      -S : Display readline key sequences bound to macros and the strings they output
#
# Unbind C-t as it clobbers with tmux's prefix
bind '"\C-t": nop'

if [[ -o vi ]]; then                                                                                                #{{{
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

if [[ -o emacs ]]; then                                                                                             #{{{
  # CTRL-F - Paste the selected file path into the command line (changed from default CTRL-T)
  if (( $BASH_VERSINFO > 3 )); then
    # bind -x '"\C-f\C-f": "fzf-file-widget"'
    bind -x '"\C-f\C-f": "fzf-vcs-all-files"'
  elif __fzf_use_tmux__; then
    bind '"\C-f\C-f": " \C-u \C-a\C-k`__fzf_select_tmux__`\e\C-e\C-y\C-a\C-d\C-y\ey\C-h"'
  else
    bind '"\C-f\C-f": " \C-u \C-a\C-k`__fzf_select__`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'
  fi

  # cd into the selected directory. C-g to match VCS' binding C-v C-g. C-d because it operates on output of dirs command
  # Unbind the default one first and then create new bindings
  bind '"\ec": nop'
  bind '"\C-f\C-g": " \C-e\C-u`__fzf_cd__`\e\C-e\er\C-m"'
  bind -x '"\C-f\C-d": "fzf-recent-dirs"'

  bind -x '"\C-f\C-l": "fzf-lsf-bjobs"'

  # CTRL-O: Show list of options of the command before the cursor using '<cmd> -h'
  bind -x '"\C-f\C-o": "__fzf_cmd_opts__"'

  # CTRL-G CTRL-E: Experimental
  # bind -x '"\C-f\C-g\C-e": "__fzf_expt__"'

  # Version-control related bindings: CTRL-F CTRL-V
  bind -x '"\C-f\C-v\C-e": "fzf-vcs-files"'
  bind -x '"\C-f\C-v\C-f": "fzf-vcs-all-files"'
  bind -x '"\C-f\C-v\C-s": "fzf-vcs-status"'
  bind '"\C-f\C-v\C-g": " \C-e\C-u`fzf-vcs-cd`\e\C-e\er\C-m"'
  bind '"\C-f\C-v\C-w": " \C-e\C-u`__fzf_p4_walist__`\e\C-e\er\C-m"'

  bind '"\er": redraw-current-line'
  bind '"\C-f\C-v\C-d": "$(fzf-git-diffs)\e\C-e\er"'
  bind '"\C-f\C-v\C-b": "$(fzf-git-branches)\e\C-e\er"'
  bind '"\C-f\C-v\C-t": "$(fzf-git-tags)\e\C-e\er"'
  bind '"\C-f\C-v\C-h": "$(fzf-git-hashes)\e\C-e\er"'
  bind '"\C-f\C-v\C-r": "$(fzf-git-remotes)\e\C-e\er"'

  # Alt-/: Repeat last command and pipe result to FZF
  # From http://brettterpstra.com/2015/07/09/shell-tricks-inputrc-binding-fun/
  bind '"\C-f\e/": "!!|FZF_DEFAULT_OPTS=\"--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS\" fzf -m\C-m\C-m"'
fi #}}}
