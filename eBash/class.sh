. vendor/eBash/ebash.sh
. vendor/SHas/Object.sh

function ebash::instance.initialize() {
    local self=$1
    local source=$2
    eval "$self=\$(ebash_template \"$source\")"
}

function ebash::instance.result() {
    local self=$1
    eval "${!self}"
}

Object.extend ebash
