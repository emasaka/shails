# O/R mapper
# results:
#    (TBD)

# read schema to variables
. vendor/SHar/schema/read.sh
. vendor/SHar/crud.sh

## Class methods

function SHar::base::class.find() {
    local table=$1
    local resultarray=$2
    local arg=$3

    local table_columns_var=${table}_columns
    local columns=$(spc2comma "${!table_columns_var}")

    local where_c
    case "$arg" in
    :all)
        where_c='1 = 1'
        ;;
    :conditions=*)
        where_c="${arg#:conditions=}"
        ;;
    esac

    resultset.readin "$resultarray" "$dbconf_database" "$table" "id, $columns" "$where_c"
}

function SHar::base::class.bless() {
    local table=$1
    local self=$2

    local self_val=${!self}
    "${table}.new" "$self"
    eval "$self=$self_val"
    resultset.bless "$self" "$dbconf_database"
}

function SHar::base::class.delete() {
    local table=$1
    local id=$2
    do_delete "$dbconf_database" "$table" "id = $id"
}

function SHar::base::class.delete_all() {
    local table=$1
    do_delete "$dbconf_database" "$table" "1 = 1"
}


## Instance methods

function SHar::base::instance.initialize() {
    local self=$1
    local hash=$2

    eval "${self}=new/$(${self}.class)"

    # set instance variables from hash parameter
    if [[ -n "$hash" ]]; then
        SHar.hash2attribute "$hash"
    fi
}

function SHar::base::instance.update_attributes() {
    local self=$1
    local hash=$2

    SHar.hash2attribute "$hash"
    ${self}.save
}

function SHar::base::instance.save() {
    local self=$1

    local self_stat=${!self}
    local table

    case "$self_stat" in
    new/*)
        string_split '/' "$self_stat"
        table=${result_val[1]}
        SHar.insert_record "$table" "$self"
        eval "$self=blessed/$table"
        ;;
    resultset/*)
        true	# do nothing
        ;;
    blessed/*)
        string_split '/' "$self_stat"
        table=${result_val[1]}
        SHar.update_record "$table" "$self"
        ;;
    esac
}


## Internal functions

function SHar.insert_record() {
    local table=$1
    local instance=$2

    local table_columns_var=${table}_columns
    local columns=$(spc2comma "${!table_columns_var}")
    local values=$(SHar.format_param "$table" "$instance" '$v')

    do_insert "$dbconf_database" "$table" "$columns" "$values"
}

function SHar.update_record() {
    local table=$1
    local instance=$2

    local instance_id_var=${instance}_id
    local id=${!instance_id_var}
    local set_value=$(SHar.format_param "$table" "$instance" '$c = $v')

    do_update "$dbconf_database" "$table" "id = $id" "$set_value"
}

function SHar.hash2attribute() {
    local hash=$1

    eval "local vars=\"\${!${hash}_*}\""
    local v
    for v in $vars; do
        eval "${self}_${v#${hash}_}='${!v}'"
    done
}

function SHar.format_param() {
    local table=$1
    local instance=$2
    local format=$3

    local table_columns_var=${table}_columns
    local columns=${!table_columns_var}
    local table_columns_type_var=${table}_columns_type
    local -a types_ary=(${!table_columns_type_var})

    local str var c v
    local -i i=0
    for c in $columns; do
	var=${instance}_${c}
        v=$(str2column "${types_ary[$(( i++ ))]}" "${!var}")
        string_push str ", $format"
    done
    echo "${str#, }"
}


# make SHar::base class
Object.extend SHar::base
