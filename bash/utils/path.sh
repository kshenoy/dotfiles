#=======================================================================================================================
# PATH UTILITIES
#=======================================================================================================================
# Functions and aliases for managing and displaying PATH

# Alias: pppath
# Description: Pretty-print PATH with one entry per line
alias pppath='tr ":" "\n" <<< $PATH'

# Alias: clnpath
# Description: Clean PATH by removing duplicate entries while preserving order
alias clnpath='export PATH=$(tr ":" "\n" <<< $PATH | perl -ne "print unless \$seen{\$_}++" | paste -s -d":")'
