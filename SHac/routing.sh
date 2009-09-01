## configure routes
# results:
#    following shell variables to be set:
#        ROUTING_ROUTES
function map.connect() {
    string_push ROUTING_ROUTES " $1"
}

function initialize_routing() {
    ROUTING_ROUTES=''
    . 'config/routes.sh'
}

## recognize routes
# results:
#    following shell variables to be set:
#        ROUTING_CURRENT_ROUTE
#        params_${param}
function route.recognize() {
    local req=$1

    CGI.new 'params'

    req=$(CGI.unescape $req)
    local r
    for r in $ROUTING_ROUTES; do
        ROUTING_CURRENT_ROUTE="$r"
	if route::match "$req" "$r";then
	    params_action=${params_action:-index}
	    break
	fi
    done
}

function route::match() {
    local req=$1
    local routing=$2

    string_split '/' "$req"
    local -a req_a=("${result_val[@]}")
    string_split '/' "$routing"
    local -a route_a=("${result_val[@]}")

    local e
    for e in "${route_a[@]}"; do
	if [[ "$e" == :* ]]; then
	    unset ${e#:}
	fi
    done

    local -i size=${#req_a[@]}
    local -i i
    for (( i = 0; i < size; i++ )); do
	case "${route_a[$i]}" in
        :*)
	    elem="${route_a[$i]#:}"
	    eval "params_${elem}='${req_a[$i]}'"
            ;;
        *)
            if [[ "${req_a[$i]}" != "${route_a[$i]}" ]]; then
		return 1
	    fi
            ;;
	esac
    done
    return 0
}


## build url from routes
# inputs:
#    following shell variables must be given:
#        ROUTING_CURRENT_ROUTE
#        params_${param}
function build_query_string() {
    local controller=$1
    local action=$2
    local id=$3
    eval echo \"${ROUTING_CURRENT_ROUTE//:/$}\"
}
