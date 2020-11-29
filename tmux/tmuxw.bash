#!/usr/bin/env bash
# Function to simplify using tmux. This file must be sourced

__tmux_exe() {
    LANG=en_US.UTF-8 TMUX_DEFAULT_OPTS="$TMUX_DEFAULT_OPTS ${TMUX_DEFAULT_SOCKET:+-L $TMUX_DEFAULT_SOCKET}" command tmux "$@"
}

__tmuxw_attach_or_new() {
    # Attach to existing session or else create a new one
    if [[ ! -z "$TMUX" ]]; then return; fi

    if [[ -z "$1" ]]; then
        __tmux_exe -2 attach-session || __tmux_exe -2 new-session
    else
        # The commented one-liner doesn't work when the supplied argument is a subset of an already existing session name
        # For eg. if we have a session called DebugBus, and we check if the session "Debug" exists, tmux returns true
        #tmux -2 attach-session -t "$@" || ( echo "Creating new session..." && tmux -2 new-session -s "$@" )

        if [[ $(tm ls | grep -P "^$1\b" 2> /dev/null) ]]; then
            #echo "Attaching to exising session..."
            __tmux_exe -2 attach-session -t "$@"
        else
            echo "Creating new session $1 ..."
            __tmux_exe -2 new-session -s "$1"
        fi
    fi
}


__tmuxw_update_env() {
    # Update environment variables in TMUX
    # https://raim.codingfarm.de/blog/2013/01/30/tmux-update-environment/
    echo "Updating to latest tmux environment...";

    local _line;
    while read _line; do
        if [[ $_line == -* ]]; then
            unset ${_line/#-/}
        else
            _line=${_line/=/=\"}
            _line=${_line/%/\"}
            eval export $_line;
        fi;
    done < <(tmux show-environment)

    echo "...done"
}


__tmuxw_send_keys_other_panes() {
    local _pane_current=$(tmux display-message -p '#P')
    for _pane in $(tmux list-panes -F '#P'); do
        if (( "$_pane" != "$_pane_current" )); then
            __tmux_exe send-keys -t ${_pane} "$@"
        fi
    done
}


__tmuxw_send_keys_all_panes() {
    for _pane in $(tmux list-panes -F '#P'); do
        __tmux_exe send-keys -t ${_pane} "$@"
    done
}


__tmuxw_send_keys_all() {
    for _window in $(tmux list-windows -F '#I'); do
        for _pane in $(tmux list-panes -t ${_window} -F '#P'); do
            __tmux_exe send-keys -t ${_window}.${_pane} "$@"
        done
    done
}


__tmuxw_select_layout_work() {
    local num_panes=$(__tmux_exe display-message -p "#{window_panes}")
    local win_width=$(__tmux_exe display-message -p "#{window_width}")
    local win_width_by2=$(( $win_width / 2 ))
    local win_width_by4=$(( $win_width / 4 ))
    local win_height=$(__tmux_exe display-message -p "#{window_height}")
    local win_height_by2=$(( $win_height / 2 ))

    local curr_pane=$(__tmux_exe display-message -p "#{pane_index}")
    local curr_path=$(__tmux_exe display-message -p "#{pane_current_path}")
    for (( i = $num_panes; i < 3; i++ )); do
        __tmux_exe split-window -h -c "$curr_path"
    done

    if [[ "$1" == "work-max" ]]; then
        __tmux_exe select-layout "1be5,639x73,0,0{319x73,0,0,0,159x73,320,0,1,159x73,480,0,58}"
        tmuxw resize-pane -t 2 -x 100% > /dev/null
        tmuxw resize-pane -t 1 -x 50% > /dev/null
    elif [[ "$1" == "work-home" ]]; then
        __tmux_exe select-layout "1be5,639x73,0,0{319x73,0,0,0,159x73,320,0,1,159x73,480,0,58}"
        tmuxw resize-pane -t 1 -x 25% > /dev/null
        tmuxw resize-pane -t 2 -x 50% > /dev/null
    elif [[ "$1" == "work-pc" ]]; then
        __tmux_exe select-layout "1be5,639x73,0,0{319x73,0,0,0,159x73,320,0,1,159x73,480,0,58}"
        tmuxw resize-pane -t 1 -x 50% > /dev/null
        tmuxw resize-pane -t 2 -x 25% > /dev/null
    elif [[ "$1" == "work-lp" ]]; then
        __tmux_exe select-layout "96ed,319x66,0,0{159x66,0,0,0,159x66,160,0[159x32,160,0,1,159x33,160,33,90]}"
        tmuxw resize-pane -t 1 -x 50% > /dev/null
        tmuxw resize-pane -t 2 -y 50% > /dev/null
    fi

    __tmux_exe select-pane -t $curr_pane
}


tmuxw() {
    # We can't make the helper functions private because doing so will run tmuxw in a subshell
    # However, since we can't export variables from a subshell to its parent shell, tmux_update_env won't work
    if (( $# == 0 )); then
        __tmux_exe
        return
    fi

    local cmd=$1; shift;

    case $cmd in
        attach-new|an)
            # if (( $(__tmux_exe -V) < 2.3 )); then
            __tmuxw_attach_or_new "$@"
            # else
            # __tmux_exe new-session -A -s "$@"
            # fi
            ;;

        msg)
            __tmux_exe display-message "$@"
            ;;

        update-env|ue)
            if (( $# > 0 )); then echo "Ignoring extra arguments: '$@'"; fi
            __tmuxw_update_env
            ;;

        update-env-all-panes|ueap)
            tmuxw send-keys-all-panes "tmuxw ue" C-m
            ;;

        update-env-all|uea)
            tmuxw send-keys-all "tmuxw ue" C-m
            ;;

        resize-p*|resizep)
            # From https://github.com/tmux/tmux/issues/888#issuecomment-297637138
            if [[ "$*" =~ -[xy][[:space:]]+[[:digit:]]+% ]]; then
                local perVal=$(sed -e 's/^.*-[xy]\s*//' -e 's/%.*//' <<< "$*")
                if [[ "$*" =~ -x ]]; then
                    local absVal=$(( $(__tmux_exe display-message -p "#{window_width}") * $perVal / 100 ))
                elif [[ "$*" =~ -y ]]; then
                    local absVal=$(( $(__tmux_exe display-message -p "#{window_height}") * $perVal / 100 ))
                fi
                echo "tmux resize-pane $(sed "s/${perVal}%/${absVal}/" <<< "$*")"
                eval "__tmux_exe resize-pane $(sed "s/${perVal}%/${absVal}/" <<< "$*")"
            else
                __tmux_exe ${cmd} "$@"
            fi
            ;;

        respawn)
            # From https://github.com/tmux/tmux/issues/1036
            pkill -USR1 tmux
            ;;

        save-layout)
            eval $1=$(__tmux_exe display-message -p "#{window_layout}")
            echo "Saved current layout to $1"
            ;;

        select-layout|sl)
            if [[ "$1" =~ "work" ]]; then
                __tmuxw_select_layout_work "$1"
            else
                __tmux_exe ${cmd} "$@"
            fi
            ;;

        sk)
            __tmux_exe send-keys "$@"
            ;;

        send-keys-other-panes|skop)
            __tmuxw_send_keys_other_panes "$@"
            ;;

        send-keys-all-panes|skap)
            __tmuxw_send_keys_all_panes "$@"
            ;;

        send-keys-all|ska)
            __tmuxw_send_keys_all "$@"
            ;;

        *)
            __tmux_exe ${cmd} "$@"
    esac
}
