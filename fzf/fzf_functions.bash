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
# fzf::p4 - Perforce-specific FZF functions
#=======================================================================================================================

#-----------------------------------------------------------------------------------------------------------------------
# Select directory in Perforce workspace (excludes common build/cache directories)
# Returns: Directory path (output to stdout)
# Note: Currently unbound - planned for future use
#-----------------------------------------------------------------------------------------------------------------------
fzf::p4::cd() {
  local cmd='command find $STEM -mindepth 1 \
    -type d \( -path $STEM/_env -o -path $STEM/emu -o -path $STEM/env_squash -o -path $STEM/import -o \
    -path $STEM/powerPro -o -path $STEM/sdpx \) -prune \
    -o -type d -print 2> /dev/null | sed "s:$STEM/::"'

  local dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd))
  if [[ -z "$dir" ]]; then
    return
  fi

  printf '%q ' "$dir"
}

#=======================================================================================================================
# fzf::vcs - VCS-agnostic wrapper functions (Git and Perforce support)
#=======================================================================================================================

#-----------------------------------------------------------------------------------------------------------------------
# Select directory in VCS workspace
# Returns: Directory path (output to stdout)
# Note: Currently unbound - planned for future use
#-----------------------------------------------------------------------------------------------------------------------
fzf::vcs::cd() {
  if vcs::is_in_perforce_repo; then
    fzf::p4::cd
  else
    __fzf_cd__
  fi
}

#-----------------------------------------------------------------------------------------------------------------------
# Select files from VCS repository (all tracked files from repo root)
# Inserts: File path(s) at cursor position
#-----------------------------------------------------------------------------------------------------------------------
fzf::vcs::files() {
  if vcs::is_in_git_repo; then
    local _selected=$(_fzf_git_files)
    __fzf::insert_at_cursor "$_selected"
  elif vcs::is_in_perforce_repo; then
    FZF_CTRL_T_COMMAND='cat \
      <(command p4 have ${STEM:+$STEM/}...) \
      <(command p4 opened 2> /dev/null | command grep add | command sed "s/#.*//" | command xargs -I{} -n1 command p4 where {}) \
      | command awk "{print \$3}"' \
      fzf-file-widget
  else
    fzf-file-widget
  fi
}

#-----------------------------------------------------------------------------------------------------------------------
# Select files from VCS repository (tracked files in current directory and below)
# Calls: fzf-file-widget with custom FZF_CTRL_T_COMMAND
#-----------------------------------------------------------------------------------------------------------------------
fzf::vcs::cwd_files() {
  if vcs::is_in_git_repo; then
    local _selected=$(_fzf_git_files)
    __fzf::insert_at_cursor "$_selected"
  elif vcs::is_in_perforce_repo; then
    FZF_CTRL_T_COMMAND='cat \
      <(command p4 have ...) \
      <(command p4 opened 2> /dev/null | command grep add | command sed "s/#.*//" | command xargs -I{} -n1 command p4 where {}) \
      | command awk "{print \$3}") 2> /dev/null | command sed "s:$PWD/::"' \
      fzf-file-widget
  else
    fzf-file-widget
  fi
}

#-----------------------------------------------------------------------------------------------------------------------
# Select commits with preview
# Inserts: Commit hash at cursor position
#-----------------------------------------------------------------------------------------------------------------------
fzf::vcs::commits() {
  if vcs::is_in_git_repo; then
    local _selected=$(_fzf_git_hashes)
    __fzf::insert_at_cursor "$_selected"
  elif vcs::is_in_perforce_repo; then
    local _cmd=${FZF_P4_COMMITS_COMMAND-"p4 changes -m 1000 \$STEM/..."}
    local _selected=$(eval "${_cmd}" | cut -d ' ' -f2- | sed -r 's/@.*//' |
      fzf +1 --no-sort --preview 'p4 describe -s {1}' --preview-window right:70% |
      cut -d' ' -f1)
  fi

  __fzf::insert_at_cursor "$_selected"
}

#-----------------------------------------------------------------------------------------------------------------------
# Select file revisions from Perforce filelog with change description preview
# Usage: fzf::vcs::filelog [file] [p4-filelog-options]
# Inserts: File revision(s) at cursor position (e.g., file#1, file#2)
# Note: Perforce-only function
#-----------------------------------------------------------------------------------------------------------------------
fzf::vcs::filelog() {
  vcs::is_in_perforce_repo || return

  if [[ -n "$1" ]] && [[ $1 != -* ]] && [[ -f "$1" ]]; then
    local _file="$1"
    shift
  else
    local _file=$(cat \
      <(p4 have $STEM/... | command awk "{print \$3}") \
      <(command p4 opened 2> /dev/null | command grep add | command sed "s/#.*//" |
      command xargs -I{} -n1 command p4 where {} | command awk "{print \$3}") 2> /dev/null | command sed "s:$PWD/::" |
      fzf +1)
  fi
  [[ -z "$_file" ]] && return

  local _selected=$(p4 filelog -s "$@" $_file |
    grep '^\.\.\. *#' | sed -r 's/@\S*//' | cut -d ' ' -f 2-9 | tr -s ' ' | column -s' ' -o' ' -t |
    fzf +1 --header='filelog for '$(basename $_file) --no-sort --preview-window right:70% \
    --preview "p4 describe {3} | sed -n -e '1,/Differences .../p' -e \"/^====.*$(basename $_file)/,/^====/p\" | head -n -2" |
    cut -d' ' -f1 | while read -r item; do printf '%q ' "$_file$item"; done)

  __fzf::insert_at_cursor "$_selected"
}

#-----------------------------------------------------------------------------------------------------------------------
# Select files from VCS status (modified/opened files)
# Inserts: File path(s) at cursor position
#-----------------------------------------------------------------------------------------------------------------------
fzf::vcs::status() {
  if vcs::is_in_git_repo; then
    local _selected=$(git -c color.status=always status --short |
      FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf --nth 2..,.. \
      --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
      cut -c4- | sed 's/.* -> //')
  elif vcs::is_in_perforce_repo; then
    local _selected=$(p4 opened 2> /dev/null | sed -r -e "s:^//depot/[^/]*/(trunk|branches/[^/]*)/::" |
      column -s# -o "    #" -t | column -o" " -t |
      FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf --nth=1 | awk '{print $1}' |
      while read -r item; do
        path=${STEM}/$item
        printf '%q ' "${path#$(realpath $PWD)/}"
      done
    )
  fi

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
