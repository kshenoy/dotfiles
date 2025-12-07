# tmux++
# Wrapper around tmux to add more functionality. This file must be sourced

#!/usr/bin/env bash

# Wrapper around the tmux command
tmux::exe() {
    LANG=en_US.UTF-8 TMUX_DEFAULT_OPTS="$TMUX_DEFAULT_OPTS ${TMUX_DEFAULT_SOCKET:+-L $TMUX_DEFAULT_SOCKET}" command tmux "$@"
}

# Attach to existing session or else create a new one
tmux::attach_or_new() {
    if [[ ! -z "$TMUX" ]]; then return; fi

    if [[ -z "$1" ]]; then
        tmux::exe -2 attach-session || tmux::exe -2 new-session
    else
        # This doesn't work when the supplied argument is a subset of an already existing session name
        # For eg. if we have a session called DebugBus, and we check if the session "Debug" exists, tmux returns true
        # tmux -2 attach-session -t "$@" || ( echo "Creating new session..." && tmux -2 new-session -s "$@" )

        if [[ $(tm ls | grep -P "^$1\b" 2> /dev/null) ]]; then
            #echo "Attaching to exising session..."
            tmux::exe -2 attach-session -t "$@"
        else
            echo "Creating new session $1 ..."
            tmux::exe -2 new-session -s "$1"
        fi
    fi
}

# Helper functions to simplify sending keys
tmux::send_keys_other_panes() {
    local _pane_current=$(tmux display-message -p '#P')
    for _pane in $(tmux list-panes -F '#P'); do
        if (( "$_pane" != "$_pane_current" )); then
            tmux::exe send-keys -t ${_pane} "$@"
        fi
    done
}

tmux::send_keys_all_panes() {
    for _pane in $(tmux list-panes -F '#P'); do
        tmux::exe send-keys -t ${_pane} "$@"
    done
}


# Custom layout for work
tmux::_select_layout_work() {
    local num_panes=$(tmux::exe display-message -p "#{window_panes}")
    local curr_pane=$(tmux::exe display-message -p "#{pane_index}")
    local curr_path=$(tmux::exe display-message -p "#{pane_current_path}")
    for (( i = $num_panes; i < 3; i++ )); do
        tmux::exe split-window -h -c "$curr_path"
    done

    if [[ "$1" == "work-pc" ]]; then
        tmux::exe select-layout "9ea6,548x57,0,0{137x57,0,0,70,272x57,138,0,77,137x57,411,0,17}"
        tmuxw resize-pane -t 1 -x 25% > /dev/null
        tmuxw resize-pane -t 2 -x 50% > /dev/null
        tmuxw resize-pane -t 3 -x 25% > /dev/null
    elif [[ "$1" == "work-lp" ]]; then
        tmux::exe select-layout "96ed,319x66,0,0{159x66,0,0,0,159x66,160,0[159x32,160,0,1,159x33,160,33,90]}"
        tmuxw resize-pane -t 1 -x 50% > /dev/null
        tmuxw resize-pane -t 2 -y 50% > /dev/null
    fi

    tmux::exe select-pane -t $curr_pane
}

# Helper function to name a pane
tmux::_rename_pane() {
    local _name
    if [[ -n "$1" ]]; then
        _name="$1"
    else
        read -p "Enter Pane Name: " _name;
    fi
    printf "\033]2;%s\033\\r:r" "${_name}";

    if [[ $(tmux display-message -p "#{pane-border-status}") == "off" ]]; then
        tmux setw -g pane-border-status top
    fi
}

# Top-level wrapper function
tmuxw() {
    if (( $# == 0 )); then
        tmux::exe
        return
    fi

    local cmd=$1; shift;

    case $cmd in
        attach-new|an)
            tmux::attach_or_new "$@"
            ;;

        resize-p*|resizep)
            # From https://github.com/tmux/tmux/issues/888#issuecomment-297637138
            if [[ "$*" =~ -[xy][[:space:]]+[[:digit:]]+% ]]; then
                local perVal=$(sed -e 's/^.*-[xy]\s*//' -e 's/%.*//' <<< "$*")
                if [[ "$*" =~ -x ]]; then
                    local absVal=$(( $(tmux::exe display-message -p "#{window_width}") * $perVal / 100 ))
                elif [[ "$*" =~ -y ]]; then
                    local absVal=$(( $(tmux::exe display-message -p "#{window_height}") * $perVal / 100 ))
                fi
                echo "tmux resize-pane $(sed "s/${perVal}%/${absVal}/" <<< "$*")"
                eval "tmux::exe resize-pane $(sed "s/${perVal}%/${absVal}/" <<< "$*")"
            else
                tmux::exe ${cmd} "$@"
            fi
            ;;

        rename-pane)
            tmux::_rename_pane "$@"
            ;;

        respawn)
            # From https://github.com/tmux/tmux/issues/1036
            pkill -USR1 tmux
            ;;

        print-layout)
            tmux::exe display-message -p "#{window_layout}"
            ;;

        select-layout|sl)
            if [[ "$1" =~ "work" ]]; then
                tmux::_select_layout_work "$1"
            else
                tmux::exe "${cmd}" "$@"
            fi
            ;;

        send-keys-all-panes|skap)
            tmux::send_keys_all_panes "$@"
            ;;

        send-keys-other-panes|skop)
            tmux::send_keys_other_panes "$@"
            ;;

        sk)
            tmux::exe send-keys "$@"
            ;;

        *)
            tmux::exe ${cmd} "$@"
    esac
}
