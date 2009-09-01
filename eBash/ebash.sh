readonly EBASH_MODE_CMD=1
readonly EBASH_MODE_VAR=2

function escape_quote() {
    local str=$1
    local q="'\''"
    echo "${str//\'/$q}"
}

function ebash::parse_cmd () {
    local c="$*"
    local b a

    case "$c" in
    *\%\>*)
	b=${c%%\%>*}
	a=${c#*\%>}
	echo "$b"
	ebash::parse_normal "$a"
	;;
    *)			# "<%" didn't closed in this line
	echo "$c"
	return $EBASH_MODE_CMD;
	;;
    esac
}

function ebash::parse_var () {
    local c="$*"
    local b a

    case "$c" in
    *\%\>*)
	b=${c%%\%>*}
	a=${c#*\%>}
	echo "echo -n \$$b"
	ebash::parse_normal "$a"
	;;
    *)			# "<%=" didn't closed in this line
	echo "echo -n \$$c"
	return $EBASH_MODE_VAR;
	;;
    esac
}

function ebash::parse_normal () {
    local c="$*"
    local b a

    case "$c" in
    *\<\%*)
	b=${c%%<%*}
	a=${c#$b<\%}
	if [[ -n "$b" ]]; then
	    echo "echo -n '$(escape_quote ${b})'"
	fi
	if [[ "$a" == =* ]]; then	# "<%="
	    ebash::parse_var "${a#=}"
	elif [[ "$a" == %* ]]; then	# "<%%"
	    echo "echo -n '<%'"
	    ebash::parse_normal "${a#%}"
	elif [[ "$a" != '' ]]; then	# "<%"
	    ebash::parse_cmd "$a"
	fi
	;;
    *)
	echo "echo '$(escape_quote $c)'"
	;;
    esac
}

function ebash_template() {
    local source=$1
    local -i status=0
    local c
    local IFS=''

    while read c; do
        case "$status" in
        0)
	    ebash::parse_normal "$c"
	    ;;
        $EBASH_MODE_CMD)
	    ebash::parse_cmd "$c"
	    ;;
        $EBASH_MODE_VAR)
	    ebash::parse_var "$c"
	    ;;
        esac
        status="$?"
    done < "$source"
}
