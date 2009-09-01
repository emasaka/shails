# read database schema (db/schema.sh) and create tables
# results:
#    create tables on database

. config/environment.sh
. vendor/SHas/string.sh

## read database configuration
. vendor/SHar/dbconf.sh

## make tables

. vendor/SHar/crud.sh

function create_table() {
    table=$1
    prefix=$2
    columns_sql="id INTEGER PRIMARY KEY AUTOINCREMENT"

    eval "function ${prefix}.column() {
              local column=\$1
              local datatype=\$(type2dbtype \$2)
              string_push columns_sql \", \$column \$datatype\"
          }"
}

function elbat_etaerc() {
    echo "-- create_table($table)"
    do_create_table "$dbconf_database" "$table" "$columns_sql"
}

# to enclose the variable 'table', 'prefix', 'columns_sql'
function load_schema() {
    local table prefix columns_sql
    . db/schema.sh
    unset -f ${prefix}.column
}

load_schema
