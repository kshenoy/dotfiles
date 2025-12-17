#=======================================================================================================================
fzf::lsf::bjobs() {
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
fzf::cmd_opts() {
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
# Enhanced history search across all archived history files
# Usage: fzf::prehistory [months]
#   months: number of months to search (default: 6, -1 for all history)
fzf::prehistory() {
  local output
  local months="${1:-6}"  # Default to 6 months if no argument provided

  # Search through all archived history files in the bash_history directory
  local hist_dir="${HOME}/.local/share/bash_history"

  # Set up the date filter for find command
  local newermt_filter=""
  if [[ "$months" -ne -1 ]]; then
    local cutoff_date=$(date -d "$months months ago" +%s 2>/dev/null || date -v-${months}m +%s 2>/dev/null)
    newermt_filter="-newermt @$cutoff_date"
  fi

  output=$(
    if [[ -d "$hist_dir" ]]; then
      find "$hist_dir" -type f $newermt_filter -exec cat {} \; 2>/dev/null | \
        grep -v '^#' | \
        awk '!seen[$0]++' | \
        FZF_DEFAULT_OPTS="--reverse --scheme=history --bind=ctrl-r:toggle-sort ${FZF_CTRL_R_OPTS-} +m" \
        FZF_DEFAULT_OPTS_FILE='' fzf --query "$READLINE_LINE"
    fi
  ) || return

  READLINE_LINE="$output"
  if [[ -z $READLINE_POINT ]]; then
    echo "$READLINE_LINE"
  else
    READLINE_POINT=${#READLINE_LINE}
  fi
}


#=======================================================================================================================
# Info on bind usage: https://stackoverflow.com/a/47878915/734153
# bind -X : List all key sequences bound to shell commands (using -x)
#      -S : Display readline key sequences bound to macros and the strings they output

#=======================================================================================================================
# CTRL-F CTRL-F instead of CTRL-T : Paste the selected file path into the command line
# These were obtained directly from FZF's key-bindings.bash file and modified
bind -m emacs-standard '"\C-t": nop'
bind -m vi-command '"\C-t": nop'
bind -m vi-insert '"\C-t": nop'
if ((BASH_VERSINFO[0] < 4)); then
  # CTRL-T - Paste the selected file path into the command line
  if [[ ${FZF_CTRL_T_COMMAND-x} != "" ]]; then
    bind -m emacs-standard '"\C-f\C-f": " \C-b\C-k \C-u`__fzf_select__`\e\C-e\er\C-a\C-y\C-h\C-e\e \C-y\ey\C-x\C-x\C-f\C-y\ey\C-_"'
  fi
else
  # CTRL-T - Paste the selected file path into the command line
  if [[ ${FZF_CTRL_T_COMMAND-x} != "" ]]; then
    bind -m emacs-standard -x '"\C-f\C-f": fzf-file-widget'
  fi
fi

#=======================================================================================================================
# CTRL-F CTRL-J instead of ALT-C : cd into the selected directory
# These were obtained directly from FZF's key-bindings.bash file and modified
bind -m emacs-standard '"\ec": nop'
bind -m vi-command '"\ec": nop'
bind -m vi-insert '"\ec": nop'
if [[ ${FZF_ALT_C_COMMAND-x} != "" ]]; then
  bind -m emacs-standard '"\C-f\C-j": " \C-b\C-k \C-u`__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d\C-y\ey\C-_"'
fi

#=======================================================================================================================
# CTRL-F CTRL-L: Search all running LSF jobs
bind -m emacs-standard -x '"\C-f\C-l": "fzf::lsf::bjobs"'

# CTRL-F CTRL-O: Show list of options of the command before the cursor using '<cmd> -h'
bind -m emacs-standard -x '"\C-f\C-o": "fzf::cmd_opts"'

# CTRL-F CTRL-R: Search through all archived history files
bind -m emacs-standard -x '"\C-f\C-r": "fzf::prehistory"'

# CTRL-F CTRL-X: Experimental
# bind -x '"\C-f\C-x": "fzf::_expt"'

# Version-control related bindings: CTRL-F CTRL-G
bind -m emacs-standard -x '"\C-f\C-g\C-b": "fzf::git::branches"'
bind -m emacs-standard -x '"\C-f\C-g\C-d": "fzf::git::diffs"'
bind -m emacs-standard -x '"\C-f\C-g\C-e": "fzf::vcs::files"'
bind -m emacs-standard -x '"\C-f\C-g\C-f": "fzf::vcs::all_files"'
# bind    '"\C-f\C-g\C-g": " \C-e\C-u`fzf::vcs::cd`\e\C-e\er\C-m"'
bind -m emacs-standard -x '"\C-f\C-g\C-k": "fzf::vcs::commits"'
bind -m emacs-standard -x '"\C-f\C-g\C-l": "fzf::vcs::filelog"'
bind -m emacs-standard -x '"\C-f\C-g\C-r": "fzf::git::remotes"'
bind -m emacs-standard -x '"\C-f\C-g\C-s": "fzf::vcs::status"'
bind -m emacs-standard -x '"\C-f\C-g\C-t": "fzf::git::tags"'

bind -m emacs-standard '"\er": redraw-current-line'

# CTRL-F ALT-/: Repeat last command and pipe result to FZF
# From http://brettterpstra.com/2015/07/09/shell-tricks-inputrc-binding-fun/
bind -m emacs-standard -x '"\C-f\e/": "!! | fzf -m\C-m\C-m"'
