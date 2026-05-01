#!/usr/bin/env bash

#=======================================================================================================================
# Helper: Insert selected text at cursor position in readline buffer with smart spacing
# Usage: __fzf::insert_at_cursor "text to insert"
# Adds spaces before/after if needed based on context and selected text
#=======================================================================================================================
__fzf::insert_at_cursor() {
  local selected="$1"
  [[ -z "$selected" ]] && return

  local char_before="${READLINE_LINE:$((READLINE_POINT-1)):1}"
  local char_after="${READLINE_LINE:$READLINE_POINT:1}"

  # Add space before if:
  # - cursor is not at start AND
  # - previous char is not whitespace AND
  # - selected text doesn't start with space
  if [[ $READLINE_POINT -gt 0 ]] && [[ "$char_before" != " " ]] && [[ "$selected" != " "* ]]; then
    selected=" $selected"
  fi

  # Add space after if:
  # - cursor is not at end AND
  # - next char is not whitespace AND
  # - selected text doesn't end with space
  if [[ $READLINE_POINT -lt ${#READLINE_LINE} ]] && [[ "$char_after" != " " ]] && [[ "$selected" != *" " ]]; then
    selected="$selected "
  fi

  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}

#=======================================================================================================================
# Override fzf-git.sh's function
#=======================================================================================================================
_fzf_git_fzf() {
  local fzf_args=(
    --height 75%
    --layout reverse --multi --min-height 20+ --border
    --no-separator --header-border horizontal
    --border-label-pos 2 --color 'label:blue'
    --preview-window 'right,50%' --preview-border line
    --bind 'ctrl-/:change-preview-window(down,50%|hidden|)'
  )
  if [[ -n "$TMUX" ]]; then
    local pw=$(( $(tmux display-message -p '#{pane_width}') * 9 / 10 ))
    local ph=$(( $(tmux display-message -p '#{pane_height}') * 9 / 10 ))
    fzf --tmux "center,${pw},${ph}" "${fzf_args[@]}" "$@"
  else
    fzf "${fzf_args[@]}" "$@"
  fi
}

#=======================================================================================================================
# fzf::cd::parent - Jump to a parent directory (Alt+Shift+C)
# Shows all ancestor dirs (excl. PWD and /); matches on last component only
#=======================================================================================================================
fzf::cd::parent() {
  local d=$PWD parents=() dir
  while true; do
    d="${d%/*}"
    [[ -z "$d" || "$d" == "/" ]] && break
    parents+=("$d")
  done
  [[ ${#parents[@]} -eq 0 ]] && return
  dir=$(printf '%s\n' "${parents[@]}" | fzf --delimiter / --nth -1 --no-multi)
  [[ -n "$dir" ]] && cd "$dir"
}

#=======================================================================================================================
# fzf::git::status - Modified files picker (C-g C-s)
# Inserts: File path(s) at cursor position
#=======================================================================================================================
fzf::git::status() {
  local _selected=$(git -c color.status=always status --short |
    fzf --nth 2.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
    cut -c4- | sed 's/.* -> //' | while read -r item; do printf '%q ' "$item"; done)
  __fzf::insert_at_cursor "$_selected"
}

#=======================================================================================================================
# fzf::lsf - LSF (Load Sharing Facility) job management functions
#=======================================================================================================================

#-----------------------------------------------------------------------------------------------------------------------
# Select LSF jobs with interactive preview
# Inserts: Job ID(s) at cursor position
#-----------------------------------------------------------------------------------------------------------------------
fzf::lsf::bjobs() {
  local selected=$(lsf_bjobs -o "id: user: stat: queue: submit_time: name" |
    fzf --header-lines=1 "$@" |
    cut -d' ' -f1 | while read -r item; do
      printf '%q ' "$item"
    done)

  __fzf::insert_at_cursor "$selected"
}


#=======================================================================================================================
# fzf::cmd_opts - Parse and select command-line options from help output
#=======================================================================================================================

#-----------------------------------------------------------------------------------------------------------------------
# Extract and select command options from help output of command before cursor
# Inserts: Selected option(s) at cursor position
# Smart positioning: Handles spacing around cursor automatically
#-----------------------------------------------------------------------------------------------------------------------
fzf::cmd_opts() {
  # echo "DEBUG: '${READLINE_LINE}' Point=${READLINE_POINT}, Char='${READLINE_LINE:$READLINE_POINT:1}'"
  local saved_point=$READLINE_POINT

  # If cursor is on a non-whitespace char, move to end of current word
  if [[ "${READLINE_LINE:$READLINE_POINT}" =~ ^[^\ ]+ ]]; then
    READLINE_POINT=$(( READLINE_POINT + ${#BASH_REMATCH[0]} ))
  fi
  local cmd=$(awk '{print $NF}' <<< "${READLINE_LINE:0:$READLINE_POINT}")

  local selected=$(eval "${cmd} --help || ${cmd} -h || ${cmd} -help || ${cmd} help" | \
    fzf +x "$@" | \
    while read -r item; do
      # Extract first option flag (word starting with -)
      for word in $item; do
        if [[ "$word" == -* ]]; then
          # Remove trailing comma or = and everything after
          printf '%q ' "${word%%[,=]*}"
          break
        fi
      done
    done)

  __fzf::insert_at_cursor "$selected"
  READLINE_POINT=$saved_point
}


#=======================================================================================================================
# fzf::prehistory - Enhanced history search across all archived history files
# Usage: fzf::prehistory [months]
#   months: number of months to search (default: 6, -1 for all history)
#=======================================================================================================================
fzf::prehistory() {
  local output
  local months="${1:-6}"  # Default to 6 months if no argument provided

  # Search through all archived history files in the bash_history directory
  local hist_dir="${HOME}/.local/share/bash_history"

  # Set up the date filter for find command
  local find_opts=(-type f)
  if [[ "$months" -ne -1 ]]; then
    local cutoff_date=$(date -d "$months months ago" +%s 2>/dev/null || date -v-${months}m +%s 2>/dev/null)
    find_opts+=(-newermt "@$cutoff_date")
  fi

  output=$(
    if [[ -d "$hist_dir" ]]; then
      find "$hist_dir" "${find_opts[@]}" -exec cat {} + 2>/dev/null | \
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
