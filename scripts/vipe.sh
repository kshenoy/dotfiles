#!/usr/bin/env bash

########################################################################################################################
# Credits:
#   reddit.com/u/Neitanod
#       (https://www.reddit.com/r/vim/comments/3oo156/whats_your_best_vim_related_shell_script)
#   reddit.com/u/ParadigmComplex
#       (https://www.reddit.com/r/vim/comments/4nwj64/is_there_a_mix_between_vim_and_something_like_sed/d47ymtw)
#
# Provides a way to put the editor in the middle of a pipe
#   eg. firstcommand | vipe | othercommand
# Thus, the output from firstcommand serves as input for othercommand, but also allows edits in the middle
#
# Any arguments provided to vipe are used as ex commands in batch mode. This will not run vim.
#   eg. firstcommand | vipe normal dd | othercommand
#
# If no arguments are provided to vipe, it opens up vim to allow manual edits.
########################################################################################################################

# vipe should be invoked as the output of a pipe only
if [[ -t 0 ]]; then
  exit
fi

# If vipe doesn't have any arguments, open an interactive session
# If any arguments are passed to it, consider them as ex-mode batch commands
if [[ $# -eq "0" ]]; then
  vimtmp="${TMPDIR:-/tmp}/vipe_$$"

  ## Dump the stdin to file
  cat > ${vimtmp}

  ## Edit the file
  ## Since this script is used in the middle of a pipe, its input and output channels do not come from the terminal.
  ## This can be checked by uncommenting the following lines:
  #if [[ -t 0 ]]; then echo "stdin is not from terminal"; fi
  #if [[ -t 1 ]]; then echo "stdout is not to terminal"; fi
  #if [[ -t 2 ]]; then echo "stderr is not to terminal"; fi

  ## http://superuser.com/a/336020/99982
  ## Vim expects its stdin to be the same as its controlling terminal, and performs various terminal-related ioctl's on
  ## stdin directly. When done on any non-tty file descriptor, those ioctls are meaningless and return ENOTTY, which gets
  ## silently ignored. On startup Vim reads and remembers the old terminal settings, and restores them back when exiting.
  ## Thus, when the "old settings" are requested for a non-tty fd (file descriptor), Vim receives all values empty and all
  ## options disabled, and carelessly sets the same to the terminal.
  ## This can be seen by running vim < /dev/null, exiting it, then running stty, which will output a whole lot of <undef>s.
  ##
  ## This could be considered as a bug in vim, since it can open /dev/tty for terminal control, but doesn't.

  ## Thus, to make vim interactive again, we need to explicitly connect its input and output to the terminal
  vim --config NONE ${vimtmp} < /dev/tty > /dev/tty
  # /usr/local/bin/vim -N -u NORC -U NORC --cmd 'set rtp=$VIM,$VIMRUNTIME,$VIM/after' ${vimtmp} < /dev/tty > /dev/tty

  ## Dump the modified file to stdout
  command cat ${vimtmp}

  ## Clean-up
  command rm ${vimtmp}

else
  # Run vim in batch mode and execute the given arguments as ex commands
  # Example usage:
  # printf "foo\nbar\n" | vipe d
  # -> bar
  # printf "foo\nbar\n" | vipe 'norm yyp'
  # -> foo
  #    foo
  #    bar
  # vim --config NONE - -es '+1' "+$*" '+%print' '+:qa!' | tail -n +2
  /usr/local/bin/vim - -N -u NORC -U NORC --cmd 'set rtp=$VIM,$VIMRUNTIME,$VIM/after' -es '+1' "+$*" '+%print' '+:qa!' | tail -n +2
fi
