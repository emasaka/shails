. vendor/SHas/logger.sh

function do_sql() {
    local dbfile=$1
    local sql=$2
    logger.debug "sqlite3 $dbfile: $sql"
    echo ".timeout $dbconf_timeout
          $sql" | sqlite3 "$dbfile"
}

function do_sql_stdoutlog() {
    local dbfile=$1
    local sql=$2
    local result=$(do_sql "$dbfile" "$sql")
    if [[ -n "$result" ]]; then
	logger.error "SQL: $sql: $result"
    fi
}

function do_create_table() {
    local dbfile=$1
    local table=$2
    local columns=$3
    (
        umask 0
        true > "$dbfile"
    )
    do_sql_stdoutlog "$dbfile" "CREATE TABLE $table ($columns);"
}

function do_insert() {
    local dbfile=$1
    local table=$2
    local columns=$3
    local values=$4
    do_sql_stdoutlog "$dbfile" "INSERT INTO $table ($columns) VALUES ($values);"
}

function do_select() {
    local dbfile=$1
    local table=$2
    local columns=$3
    local where_c=$4
    do_sql "$dbfile" "SELECT $columns FROM $table WHERE $where_c;"
}

function do_update() {
    local dbfile=$1
    local table=$2
    local where_c=$3
    local set_value=$4
    do_sql "$dbfile" "UPDATE $table SET $set_value WHERE $where_c;"
}

function do_delete() {
    local dbfile=$1
    local table=$2
    local where_c=$3
    do_sql_stdoutlog "$dbfile" "DELETE FROM $table WHERE $where_c;"
}


## utiliti function

function str2column() {
    local datatype=$1
    local value=$2
    case "$datatype" in
    string|text)
        echo "'$value'"
        ;;
    integer)
        echo "${value:-0}"
        ;;
    *)
        echo "${value}"
        ;;
    esac
}

function type2dbtype(){
    local datatype=$1
    case "$datatype" in
    string|text)
        echo 'text'
        ;;
    integer)
        echo 'integer'
        ;;
    *)
        echo $datatype
        ;;
    esac
}
