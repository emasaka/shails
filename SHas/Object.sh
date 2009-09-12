# bashOO: OOP mechanism

## load check
if [[ -n "$LOADED_SHas_Object_sh" ]]; then return; fi
LOADED_SHas_Object_sh=1

# bootstrap of class tree
function ::class.extend() {
    local super=$1
    local class=$2
    local t m

    # forward class & instance methods to super class (if it's not defined)
    for t in class instance; do
	for m in $(search_functions "${super}::${t}.*"); do
            m=${m#${super}::${t}.}
	    if ! type -t "${class}::${t}.${m}" > /dev/null; then
		eval "function ${class}::${t}.${m}() {
                          ${super}::${t}.${m} \"\$@\"
                      }"
	    fi
	done
    done

    # define class methods
    for m in $(search_functions "${class}::class.*"); do
        m=${m#${class}::class.}
        eval "function ${class}.${m}() {
                  ${class}::class.${m} \"$class\" \"\$@\"
              }"
    done
    eval "function ${class}.super() {
              echo $super
          }"
}

## Class methods

function Object::class.new() {
    local class=$1
    local self=$2
    shift 2
    local m

    for m in $(search_functions "${class}::instance.*"); do
        m=${m#${class}::instance.}
        eval "function ${self}.${m}() {
                  ${class}::instance.${m} \"$self\" \"\$@\"
              }"
    done
    eval "function ${self}.class() {
              echo ${class}
          }"

    if type -t ${self}.initialize > /dev/null; then
	"${self}.initialize" "$@"
    fi
}

function Object::class.call_super() {
    local class=$1
    local self=$2
    local method=$3
    shift 3

    local super=$(${class}.super)
    "${super}::instance.${method}" "$self" "$@"
}

## Instance methods

function Object::instance.delete() {
    local self=$1
    local fun

    unset "$self"
    eval "unset \${!${self}_*}"
    for fun in $(search_functions "${self}.*"); do
        unset -f "$fun"
    done
}


## Internal functions

function search_functions() {
    local ptn=$1
    local func line

    declare -F | while read -r line; do
        func=${line##* }
        [[ "$func" == ${ptn} ]] && echo $func
    done
}


# make Object class
::class.extend '' Object
