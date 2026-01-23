#!/usr/bin/env bash
# Info on bind usage: https://stackoverflow.com/a/47878915/734153
# bind -X : List all key sequences bound to shell commands (using -x)
#      -S : Display readline key sequences bound to macros and the strings they output

#=======================================================================================================================
# FZF uses C-t and M-c bindings. However, I want to prefix FZF bindings with C-f so I'm unbind the defaults here
bind -m emacs-standard '"\C-t": nop'
bind -m vi-command '"\C-t": nop'
bind -m vi-insert '"\C-t": nop'
bind -m emacs-standard '"\ec": nop'
bind -m vi-command '"\ec": nop'
bind -m vi-insert '"\ec": nop'

#=======================================================================================================================
# Custom FZF key bindings
#
# CTRL-F CTRL-F instead of CTRL-T : Paste the selected file path into the command line
# (obtained directly from FZF's key-bindings.bash file and modified)
if [[ ${FZF_CTRL_T_COMMAND-x} != "" ]]; then
  bind -m emacs-standard -x '"\C-f\C-f": fzf-file-widget'
fi

# CTRL-F CTRL-J instead of ALT-C : cd into the selected directory
# (obtained directly from FZF's key-bindings.bash file and modified)
if [[ ${FZF_ALT_C_COMMAND-x} != "" ]]; then
  bind -m emacs-standard '"\C-f\C-j": " \C-b\C-k \C-u`__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d\C-y\ey\C-_"'
fi

# CTRL-F CTRL-L: Search all running LSF jobs
bind -m emacs-standard -x '"\C-f\C-l": "fzf::lsf::bjobs"'

# CTRL-F CTRL-O: Show list of options of the command before the cursor using '<cmd> -h'
bind -m emacs-standard -x '"\C-f\C-o": "fzf::cmd_opts"'

# CTRL-F CTRL-R: Search through all archived history files
bind -m emacs-standard -x '"\C-f\C-r": "fzf::prehistory"'

# CTRL-F CTRL-X: Experimental
#  'k'
# bind -x '"\C-f\C-x": "fzf::_expt"'

# Version-control related bindings: CTRL-G
# fzf-git.sh provides these git-specific bindings (sourced in fzf.bash):
#   C-g C-f / C-g f → files           C-g C-h / C-g h → hashes (commits)
#   C-g C-b / C-g b → branches        C-g C-s / C-g s → stashes
#   C-g C-t / C-g t → tags            C-g C-w / C-g w → worktrees
#   C-g C-r / C-g r → remotes         C-g C-l / C-g l → reflogs
#   C-g C-e / C-g e → each-ref        C-g ?           → help
# VCS-agnostic bindings below override fzf-git.sh defaults (git + Perforce support):
bind -m emacs-standard -x '"\C-g\C-d": "fzf::vcs::cwd_files"'
bind -m emacs-standard -x '"\C-g\C-f": "fzf::vcs::files"'
bind -m emacs-standard -x '"\C-g\C-h": "fzf::vcs::commits"'
bind -m emacs-standard -x '"\C-g\C-l": "fzf::vcs::filelog"'
bind -m emacs-standard -x '"\C-g\C-s": "fzf::vcs::status"'

# CTRL-F ALT-/ : Repeat last command and pipe result to FZF
# From http://brettterpstra.com/2015/07/09/shell-tricks-inputrc-binding-fun/
bind -m emacs-standard -x '"\C-f\e/": "!! | fzf -m\C-m\C-m"'
