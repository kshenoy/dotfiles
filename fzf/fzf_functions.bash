#!/usr/bin/env bash

#=======================================================================================================================
fzf::_down() {                                                                                                     #
  fzf "$@" --height 50% --border
}


#=======================================================================================================================
fzf::_insert_at_cursor() {                                                                                         #
  local selected="$1"
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}


#=======================================================================================================================
# fzf::git
#=======================================================================================================================
fzf::git::diffs() {                                                                                                #
  vcs::is_in_git_repo || return
  git -c color.status=always status --short |
  fzf::_down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}


#=======================================================================================================================
fzf::git::branches() {                                                                                             #
  vcs::is_in_git_repo || return

  local _selected=$(
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf::_down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed -e 's/^..//' -e 's#^remotes/##' | cut -d' ' -f1 | paste -s -d ' ')

  fzf::_insert_at_cursor "$_selected"
}


#=======================================================================================================================
fzf::git::tags() {                                                                                                 #
  vcs::is_in_git_repo || return
  git tag --sort -version:refname |
  fzf::_down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}


#=======================================================================================================================
fzf::git::remotes() {                                                                                              #
  vcs::is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf::_down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}


#=======================================================================================================================
# fzf::p4
#=======================================================================================================================
fzf::p4::strip_common_ancestors() {                                                                                #
  for item in "$@"; do
    [[ -z "$item" ]] && continue

    if [[ "$STEM/$item" =~ "$PWD" ]]; then
      # Remove any common ancestors from filename
      item="$STEM/$item"
      item=${item##$PWD/}
      echo "$item";
    else
      echo "$STEM/$item";
    fi
  done
}

#=======================================================================================================================
fzf::p4::cd() {                                                                                                    #
  local cmd='command find $STEM -mindepth 1 \
    -type d \( -path $STEM/_env -o -path $STEM/emu -o -path $STEM/env_squash -o -path $STEM/import -o \
      -path $STEM/powerPro -o -path $STEM/sdpx \) -prune \
    -o -type d -print 2> /dev/null | sed "s:$STEM/::"'

  local dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)
  if [[ -z "$dir" ]]; then
    return
  fi

  printf '%q ' "$dir"
}

#=======================================================================================================================
fzf::p4::all_files() {                                                                                             #
  FZF_CTRL_T_COMMAND='cat \
    <(command p4 have ${STEM:+$STEM/}...) \
    <(p4 opened 2> /dev/null | command grep add | command sed "s/#.*//" | command xargs -I{} -n1 command p4 where {}) \
    | command awk "{print \$3}"' \
  fzf-file-widget
}


#=======================================================================================================================
# fzf::vcs (generic wrapper to cover all vcs types)
#=======================================================================================================================
fzf::vcs::cd() {                                                                                                   #
  if vcs::is_in_perforce_repo; then
    fzf::p4::cd
  else
    __fzf_cd__
  fi
}

#=======================================================================================================================
fzf::vcs::all_files() {                                                                                            #
  if vcs::is_in_git_repo; then
    local _top=$(git rev-parse --show-toplevel)
    local _selected=$(git ls-tree --full-tree -r --name-only HEAD |
      FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m |
      while read -r item; do
        path=${_top}/$item
        printf '%q ' "${path#$(realpath $PWD)/}"
      done
    )

    fzf::_insert_at_cursor "$_selected"
  elif vcs::is_in_perforce_repo; then
    fzf::p4::all_files
  else
    fzf-file-widget
  fi
}

#=======================================================================================================================
fzf::vcs::files() {                                                                                                #
  if vcs::is_in_git_repo; then
    FZF_CTRL_T_COMMAND='{ git ls-tree -r --name-only HEAD || \
      find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//; } 2> /dev/null' \
      fzf-file-widget
  elif vcs::is_in_perforce_repo; then
    FZF_CTRL_T_COMMAND='cat \
        <(p4 have ... | command awk "{print \$3}") \
        <(command p4 opened 2> /dev/null | command grep add | command sed "s/#.*//" | \
          command xargs -I{} -n1 command p4 where {} | command awk "{print \$3}") 2> /dev/null | \
      command sed "s:$PWD/::"' \
    fzf-file-widget
  else
    fzf-file-widget
  fi
}

#=======================================================================================================================
fzf::vcs::commits() {                                                                                              #
  if vcs::is_in_git_repo; then
    local _selected=$(git log --graph --color --all --date=short --pretty=format:' %C(yellow)%h%C(reset) %s %C(green)(%cd) %C(red)%d%C(reset)' |
    fzf::_down --ansi --no-sort --multi --bind 'ctrl-s:toggle-sort' \
      --header 'Press CTRL-S to toggle sort' \
      --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' |
      command grep -o "[a-f0-9]\{7,\}" | head -n 1)
  elif vcs::is_in_perforce_repo; then
    local _cmd=${FZF_P4_COMMITS_COMMAND-"p4 changes -m 1000 \$STEM/..."}
    local _selected=$(eval "${_cmd}" | cut -d ' ' -f2- | sed -r 's/@.*//' |
      fzf --ansi --multi --no-sort --preview 'p4 describe -s {1}' --preview-window right:70% |
      cut -d' ' -f1)
  fi

  fzf::_insert_at_cursor "$_selected"
}

#=======================================================================================================================
fzf::vcs::filelog() {                                                                                              #
  vcs::is_in_perforce_repo || return

  if [[ -n "$1" ]] && [[ $1 != -* ]] && [[ -f "$1" ]]; then
    local _file="$1"
    shift
  else
    local _file=$(cat \
      <(p4 have $STEM/... | command awk "{print \$3}") \
      <(command p4 opened 2> /dev/null | command grep add | command sed "s/#.*//" |
      command xargs -I{} -n1 command p4 where {} | command awk "{print \$3}") 2> /dev/null | command sed "s:$PWD/::" |
      fzf +m)
  fi
  [[ -z "$_file" ]] && return

  local _selected=$(p4 filelog -s "$@" $_file |
    grep '^\.\.\. *#' | sed -r 's/@\S*//' | cut -d ' ' -f 2-9 | tr -s ' ' | column -s' ' -o' ' -t |
    fzf --ansi --header='filelog for '$(basename $_file) --multi --no-sort --preview-window right:70% \
    --preview "p4 describe {3} | sed -n -e '1,/Differences .../p' -e \"/^====.*$(basename $_file)/,/^====/p\" | head -n -2" |
    cut -d' ' -f1 | while read -r item; do printf '%q ' "$_file$item"; done)

  fzf::_insert_at_cursor "$_selected"
}

#=======================================================================================================================
fzf::vcs::status() {                                                                                               #
  if vcs::is_in_git_repo; then
    local _selected=$(git -c color.status=always status --short |
      FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m --nth=2 | awk '{print $NF}' | paste -s -d ' ')
  elif vcs::is_in_perforce_repo; then
    local _selected=$(p4 opened 2> /dev/null | sed -r -e "s:^//depot/[^/]*/(trunk|branches/[^/]*)/::" |
      column -s# -o "    #" -t | column -o" " -t |
      FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m --nth=1 | awk '{print $1}' |
      while read -r item; do
        path=${STEM}/$item
        printf '%q ' "${path#$(realpath $PWD)/}"
      done
    )
  fi

  fzf::_insert_at_cursor "$_selected"
}

#=======================================================================================================================
# fzf::lsf
#=======================================================================================================================
fzf::lsf::bjobs() {                                                                                                #
  local selected=$(lsf_bjobs -o "id: user: stat: queue: submit_time: name" |
    FZF_DEFAULT_OPTS="--header-lines=1 $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" |
    cut -d' ' -f1 | while read -r item; do
      printf '%q ' "$item"
    done
  )

  fzf::_insert_at_cursor "$selected"
}


#=======================================================================================================================
# fzf::cmd_opts
#=======================================================================================================================
fzf::cmd_opts() {                                                                                                  #
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
# fzf::prehistory - Enhanced history search across all archived history files
# Usage: fzf::prehistory [months]
#   months: number of months to search (default: 6, -1 for all history)
#=======================================================================================================================
fzf::prehistory() {                                                                                                #
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
