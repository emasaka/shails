# read database configuration (config/environment.sh)
# results:
#    following shell variables to be set:
#        dbconf_${param}

. config/environment.sh

## read database configuration

readonly DBCONF_ENVIRONMENTS="development test production"
readonly DBCONF_PARAMETERS="adapter database timeout"

function define_dbconf_functions() {
    local env param

    for env in $DBCONF_ENVIRONMENTS; do
        eval "function ${env}:() {
                  conf_env='${env}'
              }"
    done

    for param in $DBCONF_PARAMETERS; do
        eval "function ${param}:() {
                  if [ "\$SHAILS_ENV" == "\$conf_env" ]; then
                      dbconf_${param}=\$1
                  fi
              }"
    done
}

# to enclose the variable 'conf_env'
function load_dbconf() {
    local conf_env
    define_dbconf_functions
    . config/database.sh
}

load_dbconf
