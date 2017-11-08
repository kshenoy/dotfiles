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

#   local _out=($(eval "$_cmd | FZF_DEFAULT_OPTS=\"--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS\" fzf -m $@"))

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
__fzf_select__() {                                                                                                 #{{{1
  local cmd=""
  if [[ -n "${STEM}" ]] && [[ $PWD =~ ^${STEM} ]]; then
    cmd='cat <(p4 have $STEM/... | \
                 command grep -v "$STEM/\(emu\|_env\|env_squash\|fp\|tools\|powerPro\|sdpx\|ch/verif/dft\|ch/verif/txn/old_yml_DO_NOT_USE\|ch/syn\)") \
             <(p4 opened ... 2> /dev/null | command grep add | command sed "s/#.*//" | command xargs -I{} -n1 p4 where {}) \
             <(cd $STEM/import/avf; p4 have ... | command grep -v "$STEM/import/avf/\(_env\)") \
         | command awk "{print \$3}" | command sed "s:$STEM/::"'

    eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
      printf '$STEM/%q ' "$item"
    done
  else
    cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
     -o -type f -print \
     -o -type d -print \
     -o -type l -print 2> /dev/null | cut -b3-"}"

    eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
      printf '%q ' "$item"
    done
  fi
  echo
}


unset -f __fzf_cd__
__fzf_cd__() {                                                                                                     #{{{1
  local cmd dir
  if [[ -n "${STEM}" ]] && [[ $PWD =~ ^${STEM} ]]; then
    cmd='command find $STEM -mindepth 1 \
      -type d \( -path $STEM/_env -o -path $STEM/emu -o -path $STEM/env_squash -o -path $STEM/import -o \
        -path $STEM/powerPro -o -path $STEM/sdpx \) -prune \
      -o -type d -print 2> /dev/null | sed "s:$STEM/::"'
    dir="$STEM/"$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)
  else
    cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
      -o -type d -print 2> /dev/null | cut -b3-"}"
    dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)
  fi
  printf 'cd %q' "$dir"
}


__fzf_history_all__() {                                                                                            #{{{1
  command grep -rash --color=never "" ~/.history_bash | command grep -v '^#' | command sort -u |
    eval "$(__fzf_cmd__) +s +m --tiebreak=index --toggle-sort=ctrl-r $FZF_CTRL_R_OPTS"
}


__fzf_bookmarks__() {                                                                                              #{{{1
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
