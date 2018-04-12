#!/usr/bin/env sh

is_in_git_repo() {                                                                                                 #{{{1
  git rev-parse HEAD &> /dev/null
}
is_in_perforce_repo() {                                                                                            #{{{1
  p4 info &> /dev/null
}


fzf-down() {                                                                                                       #{{{1
  fzf --height 50% "$@" --border
}


fzf-git-diffs() {                                                                                                  #{{{1
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}


fzf-git-branches() {                                                                                               #{{{1
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}


fzf-git-tags() {                                                                                                   #{{{1
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}


fzf-git-hashes() {                                                                                                 #{{{1
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}


fzf-git-remotes() {                                                                                                #{{{1
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}


fzf-p4-opened() {                                                                                                  #{{{1
  FZF_CTRL_T_COMMAND='p4 opened | sed -r -e "s/#.*$//" -e "s:^//depot/[^/]*/(trunk|branches/[^/]*)/::"' fzf-file-widget
}


__fzf_p4_walist__() {                                                                                              #{{{1
  FZF_ALT_C_COMMAND='wa_list' __fzf_cd__
}


__fzf_vcs_cd__() {                                                                                                 #{{{1
  if is_in_perforce_repo; then
    local cmd='command find $STEM -mindepth 1 \
      -type d \( -path $STEM/_env -o -path $STEM/emu -o -path $STEM/env_squash -o -path $STEM/import -o \
        -path $STEM/powerPro -o -path $STEM/sdpx \) -prune \
      -o -type d -print 2> /dev/null | sed "s:$STEM/::"'

    local dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)

    if [[ -n "$dir" ]]; then
      printf 'cd $STEM/%q' "$dir"
    fi
  else
    __fzf_cd__
  fi
}


fzf-vcs-files() {                                                                                                  #{{{1
  if is_in_git_repo; then
    FZF_CTRL_T_COMMAND='{ git ls-tree -r --name-only HEAD || \
      find . -path "*/\.*" -prune -o -type f -print -o -type l -print | sed s/^..//; } 2> /dev/null' \
      fzf-file-widget

  elif is_in_perforce_repo; then
    local cmd='cat \
      <(cd $STEM; p4 have ... | command grep -v "$STEM/\(emu\|_env\|env_squash\|fp\|tools\|powerPro\|sdpx\|ch/verif/dft\|ch/verif/txn/old_yml_DO_NOT_USE\|ch/syn\)") \
      <(cd $STEM; p4 opened 2> /dev/null | command grep add | command sed "s/#.*//" | command xargs -I{} -n1 p4 where {}) \
      <(cd $STEM/import/avf; p4 have ... | command grep -v "$STEM/import/avf/\(_env\)") \
      | command awk "{print \$3}" | command sed "s:$STEM/::"'

    local selected=$(eval "$cmd" |
      FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" |
      while read -r item; do
        if [[ -n $item ]]; then
          printf '$STEM/%q ' "$item";
        fi;
      done
    )

    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
  else
    fzf-file-widget
  fi
  echo
}
