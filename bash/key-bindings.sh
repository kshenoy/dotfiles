#!/usr/bin/env bash
echo "$(tput setaf 2)Sourcing$(tput sgr0) ${BASH_SOURCE[0]} ..."

bind -m emacs-standard -x '"\C-g\C-g\C-s": "git st"'
bind -m emacs-standard -x '"\C-g\C-g\C-l": "git lg"'
