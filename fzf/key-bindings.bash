# __fzf_select__() {                                                                                               #{{{1
#   local _cmd=""
#   if [[ -n "${STEM}" ]] && [[ $PWD =~ ^${STEM} ]]; then
#     _cmd='cat <(p4 have $STEM/... | \
#                   \grep -v "$STEM/\(emu\|_env\|env_squash\|fp\|tools\|powerPro\|sdpx\|ch/verif/dft\|ch/verif/txn/old_yml_DO_NOT_USE\|ch/syn\)") \
#               <(p4 opened ... 2> /dev/null | \grep add | \sed "s/#.*//" | \xargs -I{} -n1 p4 where {}) \
#               <(cd $STEM/import/avf; p4 have ... | \grep -v "$STEM/import/avf/\(_env\)") \
#           | \awk "{print \$3}" | sed "s:$STEM/::"'
#   else
#     _cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
#       -o -type f -print \
#       -o -type d -print \
#       -o -type l -print 2> /dev/null | cut -b3-"}"
#   fi

#   echo $_cmd

#   local _out=($(eval "$_cmd | FZF_DEFAULT_OPTS=\"--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS\" fzf -m $@"))

#   local _key=$(head -n1 <<< "$_out")
#   case ${_key} in
#     "alt-v")
#       _out[0]="gvim"
#       ;;
#     "alt-e")
#       _out[0]="emacs"
#       ;;
#     "alt-c")
#       if [[ -d ${_out[1]} ]]; then
#         _out[0]="cd"
#       fi
#       ;;
#   esac

#   paste -s -d' ' <<< ${_out[@]}
# }


unset -f __fzf_select__
__fzf_select() {                                                                                                   #{{{1
  local cmd=""
  if [[ -n "${STEM}" ]]; then
    cmd='cat <(p4 have $STEM/... | \
                 command grep -v "$STEM/\(emu\|_env\|env_squash\|fp\|tools\|powerPro\|sdpx\|ch/verif/dft\|ch/verif/txn/old_yml_DO_NOT_USE\|ch/syn\)") \
             <(p4 opened $STEM/... 2> /dev/null | command grep add | command sed "s/#.*//" | command xargs -I{} -n1 p4 where {}) \
             <(cd $STEM/import/avf; p4 have ... | command grep -v "$STEM/import/avf/\(_env\)") \
         | command awk "{print \$3}" | command sed "s:$STEM/::"'

    eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
      printf '$STEM/%q ' "$item"
    done
  else
    cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
     -o -type f -print \
     -o -type d -print \
     -o -type l -print 2> /dev/null | cut -b3-"}"

    eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
      printf '%q ' "$item"
    done
  fi
  echo
}


unset -f __fzf_cd__
__fzf_cd() {                                                                                                       #{{{1
  local cmd dir
  if [[ -n "${STEM}" ]] && [[ $PWD =~ ^${STEM} ]]; then
    cmd='command find $STEM -mindepth 1 \
      -type d \( -path $STEM/_env -o -path $STEM/emu -o -path $STEM/env_squash -o -path $STEM/import -o \
        -path $STEM/powerPro -o -path $STEM/sdpx \) -prune \
      -o -type d -print 2> /dev/null | sed "s:$STEM/::"'
    dir="$STEM/"$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)
  else
    cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
      -o -type d -print 2> /dev/null | cut -b3-"}"
    dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)
  fi
  printf 'cd %q' "$dir"
}


__fzf_lsf_bjobs() {                                                                                                #{{{1
  local selected=$(lsf_bjobs -w | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m --header-lines=1 "$@" | cut -d ' ' -f1 | while read -r item; do
    printf '%q ' "$item"
  done; echo)

  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}


__fzf_cmd_opts() {                                                                                               #{{{1
  # echo ">>>${READLINE_LINE}<<< Point=${READLINE_POINT}"

  cmd=$(awk '{print $NF}' <<< "${READLINE_LINE:0:$READLINE_POINT}")
  # echo "Cmd=$cmd"
  if [[ ! -x $(which $cmd) ]]; then
    return
  fi

  local selected=$(eval "${cmd} --help || ${cmd} -h || ${cmd} -help" | \
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf +x -m "$@" | \
    while read -r item; do
      local opts=($item)
      local opt=${opts[0]}
      for i in ${opts[@]}; do
        if [[ "$i" == --* ]]; then
          opt="$i"
          break
        fi
      done
      printf '%q ' $(awk '{print $1}' <<< "$opt" | sed 's/[,=].*$//')
    done; echo)

  if [[ "${READLINE_LINE:$(($READLINE_POINT-1)):1}" != " " ]]; then
    # If cursor doesn't have a space before it, add one
    # echo "Needs space before cursor"
    selected=" ${selected}"
  fi

  if [[ "${READLINE_LINE:$READLINE_POINT:1}" == " " ]]; then
    # If cursor has a space after it, remove last space from selected
    # echo "Removing space after cursor"
    selected="${selected% }"
  fi

  READLINE_LINE="${READLINE_LINE:0:READLINE_POINT}${selected}${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$((READLINE_POINT + ${#selected}))
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


# Unbind the default key used by FZF
bind '"\C-t": nop'
bind '"\ec":  nop'

if [[ -o vi ]]; then
  if (( $BASH_VERSINFO > 3 )); then
    bind -x '"\C-t\C-t": "fzf-file-widget"'
  fi
else
  if (( $BASH_VERSINFO > 3 )); then
    bind -x '"\C-t\C-t": "fzf-file-widget"'
  fi

  # Alt+C: cd into the selected directory
  bind '"\C-t\ec": " \C-e\C-u`__fzf_cd`\e\C-e\er\C-m"'

  bind -x '"\C-t\C-g\C-l": "__fzf_lsf_bjobs"'

  # Ctrl+O: Show list of options of the command before the cursor using '<cmd> -h'
  bind -x '"\C-t\C-o": "__fzf_cmd_opts"'

  # Ctrl+G Ctrl+E: Experimental
  # bind -x '"\C-t\C-g\C-e": "__fzf_expt"'

  # Version-control
  bind -x '"\C-t\C-p\C-o": "__fzf_p4_opened"'
  bind '"\C-t\C-p\C-w": " \C-e\C-u`__fzf_p4_walist`\e\C-e\er\C-m"'

  bind '"\er": redraw-current-line'
  bind '"\C-t\C-p\C-d": "$(fzf-git-diffs)\e\C-e\er"'
  bind '"\C-t\C-p\C-b": "$(fzf-git-branches)\e\C-e\er"'
  bind '"\C-t\C-p\C-t": "$(fzf-git-tags)\e\C-e\er"'
  bind '"\C-t\C-p\C-h": "$(fzf-git-hashes)\e\C-e\er"'
  bind '"\C-t\C-p\C-r": "$(fzf-git-remotes)\e\C-e\er"'

  # Alt+/: From http://brettterpstra.com/2015/07/09/shell-tricks-inputrc-binding-fun/
  bind '"\C-t\e/": "$(!!|FZF_DEFAULT_OPTS=\"--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS\" fzf -m)\C-a \C-m\C-m"'
fi
