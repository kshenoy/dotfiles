#!/usr/bin/env bash

is_in_git_repo() {                                                                                                 #{{{1
  git rev-parse HEAD &> /dev/null
}

is_in_perforce_repo() {                                                                                            #{{{1
  p4 info &> /dev/null
}

__fzf-p4-strip-common-ancestors() {                                                                                #{{{1
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

__fzf-down() {                                                                                                     #{{{1
  fzf --height 50% "$@" --border
}


fzf-git-diffs() {                                                                                                  #{{{1
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}


fzf-git-branches() {                                                                                               #{{{1
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  __fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}


fzf-git-tags() {                                                                                                   #{{{1
  is_in_git_repo || return
  git tag --sort -version:refname |
  __fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}


fzf-git-hashes() {                                                                                                 #{{{1
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  __fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}


fzf-git-remotes() {                                                                                                #{{{1
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  __fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}


__fzf_p4_walist__() {                                                                                              #{{{1
  FZF_ALT_C_COMMAND='wa_list' __fzf_cd__
}


__fzf-p4-cd() {                                                                                                    #{{{1
  local cmd='command find $STEM -mindepth 1 \
    -type d \( -path $STEM/_env -o -path $STEM/emu -o -path $STEM/env_squash -o -path $STEM/import -o \
      -path $STEM/powerPro -o -path $STEM/sdpx \) -prune \
    -o -type d -print 2> /dev/null | sed "s:$STEM/::"'

  local dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)
  if [[ -z "$dir" ]]; then
    return
  fi

  printf '%q ' "$dir"
}


fzf-vcs-cd() {                                                                                                     #{{{1
  if is_in_perforce_repo; then
    __fzf-p4-cd
  else
    __fzf_cd__
  fi
}


fzf-vcs-all-files() {                                                                                              #{{{1
  if is_in_git_repo; then
    FZF_CTRL_T_COMMAND='{ git ls-tree --full-tree -r --name-only HEAD || \
      find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//; } 2> /dev/null' \
      fzf-file-widget
  elif is_in_perforce_repo; then
    FZF_CTRL_T_COMMAND='cat <(command p4 have $STEM/... 2> /dev/null | command awk "{print \$3}") \
                            <(command p4 opened 2> /dev/null | command grep add | command sed "s/#.*//" | \
                              command xargs -I{} -n1 command p4 where {}) \
                            $STEM/build/latest/generated/.filelist 2> /dev/null' fzf-file-widget
  else
    fzf-file-widget
  fi
  echo
}


fzf-vcs-files() {                                                                                                  #{{{1
  if is_in_git_repo; then
    FZF_CTRL_T_COMMAND='{ git ls-tree -r --name-only HEAD || \
      find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//; } 2> /dev/null' \
      fzf-file-widget
  elif is_in_perforce_repo; then
    FZF_CTRL_T_COMMAND='{ {p4 have ... | command awk "{print \$3}" | command sed "s:$STEM/::"} || \
      find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//; } 2> /dev/null' \
      fzf-file-widget
  else
    fzf-file-widget
  fi
  echo
}


fzf-vcs-status() {                                                                                                 #{{{1
  if is_in_git_repo; then
    local _selected=$(git -c color.status=always status --short |
      fzf -m --nth=2 |
      awk '{print $NF}' |
      while read -r item; do
        printf '%q ' "$item"
      done
    )
  elif is_in_perforce_repo; then
    local _selected=$(p4 opened 2> /dev/null | sed -r -e "s:^//depot/[^/]*/(trunk|branches/[^/]*)/::" |
      column -s# -o "    #" -t | column -s- -o- -t | fzf -m --nth=1 | awk '{print $1}' |
      while read -r item; do
        printf '%q ' "$item"
      done
    )
  fi

  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$_selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#_selected} ))
}
