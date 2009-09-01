readonly SCHEMAFILE='db/schema.sh'
readonly MODELDIR='app/models'

function generator.model() {
    if (( $# < 1 )); then generator.model.usage; fi
    local model=$1
    shift
    generator.model.modelfile "$model"
    generator.model.schemafile "$model" "$@"
}

function generator.model.modelfile() {
    local model=$1

    if [[ -e "$MODELDIR" ]]; then
      echo "      exists  $MODELDIR"
    else
      echo "      create  $MODELDIR"
      mkdir -p "$MODELDIR"
    fi

    if [[ -f "${MODELDIR}/${model}.sh" ]]; then
	echo "      exists  ${MODELDIR}/${model}.sh"
    else
	echo "      create  ${MODELDIR}/${model}.sh"
	echo "SHar::base.extend ${model}" > "${MODELDIR}/${model}.sh"
    fi
}

function generator.model.schemafile() {
    local model=$1
    shift

    echo "      create  $SCHEMAFILE"

    generator.model.schemafile_begin "$model"

    if (( $# > 0 )); then
	local e
	for e; do
	    if [[ "$e" == *:* ]]; then
		local column=${e%%:*}
		local type=${e#*:}
		generator.model.schemafile_column "$column" "$type"
	    fi
	done
    else
	generator.model.schemafile_column_comment
    fi

    generator.model.schemafile_end
}

function generator.model.schemafile_begin() {
    local model=$1
    echo "create_table ${model} t" >> "$SCHEMAFILE"
}

function generator.model.schemafile_column() {
    local column=$1
    local typename=$2
    echo "    t.column ${column} ${typename}" >> "$SCHEMAFILE"
}

function generator.model.schemafile_column_comment() {
    echo "    # t.column name string" >> "$SCHEMAFILE"
}

function generator.model.schemafile_end() {
    echo 'elbat_etaerc' >> "$SCHEMAFILE"
}

function generator.model.usage() {
    echo "usage: $0 model model-name ..."
    exit 1
}
