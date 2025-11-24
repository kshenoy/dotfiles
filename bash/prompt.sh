#========================================================================================================================
# PROMPT & HISTORY RUNTIME CONFIGURATION
#========================================================================================================================
# Dynamic prompt and history management executed during shell runtime

#========================================================================================================================
# Prompt Command Setup
#========================================================================================================================
# 'PROMPT_COMMAND' is evaluated right before the prompt is displayed. I use it to update history more regularly
PROMPT_COMMAND=__setprompt

__setprompt() {
  # Set HISTFILE here to keep it current when sessions span multiple days
  # FIXME: Find a better way to do this i.e. do it once a day instead of everytime the prompt is refreshed
  HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/bash_history/$(date +%Y/%m/%d)_${HOSTNAME%%.*}_${USER}_$$"
  [[ -d $(dirname ${HISTFILE}) ]] || mkdir -p $(dirname ${HISTFILE})

  # Write to the history file immediately instead of waiting till the end of the session
  history -a
}

# Use the starship prompt
eval "$(starship init bash)"

#========================================================================================================================
# Shell Exit Handlers
#========================================================================================================================

# Update permissions of the history when exiting as root
__histfile_perm_update__() {
    if [[ -f $HISTFILE ]]; then
        echo "Changing permissions of HISTFILE..."
        chown kshenoy $HISTFILE
        chgrp kshenoy $HISTFILE
        chmod 640 $HISTFILE
    fi
}
trap __histfile_perm_update__ EXIT

# When leaving the console, clear the screen to increase privacy
if [[ "$SHLVL" = 1 ]]; then
    [[ -x /usr/bin/clear_console ]] && /usr/bin/clear_console -q
fi
