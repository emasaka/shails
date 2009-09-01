function link_to() {
    local name=$1
    shift
    local url=$(url_for "$@")
    echo "<a href=\"$url\">$name</a>"
}

function url_for() {
    local p_controller=$params_controller
    local p_action=$params_action
    local p_id
    local e
    for e; do
	case "$e" in
	:controller=*)
	    p_controller=${e#:controller=}
            ;;
	:action=*)
	    p_action=${e#:action=}
            ;;
	:id=*)
	    p_id=${e#:id=}
            ;;
	esac
    done

    echo -n "http://${SERVER_NAME}$(build_query_string $p_controller $p_action $p_id)"
}
