## load check
if [[ -n "$LOADED_SHas_logger_sh" ]]; then return; fi
LOADED_SHas_logger_sh=1

readonly LOGLEVEL_FATAL=5
readonly LOGLEVEL_ERROR=4
readonly LOGLEVEL_WARN=3
readonly LOGLEVEL_INFO=2
readonly LOGLEVEL_DEBUG=1

LOGGER_LOGLEVEL=$LOGLEVEL_ERROR
LOGGER_LOGFILE='/dev/tty'

function logger.set_log() {
    LOGGER_LOGFILE=$1
}

function logger.level() {
    local level
    for level in "$@"; do
        case "$level" in
        FATAL)
            LOGGER_LOGLEVEL=$LOGLEVEL_FATAL
            ;;
        ERROR)
            LOGGER_LOGLEVEL=$LOGLEVEL_ERROR
            ;;
        WARN)
            LOGGER_LOGLEVEL=$LOGLEVEL_WARN
            ;;
        INFO)
            LOGGER_LOGLEVEL=$LOGLEVEL_INFO
            ;;
        DEBUG)
            LOGGER_LOGLEVEL=$LOGLEVEL_DEBUG
            ;;
        esac
    done
}

function logger.fatal() {
    if (( $LOGGER_LOGLEVEL <= $LOGLEVEL_FATAL )); then
        echo "ERROR: $*" >> "$LOGGER_LOGFILE"
    fi
}

function logger.error() {
    if (( $LOGGER_LOGLEVEL <= $LOGLEVEL_ERROR )); then
        echo "ERROR: $*" >> "$LOGGER_LOGFILE"
    fi
}

function logger.warn() {
    if (( $LOGGER_LOGLEVEL <= $LOGLEVEL_WARN )); then
        echo "WARN: $*" >> "$LOGGER_LOGFILE"
    fi
}

function logger.info() {
    if (( $LOGGER_LOGLEVEL <= $LOGLEVEL_INFO )); then
        echo "INFO: $*" >> "$LOGGER_LOGFILE"
    fi
}

function logger.debug() {
    if (( $LOGGER_LOGLEVEL <= $LOGLEVEL_DEBUG )); then
        echo "DEBUG: $*" >> "$LOGGER_LOGFILE"
    fi
}
