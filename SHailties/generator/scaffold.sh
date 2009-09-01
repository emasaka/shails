
readonly CONTROLLERDIR='app/controllers'
readonly CONTROLLER_TEMPLDIR='vendor/SHailties/generator/controller/templates'

readonly VIEWDIR='app/views'
readonly VIEW_TEMPLDIR='vendor/SHailties/generator/view/templates'

function generator.scaffold() {
    if (( $# < 1 )); then generator.scaffold.usage; fi
    local model=$1
    generator.scaffold.load_libs
    generator.scaffold.controllers "$model"
    generator.scaffold.view "$model"
}

generator.scaffold.load_libs() {
    . vendor/SHailties/initializer.sh
    load_baselibs
    load_environment
    . vendor/SHar/schema/read.sh
    . vendor/eBash/class.sh
}

function generator.scaffold.controllers {
    local controller=$1
    local tmpl

    if [[ -e "$CONTROLLERDIR" ]]; then
      echo "      exists  $CONTROLLERDIR"
    else
      echo "      create  $CONTROLLERDIR"
      mkdir -p "$CONTROLLERDIR"
    fi

    local controllerfile="${CONTROLLERDIR}/${controller}_controller.sh"
    if [[ -e "$controllerfile" ]]; then
        echo "      exists  $controllerfile"
    else
        echo "      create  $controllerfile"

        ebash.new tmpl "${CONTROLLER_TEMPLDIR}/controller.sh"
        tmpl.result > "$controllerfile"
        tmpl.delete
    fi
}

function generator.scaffold.view {
    local model=$1
    local t tmpl

    if [[ -e "$VIEWDIR/$model" ]]; then
      echo "      exists  $VIEWDIR/$model"
    else
      echo "      create  $VIEWDIR/$model"
      mkdir -p "$VIEWDIR/$model"
    fi

    for t in ${VIEW_TEMPLDIR}/*; do
        local viewfile="${VIEWDIR}/${model}/${t##*/}"
        if [[ -e "$viewfile" ]]; then
            echo "      exists  $viewfile"
        else
            echo "      create  $viewfile"

            ebash.new tmpl "$t"
            tmpl.result > "$viewfile"
            tmpl.delete
        fi
    done
}

function generate_input() {
    local column=$1
    local type=$2

    case "$type" in
    string|integer)
        echo -n "<% text_field 'current_item' '${column}' %>"
        ;;
    text)
        echo -n "<% text_area 'current_item' '${column}' %>"
        ;;
    esac
}

function generator.scaffold.usage() {
    echo "usage: $0 scaffold model-name"
    exit 1
}
