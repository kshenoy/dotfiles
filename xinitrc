#!/usr/bin/env bash
#
# I'm primarily using this file to set xkb options. Maybe this is not the right filename for it according to:
# https://askubuntu.com/questions/876005/what-file-is-the-setxkbmap-option-rules-meant-to-take-and-how-can-i-add-keyboa

# Check if command exists
has() {
  command -v "$1" > /dev/null 2>&1
}

# Capslock → Ctrl+Escape
# This doesn't work inside NX for some reason
# setxkbmap -option 'caps:ctrl_modifier'
# if [[ -z $(ps aux | grep "[x]cape") ]]; then
#   has xcape && xcape -t 300 -e 'Caps_Lock=Escape' &
# fi

# NOTE: The following allows not just CapsLock but all Controls to generate an Escape when tapped.
# However, it works well with NX so I'm sticking with this
setxkbmap -option 'ctrl:nocaps'
if [[ -z $(ps aux | grep "[x]cape") ]]; then
  has xcape && xcape -t 300 -e 'Control_L=Escape' &
fi

# Tap both Shift to generate CapsLock
# With CapsLock neutered, I figure I should have a backup just in case...
setxkbmap -option 'shift:both_capslock'

#xset -b            # Stop beeping at me (A.K.A turn off PC speaker)
#xset r rate 330 60 # Set keyboard repeat rate
