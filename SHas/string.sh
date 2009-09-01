# utility functions of strings

## load check
if [[ -n "$LOADED_SHas_string_sh" ]]; then return; fi
LOADED_SHas_string_sh=1

## push string to variable
function string_push() {
    # $1: variable name, $2: string
    eval "$1=\"\$$1$2\""
}

## convert space-separated values to comma-separated values
function spc2comma() {
    local csv
    local str
    local s
    for str; do
        for s in $str; do
            string_push csv ", $s"
        done
    done
    echo "${csv#, }"
}

## split strings by separator
## retuen value (array) is set to variable "result_val"
function string_split() {
    local separator=$1
    local str=$2

    local IFS=$separator
    result_val=($str)
}
