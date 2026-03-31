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
# fzf::git::status - Modified files picker (C-g C-s)
# Inserts: File path(s) at cursor position
#=======================================================================================================================
fzf::git::status() {
  local _selected=$(git -c color.status=always status --short |
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
    cut -c4- | sed 's/.* -> //')
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
    FZF_DEFAULT_OPTS="--header-lines=1 $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf "$@" |
    cut -d' ' -f1 | while read -r item; do
  printf '%q ' "$item"
done
)

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
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf +x "$@" | \
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
    # Restore READLINE_POINT to make it easier to launch this again
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
