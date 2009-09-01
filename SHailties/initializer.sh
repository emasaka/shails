function initializer.run() {
    load_baselibs
    load_environment
    initializer_logger
    require_frameworks
    initialize_routing
    load_application
}

function load_baselibs() {
    local f
    for f in vendor/SHas/*.sh; do
        . $f
    done
}

function load_environment() {
    . config/environment.sh
    if [[ -n "$SHAILS_ENV" && -f "config/environments/$SHAILS_ENV.sh" ]]; then
        . "config/environments/${SHAILS_ENV}.sh"
    fi
}

function initializer_logger() {
    logger.set_log "log/${SHAILS_ENV}.log"
}

function require_frameworks() {
    . vendor/SHar/base.sh
    . vendor/SHac/base.sh
    . vendor/SHac/routing.sh
    . vendor/eBash/class.sh
    local f
    for f in vendor/SHac/helper/*.sh; do
	. $f
    done
}

function load_application() {
    local t
    for t in $table_list; do
	. "app/models/${t}.sh"
	. "app/controllers/${t}_controller.sh"
    done
}
