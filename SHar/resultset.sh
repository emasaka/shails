## load check
if [[ -n "$LOADED_SHar_resultset_sh" ]]; then return; fi
LOADED_SHar_resultset_sh=1

. vendor/SHas/string.sh
. vendor/SHas/logger.sh

readonly RESULTSET_BASEDIR='tmp/resultset'

function resultset.readin() {
    local resultarray=$1
    shift
    local dbfile=$1
    local table=$2
    local cacheid="$$_$RANDOM"
    local cachedir="$RESULTSET_BASEDIR/${dbfile##*/}/$table"
    local cachefile="$cachedir/$cacheid"

    (
        umask 077
        mkdir -p "$cachedir"
        do_select "$@" > "$cachefile"
    )
    local ary=$(resultset.resultarray "$table" "$cachefile" "$cacheid")
    eval $resultarray=\"$ary\"
}

function resultset.resultarray() {
    local table=$1
    local cachefile=$2
    local cacheid=$3
    local str
    local r_id rest_dat

    local IFS='|'
    while read -r r_id rest_dat; do
        string_push str " resultset/$table/$cacheid/$r_id"
    done < "$cachefile"
    echo "${str# }"
}

function resultset.bless() {
    local instance=$1
    local dbfile=$2

    set -- ${!instance}
    local instance_stat=$1

    string_split '/' "$instance_stat"
    local table=${result_val[1]}
    local cacheid=${result_val[2]}
    local id=${result_val[3]}

    local cachefile="$RESULTSET_BASEDIR/${dbfile##*/}/$table/$cacheid"
    local table_columns_var=${table}_columns
    local -a column_ary=(${!table_columns_var})

    local IFS='|'
    local r_id line v
    local -i i=0
    while read -r r_id line; do
        if [[ $r_id == $id ]]; then
            eval ${instance}_id=\"$r_id\"
            for v in $line; do
                eval ${instance}_${column_ary[$(( i++ ))]}=\"$v\"
            done
            eval $instance=blessed/$table
            break
        fi
    done < "$cachefile"
}

function resultset.cleanall() {
    rm -rf $RESULTSET_BASEDIR
}

function resultset.cleanmine() {
    local db tbl

    if [[ ! -d $RESULTSET_BASEDIR ]]; then return; fi
    for db in $RESULTSET_BASEDIR/*; do
        if [[ ! -d $db ]]; then return; fi
        for tbl in $db/*; do
            if [[ ! -d $tbl ]]; then return; fi
            rm -f $tbl/$$_*
        done
    done
}
