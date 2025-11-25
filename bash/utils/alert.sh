#=======================================================================================================================
# ALERT NOTIFICATIONS
#=======================================================================================================================
# Desktop notification system for command completion

# Function: alert
# Description: Send desktop notification when a command completes
# Usage:
#   sleep 10 && alert                    # Notifies with last command
#   sleep 10 && alert "custom message"   # Notifies with custom message
unset -f alert
alert() {
    # Pick up display message if provided as argument. If not show the last command that was run
    local _msg=${1:-"'$(fc -nl -1 | sed -e 's/^\s*//' -e 's/\s*[;&|]\+\s*alert$//')' has completed"}

    # Add TMUX information if available
    if [[ -n $TMUX ]]; then
        _msg="$(tmux display-message -p "[#S:#I.#P]") $_msg"
    else
        _msg="[$$] $_msg"
    fi

    # Indicate normal completion or error
    local _icon=$( (($? == 0)) && echo terminal || echo error)

    notify-send --urgency=low -i $_icon "$_msg"
}
