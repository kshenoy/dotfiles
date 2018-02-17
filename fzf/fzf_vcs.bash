#!/usr/bin/env sh

is_in_git_repo() {                                                                                                 #{{{1
  git rev-parse HEAD > /dev/null 2>&1
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


__fzf_p4_opened() {                                                                                                #{{{1
  cmd='p4 opened | sed -r -e "s/#.*$//" -e "s:^//depot/[^/]*/(trunk|branches/[^/]*)/::"'

  local selected=$(eval "$cmd" | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" fzf -m "$@" | while read -r item; do
    printf '$STEM/%q ' "$item"
  done; echo)

  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}


__fzf_p4_walist() {                                                                                                #{{{1
  local cmd=wa_list
  local dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)

  if [[ -n $dir ]]; then
    printf 'cd %q' "$dir"
  fi
}
