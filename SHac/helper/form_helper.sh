function form_tag() {
    local url=$(url_for "$@")
    tag form action=\"$url\" 'method="post"'
}

function end_form_tag() {
    echo -n '</form>'
}

function text_field() {
    local record=$1
    local field=$2
    local var_name=${record}_${field}
    input_field_tag id=\"${var_name}\" name=\"${var_name}\" value=\"${!var_name}\" size=\"30\"
}

function text_area() {
    local record=$1
    local field=$2
    local var_name=${record}_${field}
    tag textarea id=\"${var_name}\" name=\"${var_name}\" 'cols="20"' 'rows="10"'
    echo "${!var_name}"
    echo -n '</textarea>'
}

function submit_tag() {
    local name=$1
    input_field_tag 'submit' value=\"$name\"
}

function input_field_tag() {
    local type=$1
    shift
    tag input type=\"$type\" "$@"
}

function tag() {
    echo -n '<'"$@"'>'
}
