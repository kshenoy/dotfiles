#!/usr/bin/env bash
# Info on bind usage: https://stackoverflow.com/a/47878915/734153
# bind -X : List all key sequences bound to shell commands (using -x)
#      -S : Display readline key sequences bound to macros and the strings they output

#=======================================================================================================================
# FZF uses C-t and M-c bindings. However, I want to prefix all FZF bindings with C-f so I'm unbind the defaults here
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
if ((BASH_VERSINFO[0] < 4)); then
  if [[ ${FZF_CTRL_T_COMMAND-x} != "" ]]; then
    bind -m emacs-standard '"\C-f\C-f": " \C-b\C-k \C-u`__fzf_select__`\e\C-e\er\C-a\C-y\C-h\C-e\e \C-y\ey\C-x\C-x\C-f\C-y\ey\C-_"'
  fi
else
  if [[ ${FZF_CTRL_T_COMMAND-x} != "" ]]; then
    bind -m emacs-standard -x '"\C-f\C-f": fzf-file-widget'
  fi
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
# bind -x '"\C-f\C-x": "fzf::_expt"'

# Version-control related bindings: CTRL-F CTRL-G
bind -m emacs-standard -x '"\C-f\C-g\C-b": "fzf::git::branches"'
bind -m emacs-standard -x '"\C-f\C-g\C-d": "fzf::git::diffs"'
bind -m emacs-standard -x '"\C-f\C-g\C-e": "fzf::vcs::files"'
bind -m emacs-standard -x '"\C-f\C-g\C-f": "fzf::vcs::all_files"'
bind -m emacs-standard -x '"\C-f\C-g\C-k": "fzf::vcs::commits"'
bind -m emacs-standard -x '"\C-f\C-g\C-l": "fzf::vcs::filelog"'
bind -m emacs-standard -x '"\C-f\C-g\C-r": "fzf::git::remotes"'
bind -m emacs-standard -x '"\C-f\C-g\C-s": "fzf::vcs::status"'
bind -m emacs-standard -x '"\C-f\C-g\C-t": "fzf::git::tags"'

# CTRL-F ALT-/ : Repeat last command and pipe result to FZF
# From http://brettterpstra.com/2015/07/09/shell-tricks-inputrc-binding-fun/
bind -m emacs-standard -x '"\C-f\e/": "!! | fzf -m\C-m\C-m"'
