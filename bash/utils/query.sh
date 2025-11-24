#========================================================================================================================
# query - Enhanced command introspection tool
#========================================================================================================================
# Description: which on steroids. Shows aliases and function definitions recursively.
# Since this function deals with aliases, it cannot be made into a stand-alone script
# since aliases are not accessible inside subshells.
#
# Usage:
#   query [OPTIONS] COMMAND...
#   que COMMAND      # Short alias
#
# Options:
#   -h, --help           Print help
#   --ascii              Use ASCII instead of extended characters
#   --color/--nocolor    Enable/disable colorized output
#   -d, --max-depth N    Recurse only N-levels deep (0 = no recursion)
#   --nodefine           Don't print function definitions

query() (
# Yep, parentheses is correct. It makes this a subshell function allowing the definition to be inaccessible from outside
# Thus, no more polluting of shell space with helper functions

__help() {                                                                                                    # {{{1
  echo "Usage:"
  echo "    query [OPTION]... INPUT..."
  echo
  echo "INPUT can be one or more alias, file, command, function etc. but must be specified last"
  echo
  echo "Options:"
  echo "    -h, --help             Print this help"
  echo "        --ascii            Use ASCII instead of extended characters"
  echo "        --color            Colorize output"
  echo "        --nocolor          Don't colorize output"
  echo "    -d, --max-depth <N>    Recurse only N-levels deep. If N=0, query only the specified input"
  echo "        --nodefine         Don't print the function definition"
}

__parse_args() {                                                                                              # {{{1
  #echo "DEBUG: Parse:'$@'"

  # Default values of options
  _opts[ascii]=0
  _opts[color]=1
  _opts[define]=1
  _opts[depth]=-1
  _opts[input]=""
  _opts[level]=0

  local _i
  for _i in "$@"; do
    if [[ $_i =~ ^-h$ ]] || [[ $_i =~ ^--help$ ]]; then
      __help
      return 0
    fi
  done

  local _opt_end=false
  while (( $# > 0 )); do
    #echo "DEBUG: Arg:'$1'"
    case $1 in
      --?*)
        ;&
      -[[:alpha:]])
        if ! $_opt_end && [[ ! $1 =~ ^-l$ ]] && [[ ! $1 =~ ^--level$ ]]; then
          _cmd_recurse+=("$1")
        fi
        ;;&

      --ascii)
        _opts[ascii]=1
        ;;

      --color)
        _opts[color]=1
        ;;
      --nocolor)
        _opts[color]=0
        ;;

      --level|-l)
        # Internal use only. Should not be specified by the user
        shift
        if [[ ! $1 =~ ^[0-9]+$ ]]; then
          echo "ERROR: Current level must be a number"
          return 1;
        fi
        _opts[level]=$1
        ;;

      --max-depth|-d)
        shift
        if [[ ! $1 =~ ^[0-9]+$ ]]; then
          echo -e "ERROR: Max-depth must be a number\n"
          __help
          return 1;
        fi
        _opts[depth]=$1
        ;;

      --nodefine)
        #echo "Don't print function definition"
        _opts[define]=0
        ;;

      --)
        # Standard shell separator between options and arguments
        if ! $_opt_end; then
          _opt_end=true
        fi
        ;;

      -*)
        if ! $_opt_end; then
          echo -e "ERROR: Invalid option: '$1'"
          __help
          return 1;
        fi
        ;&

      *)
        # To support multiple inputs
        while (( $# > 1 )); do
          query ${_cmd_recurse[@]} --level 0 $1
          shift
          echo -e "\n"
        done
        _opts[input]=$1
        ;;
    esac
    shift
  done

  # If you don't give me something to work with, then what am I supposed to do?
  if [[ -z ${_opts[input]} ]]; then
    echo "ERROR: No input specified"
    return 1;
  fi
}

__query_alias() {                                                                                                   # {{{1
  echo "${_query_pp[sep]}${_query_pp[input]} (${_query_pp[type]})"
  while read; do
    echo "${_query_pp[spc]}${REPLY}";
  done < <(command type -a -- "${_opts[input]}" | command head -n2)

  # Recurse
  if (( ${_opts[depth]} == -1 )) || (( ${_query_opts[level]} < ${_query_opts[depth]} )); then
    local _out_arr=()
    read -a _out_arr <<< $(command type -a -- ${_opts[input]} | command grep -Po "(?<=aliased to .).*(?='$)")
    local _query_next=()
    local _level_next=$((${_opts[level]} + 1))
    _query_tree[$_level_next]=0

    local _i=0
    for _i in ${_out_arr[@]}; do
      if [[ "$_i" != "${_opts[input]}" ]]; then
        if [[ $(command type -t -- "$_i") =~ file|function|alias ]]; then
          _query_tree[$_level_next]=$(( ${_query_tree[$_level_next]} + 1 ))
          _query_next+=("$_i")
        fi
      fi
    done
    for _i in ${_query_next[@]}; do
      _query_tree[$_level_next]=$(( ${_query_tree[$_level_next]} - 1 ))
      query "${_cmd_recurse[@]}" --level $_level_next $_i
    done
  fi
}

__query_file() {                                                                                                    # {{{1
  echo "${_query_pp[sep]}${_query_pp[input]} (${_query_pp[type]})"
  while read; do
    echo "${_query_pp[spc]}${REPLY}";
  done < <(command type -a -- "${_opts[input]}" | command head -n1)
}

__query_function() {                                                                                                # {{{1
  echo "${_query_pp[sep]}${_query_pp[input]} (${_query_pp[type]})"
  shopt -s extdebug
  IFS=" " read -a _arr <<< $(command declare -F -- "${_opts[input]}")
  shopt -u extdebug
  echo -e "${_query_pp[spc]}Defined in ${_arr[2]} at line ${_arr[1]}"

  # Print the function definition
  if [[ "${_opts[define]}" == "1" ]]; then
    while read; do
      echo "${_query_pp[spc]}${REPLY}";
    done < <(command type -a -- "${_opts[input]}" | command tail -n+2)
  fi
}

__query_pp() {                                                                                                      # {{{1

  _query_pp[spc]=""
  _query_pp[sep]=""

  # Setup the tree-drawing characters
  if [[ "${_opts[ascii]}" == "1" ]]; then
    local _v_bar='|'
    local _h_bar='-'
    local _x_bar='+'
    local _xl_bar='\'
  else
    local _v_bar='│'
    local _h_bar='─'
    local _x_bar='├'
    local _xl_bar='└'
  fi
  _query_pp[xl]=${_query_pp[xl]:-$_x_bar}

  # Colorize the output?
  if [[ "${_opts[color]}" == "1" ]]; then
    local _c_type="$(tput setaf 4)"
    local _c_input="$(tput bold)$(tput setaf 2)"
    local _c_reset="$(tput sgr0)"
  else
    local _c_type=""
    local _c_input=""
    local _c_reset=""
  fi

  if [[ "${_opts[level]}" != "0" ]]; then
    local _i=0
    for (( _i=1; _i <= ${_opts[level]}; _i++ )); do
      #echo ${_query_tree[$_i]}
      if (( ${_query_tree[$_i]} > 0 )); then
        _query_pp[spc]="${_query_pp[spc]}${_v_bar}   "
      else
        _query_pp[spc]="${_query_pp[spc]}    "
      fi
    done
    if (( ${_query_tree[${_opts[level]}]} == 0 )); then
      _x_bar=$_xl_bar
    fi
    _query_pp[sep]="${_query_pp[spc]%????}${_x_bar}${_h_bar}${_h_bar} "
    echo "${_query_pp[spc]%????}${_v_bar}"
  fi

  _query_pp[type]="${_c_type}${_type}${_c_reset}"
  _query_pp[input]="${_c_input}${_opts[input]}${_c_reset}"
}
# }}}1

  #echo "DEBUG: Cmd='$@'"
  # Default values for options
  local -A _opts=()
  local -a _cmd_recurse=()
  __parse_args "$@"
  local _ret_val=$?
  if [[ "$_ret_val" != "0" ]]; then
    return $_ret_val;
  fi

  local _type=$(command type -t -- "${_opts[input]}")
  #echo "DEBUG: Input='${_opts[input]}', Type='$_type'"

  # Pretty-print the tree structure for recursive lookups
  local -A _query_pp=()
  if (( ${_opts[level]} == 0 )); then
    echo
    local -a _query_tree=()
  fi
  __query_pp

  case $_type in
    "file")
      __query_file
      ;;
    "function")
      __query_function
      ;;
    "alias")
      __query_alias
      ;;
    *)
      command type -a -- "${_opts[input]}"
      ;;
  esac
)

# Short alias for query
alias que=query
