#=======================================================================================================================
# COMMAND COMPLETION
#=======================================================================================================================
# Tab completion configuration for bash

# Load system bash completion
if [[ -f /etc/bash_completion ]] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#=======================================================================================================================
# System Completions
#=======================================================================================================================
complete -A hostname   rsh rcp telnet rlogin r ftp ping disk
complete -A export     printenv
complete -A variable   export local readonly unset
complete -A enabled    builtin
complete -A alias      alias unalias
complete -A function   function
complete -A user       su mail finger

complete -A helptopic  help     # currently same as builtins
complete -A shopt      shopt
complete -A stopped -P '%' bg
complete -A job -P '%' fg jobs disown

complete -A directory  mkdir rmdir
complete -A directory  -o default cd

#=======================================================================================================================
# File Type Completions
#=======================================================================================================================

# Compression
complete -f -o default -X '*.+(zip|ZIP)'  zip
complete -f -o default -X '!*.+(zip|ZIP)' unzip
complete -f -o default -X '*.+(z|Z)'      compress
complete -f -o default -X '!*.+(z|Z)'     uncompress
complete -f -o default -X '*.+(gz|GZ)'    gzip
complete -f -o default -X '!*.+(gz|GZ)'   gunzip
complete -f -o default -X '*.+(bz2|BZ2)'  bzip2
complete -f -o default -X '!*.+(bz2|BZ2)' bunzip2

# Misc filetypes
complete -f -o default -X '!*.ps'  gs ghostview ps2pdf ps2ascii
complete -f -o default -X '!*.dvi' dvips dvipdf xdvi dviselect dvitype
complete -f -o default -X '!*.pdf' acroread pdf2ps
complete -f -o default -X '!*.+(pdf|ps)' gv
complete -f -o default -X '!*.texi*' makeinfo texi2dvi texi2html texi2pdf
complete -f -o default -X '!*.tex' tex latex slitex
complete -f -o default -X '!*.lyx' lyx
complete -f -o default -X '!*.+(htm*|HTM*)' lynx html2ps
complete -f -o default -X '!*.pl'  perl perl5
complete -f -o default -X '!*.gv'   dot
complete -f -o default -X '!*.gif'  kview

#=======================================================================================================================
# FZF Completion
#=======================================================================================================================
# Rest of fzf configuration defined in EXTERNAL TOOL INTEGRATIONS section of bashrc
[[ $- == *i* ]] && source "$FZF_PATH/shell/completion.bash" 2> /dev/null

#=======================================================================================================================
# Alias Completion
#=======================================================================================================================
# Automatically add completion for all aliases to commands having completion functions
# This must be called only at the very end

_compl_alias() {
    [[ -z "$1" ]] && return
    local _alias="$1"

    if (( $# >= 2 )); then
        local _cmd="$2"
    else
        local _cmd="$(alias $_alias 2> /dev/null | sed -e 's/^.*=//' -e 's/ .*$//' | tr -d "'")"
    fi
    [[ -z "$_cmd" ]] && return

    eval "$(complete -p $_cmd | sed "s/$_cmd$/$_alias/")"
}

# Note the order of application is important
_compl_alias e    emacs
_compl_alias g    grep
_compl_alias v    nvim
_compl_alias vd   diff
_compl_alias vile less
_compl_alias C    cat
_compl_alias bat  cat
for _alias in P gi gv l la ll lla doomacs; do
    _compl_alias "$_alias"
done
