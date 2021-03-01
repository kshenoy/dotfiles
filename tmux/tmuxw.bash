# tmux++
# :PROPERTIES:
# :header-args+: :tangle tmuxw.bash
# :END:

# Wrapper around tmux to add more functionality. This file must be sourced

# [[file:~/.config/dotfiles/tmux/tmux.org::*tmux++][tmux++:1]]
#!/usr/bin/env bash
# tmux++:1 ends here



# Wrapper around the tmux command

# [[file:~/.config/dotfiles/tmux/tmux.org::*tmux++][tmux++:2]]
tmux::exe() {
    LANG=en_US.UTF-8 TMUX_DEFAULT_OPTS="$TMUX_DEFAULT_OPTS ${TMUX_DEFAULT_SOCKET:+-L $TMUX_DEFAULT_SOCKET}" command tmux "$@"
}
# tmux++:2 ends here



# Attach to existing session or else create a new one

# [[file:~/.config/dotfiles/tmux/tmux.org::*tmux++][tmux++:3]]
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
# tmux++:3 ends here




# Update environment variables in TMUX. From https://raim.codingfarm.de/blog/2013/01/30/tmux-update-environment/

# [[file:~/.config/dotfiles/tmux/tmux.org::*tmux++][tmux++:4]]
tmux::update_env() {
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
# tmux++:4 ends here



# Helper functions to simplify sending keys

# [[file:~/.config/dotfiles/tmux/tmux.org::*tmux++][tmux++:5]]
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

tmux::send_keys_all() {
    for _window in $(tmux list-windows -F '#I'); do
        for _pane in $(tmux list-panes -t ${_window} -F '#P'); do
            tmux::exe send-keys -t ${_window}.${_pane} "$@"
        done
    done
}
# tmux++:5 ends here



# Custom layout for work

# [[file:~/.config/dotfiles/tmux/tmux.org::*tmux++][tmux++:6]]
tmux::_select_layout_work() {
    local num_panes=$(tmux::exe display-message -p "#{window_panes}")
    local win_width=$(tmux::exe display-message -p "#{window_width}")
    local win_width_by2=$(( $win_width / 2 ))
    local win_width_by4=$(( $win_width / 4 ))
    local win_height=$(tmux::exe display-message -p "#{window_height}")
    local win_height_by2=$(( $win_height / 2 ))

    local curr_pane=$(tmux::exe display-message -p "#{pane_index}")
    local curr_path=$(tmux::exe display-message -p "#{pane_current_path}")
    for (( i = $num_panes; i < 3; i++ )); do
        tmux::exe split-window -h -c "$curr_path"
    done

    if [[ "$1" == "work-max" ]]; then
        tmux::exe select-layout "1be5,639x73,0,0{319x73,0,0,0,159x73,320,0,1,159x73,480,0,58}"
        tmuxw resize-pane -t 2 -x 100% > /dev/null
        tmuxw resize-pane -t 1 -x 50% > /dev/null
    elif [[ "$1" == "work-home" ]]; then
        tmux::exe select-layout "1be5,639x73,0,0{319x73,0,0,0,159x73,320,0,1,159x73,480,0,58}"
        tmuxw resize-pane -t 1 -x 25% > /dev/null
        tmuxw resize-pane -t 2 -x 50% > /dev/null
    elif [[ "$1" == "work-pc" ]]; then
        tmux::exe select-layout "1be5,639x73,0,0{319x73,0,0,0,159x73,320,0,1,159x73,480,0,58}"
        tmuxw resize-pane -t 1 -x 50% > /dev/null
        tmuxw resize-pane -t 2 -x 25% > /dev/null
    elif [[ "$1" == "work-lp" ]]; then
        tmux::exe select-layout "96ed,319x66,0,0{159x66,0,0,0,159x66,160,0[159x32,160,0,1,159x33,160,33,90]}"
        tmuxw resize-pane -t 1 -x 50% > /dev/null
        tmuxw resize-pane -t 2 -y 50% > /dev/null
    fi

    tmux::exe select-pane -t $curr_pane
}
# tmux++:6 ends here



# Top-level wrapper function

# [[file:~/.config/dotfiles/tmux/tmux.org::*tmux++][tmux++:7]]
tmuxw() {
    if (( $# == 0 )); then
        tmux::exe
        return
    fi

    local cmd=$1; shift;

    case $cmd in
        attach-new|an)
            # if (( $(tmux::exe -V) < 2.3 )); then
            tmux::attach_or_new "$@"
            # else
            # tmux::exe new-session -A -s "$@"
            # fi
            ;;

        msg)
            tmux::exe display-message "$@"
            ;;

        update-env|ue)
            if (( $# > 0 )); then echo "Ignoring extra arguments: '$@'"; fi
            tmux::update_env
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

        respawn)
            # From https://github.com/tmux/tmux/issues/1036
            pkill -USR1 tmux
            ;;

        save-layout)
            eval $1=$(tmux::exe display-message -p "#{window_layout}")
            echo "Saved current layout to $1"
            ;;

        select-layout|sl)
            if [[ "$1" =~ "work" ]]; then
                tmux::_select_layout_work "$1"
            else
                tmux::exe "${cmd}" "$@"
            fi
            ;;

        save-session)
            ${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tmux-resurrect/scripts/save.sh
            ;;

        restore-session)
            ${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tmux-resurrect/scripts/restore.sh
            ;;

        sk)
            tmux::exe send-keys "$@"
            ;;

        send-keys-other-panes|skop)
            tmux::send_keys_other_panes "$@"
            ;;

        send-keys-all-panes|skap)
            tmux::send_keys_all_panes "$@"
            ;;

        send-keys-all|ska)
            tmux::send_keys_all "$@"
            ;;

        *)
            tmux::exe ${cmd} "$@"
    esac
}
# tmux++:7 ends here
