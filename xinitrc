#!/usr/bin/env bash
#
# I'm primarily using this file to set xkb options. Maybe this is not the right filename for it according to:
# https://askubuntu.com/questions/876005/what-file-is-the-setxkbmap-option-rules-meant-to-take-and-how-can-i-add-keyboa

# Capslock →  Ctrl+Escape
# CapsLock acts like an additional Control. Tap both Shift to generate CapsLock
setxkbmap -option 'ctrl:nocaps' -option 'shift:both_capslock'

# The following allows not just CapsLock but all Controls to generate an Escape when pressed by itself
if [[ -z $(ps aux | grep "[x]cape") ]]; then
  command -v xcape > /dev/null 2>&1 && xcape -t 300 -e 'Control_L=Escape' &
fi


#xset -b            # Stop beeping at me (A.K.A turn off PC speaker)
#xset r rate 330 60 # Set keyboard repeat rate
