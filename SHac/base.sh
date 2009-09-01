function base_controller::class.redirect_to() {
    local class=$1
    local url=$(url_for "$@")
    logger.debug "redirect to $url"
    CGI.redirect "$url"
}

function base_controller::class.render() {
    local class=$1
    local action

    shift
    local e
    for e; do
	case "$e" in
	:action=*)
            action=${e#:action=}
            ;;
	esac
    done

    logger.debug "call ${class}.${action}"
    ${class}.${action}

    if [[ -n "$SHac_RENDER_DONE" ]]; then return; fi
    SHac_RENDER_DONE=1

    local file="app/views/${class%_controller}/${action}.ebash"
    if [[ -e "$file" ]]; then
	logger.debug "render file $file"
	controller::render_file "$file"
    fi
}


## Internal functions

function controller::render_file() {
    local file=$1
    local tmpl

    CGI.header 'Content-type: text/html'
    ebash.new tmpl "$file"
    tmpl.result
    tmpl.delete
}


# make base_controller class
Object.extend base_controller
