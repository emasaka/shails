# read database schema (db/schema.sh) to shell variables
# results:
#    following shell variables to be set:
#        $table_list
#        ${table}_columns
#        ${table}_columns_type

. config/environment.sh
. vendor/SHas/string.sh

## read database configuration
. vendor/SHar/dbconf.sh


## read schemas

. vendor/SHar/crud.sh

function create_table() {
    table=$1
    prefix=$2

    string_push table_list " $table"
    unset ${table}_columns ${table}_columns_type

    eval "function ${prefix}.column() {
              local column=\$1
              local datatype=\$2
              string_push \${table}_columns \" \$column\"
              string_push \${table}_columns_type \" \$datatype\"
          }"
}

function elbat_etaerc() {
    true	# dummy
}

# to enclose the variable 'table', 'prefix'
function load_schema() {
    local table prefix
    unset table_list
    . db/schema.sh
    unset -f "${prefix}.column"
}

load_schema
