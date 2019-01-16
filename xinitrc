#!/usr/bin/env bash
#
# ~/.xinitrc
#
# Check if command exists
has() {
  command -v "$1" > /dev/null 2>&1
}

# Keyboard stuff
# * Capslock → Ctrl+Escape
# This doesn't work inside NX for some reason
# setxkbmap -option 'caps:ctrl_modifier'
# if [[ -z $(ps aux | grep "[x]cape") ]]; then
#   has xcape && xcape -t 300 -e 'Caps_Lock=Escape' &
# fi

# NOTE: The following allows not just CapsLock but all Controls to generate an Escape when tapped
# However, it works well with NX
setxkbmap -option 'ctrl:nocaps'
if [[ -z $(ps aux | grep "[x]cape") ]]; then
  has xcape && xcape -t 300 -e 'Control_L=Escape' &
fi

# * Tap both Shift to generate CapsLock
# With CapsLock neutered, I figure I should have a backup just in case...
setxkbmap -option 'shift:both_capslock'

#xset -b            # Stop beeping at me (A.K.A turn off PC speaker)
#xset r rate 330 60 # Set keyboard repeat rate
