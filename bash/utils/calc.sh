#=======================================================================================================================
# calc: Calculator using Python. Supports hex (0x) and binary (0b) literals.
# Usage: = 4 + 5
#        = 0xFF + 0b1010
#        = 2**8
#        echo "16 * 32" | =
#=======================================================================================================================

# Check dependencies
if ! command -v python3 &>/dev/null; then
    echo "Error: python3 not found." >&2
    return 1
fi

unset -f =
=() {
    local _input="${@:-$(</dev/stdin)}"

    # Use Python for evaluation with smart output formatting
    python3 << EOF
try:
    result = ${_input}
    # Auto-detect output format based on input
    input_str = """${_input}"""

    # Check if input contains hex or binary literals
    has_hex = '0x' in input_str.lower() or any(c in input_str for c in 'abcdefABCDEF')
    has_bin = '0b' in input_str.lower()

    # Format output accordingly
    if has_hex and not has_bin:
        print(hex(int(result)))
    elif has_bin and not has_hex:
        print(bin(int(result)))
    elif has_hex and has_bin:
        # If both present, prefer hex output
        print(hex(int(result)))
    else:
        print(result)
except Exception as e:
    import sys
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)
EOF
}

# Base converter using Python
unset -f =base
=base() (
    _help () {
        echo 'SYNTAX:'
        echo '  =base NUM TO [FROM=10]'
        echo '  echo NUM | =base TO [FROM=10]'
        echo '  =base TO [FROM=10] <<< "NUM"'
        echo ''
        echo 'EXAMPLES:'
        echo '  =base 255 16          # Convert 255 to hex → 0xff'
        echo '  =base 0xFF 2          # Convert hex to binary → 0b11111111'
        echo '  =base 0b1010 10       # Convert binary to decimal → 10'
    }

    if (( $# <= 1 )); then
        echo "ERROR: Insufficient arguments. At least two required" >&2
        _help
        return 1
    fi

    if [[ -p /dev/stdin ]] || [[ -s /dev/stdin ]]; then
        local _num=$(</dev/stdin)
    else
        local _num=$1
        shift
    fi

    local _obase=$1
    local _ibase=${2:-10}

    # Use Python for base conversion
    python3 << EOF
try:
    # Parse input number
    num_str = "${_num}".strip()
    if num_str.startswith(('0x', '0X')):
        num = int(num_str, 16)
    elif num_str.startswith(('0b', '0B')):
        num = int(num_str, 2)
    else:
        num = int(num_str, ${_ibase})

    # Convert to target base
    if ${_obase} == 2:
        print(bin(num))
    elif ${_obase} == 16:
        print(hex(num))
    else:
        print(num)
except ValueError as e:
    import sys
    print(f"Error: Invalid number format - {e}", file=sys.stderr)
    sys.exit(1)
EOF
)

# Base conversion shortcuts
=bin() { =base "$1" 2 "${2:-10}"; }   # Convert to binary, default from decimal
=dec() { =base "$1" 10 "${2:-16}"; }  # Convert to decimal, default from hexadecimal
=hex() { =base "$1" 16 "${2:-10}"; }  # Convert to hexadecimal, default from decimal

unset -f =slice
=slice() (
    _help() {
        echo 'SYNTAX:'
        echo '  =slice NUM MSB LSB    # Extract bits MSB:LSB from NUM'
        echo '  =slice NUM BIT        # Extract single bit BIT from NUM'
        echo '  echo NUM | =slice MSB LSB'
        echo ''
        echo 'EXAMPLES:'
        echo '  =slice 0xFF 7 4       # Extract bits 7:4 from 0xFF → 0xf'
        echo '  =slice 0b11110000 6   # Extract bit 6 → 0b1'
        echo '  =slice 255 3 0        # Extract bits 3:0 from 255 → 15'
    }

    # Parse arguments
    if (( $# >= 3 )); then
        local _num=$1
        local _msb=$2
        local _lsb=${3:-$2}
    elif (( $# == 2 )); then
        if [[ -p /dev/stdin ]] || [[ -s /dev/stdin ]]; then
            local _num=$(</dev/stdin)
            local _msb=$1
            local _lsb=${2:-$1}
        else
            local _num=$1
            local _msb=$2
            local _lsb=$2
        fi
    elif (( $# == 1 )); then
        if [[ -p /dev/stdin ]] || [[ -s /dev/stdin ]]; then
            local _num=$(</dev/stdin)
            local _msb=$1
            local _lsb=$1
        else
            echo "ERROR: Insufficient arguments" >&2
            _help
            return 1
        fi
    else
        echo "ERROR: Insufficient arguments" >&2
        _help
        return 1
    fi

    # Validate MSB >= LSB
    if (( _lsb > _msb )); then
        echo "ERROR: MSB must be >= LSB when slicing" >&2
        _help
        return 1
    fi

    # Use Python for bit slicing
    python3 << EOF
try:
    # Parse number
    num_str = "${_num}".strip()
    if num_str.startswith(('0x', '0X')):
        num = int(num_str, 16)
        output_hex = True
    elif num_str.startswith(('0b', '0B')):
        num = int(num_str, 2)
        output_hex = False
    else:
        num = int(num_str)
        output_hex = False

    # Perform bit slicing: (num >> lsb) & ((1 << (msb - lsb + 1)) - 1)
    result = (num >> ${_lsb}) & ((1 << (${_msb} - ${_lsb} + 1)) - 1)

    # Output in appropriate format
    if output_hex:
        print(hex(result))
    else:
        print(result)
except Exception as e:
    import sys
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)
EOF
)
