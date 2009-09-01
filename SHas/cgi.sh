## load check
if [[ -n "$LOADED_SHas_cgi_sh" ]]; then return; fi
LOADED_SHas_cgi_sh=1

function CGI.new() {
    local name=$1
    local IFS

    if [[ -n "$CONTENT_LENGTH" ]]; then
	local str
	IFS=''
	read -n "$CONTENT_LENGTH" str

	IFS='&'
	local -a ary=($str)

	local p var val
	for p in "${ary[@]}"; do
	    if [[ "$p" == *=* ]]; then
		var=${p%%=*}
		val=${p#*=}
		eval "${name}_${var#:}='$(CGI.unescape $val)'"
	    fi
	done
    fi
}

function CGI.unescape() {
    local str=$1
    str=${str//+/ }
    str=${str//%/\\x}
    echo -e "$str"
}

function CGI.header() {
    local url=$1
    local h
    for h; do
	echo -e "$h\r"
    done
    echo -e "\r"
}

function CGI.redirect() {
    local url=$1
    CGI.header "Location: $url"
}
