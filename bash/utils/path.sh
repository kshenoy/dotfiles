#=======================================================================================================================
# PATH UTILITIES
#=======================================================================================================================
# Functions and aliases for managing and displaying PATH

# Pretty-print PATH with one entry per line
pppath() {
  tr ":" "\n" <<<"${1:-$PATH}"
}

# Clean PATH by removing duplicate entries while preserving order
clnpath() {
  export PATH=$(pppath "${1:-$PATH}" | perl -ne "print unless \$seen{\$_}++" | paste -s -d":")
}
