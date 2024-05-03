# this is sourced from bashrc
#
#
DEBUG=''

info(){ echo "$@" >&2; }

[ -n "$DEBUG" ]  && info scriipt

bashrc_utils__run(){
    cmd="${1:-}"
    if [ -n "$cmd" ] ; then
        shift
    else
        echo "Err: no cmd" >&2
        return 1
    fi

    dirinput="${1:-}"
    if [ -n "$dirinput" ] ; then
        shift
    else
        echo "Err: no dirinput" >&2
        return 1
    fi

    action=
    case "$cmd" in
        alias_gen|file_sourcing) action="bashrc_utils__$cmd" ;;
        *)
            echo "Err: invalid cmd '$cmd'"
            return 1
        ;;
    esac

    [ -n "$DEBUG" ]  && info eend 

    for dir in "$@" ; do
        utilsdir="$dirinput/$dir"
        [ -d "$utilsdir" ] || continue
        [ -n "$DEBUG" ]  && info utiiilsdir $utilsdir 
        ${action} "$utilsdir"
    done
}


bashrc_utils__get_interp(){
    local ext="${1:-}"
    if [ -z "$ext" ] ; then
        echo "Err: no ext " >&2
        return 1
    fi

    case "$ext" in
        'sh'|'bash'|'dash')  echo "$ext";;
        'rb')  echo "ruby";;
        'pl')  echo "perl";;
        'py')  echo "python";;
        '*')
            [ -n "$DEBUG" ] echo "Dbg: extension '$ext' not implemented, skip alias" >&2
            return 0
        ;;
    esac
}

bashrc_utils__alias_gen(){
    local utilsdir="${1:-}"

    if [ -z "$utilsdir" ] ; then 
        echo "Err: no utilsdir " >&2
        return 1
    fi

    for scriptfile in "$utilsdir"/*; do
        [ -f "$scriptfile" ] || continue

        bname="$(basename "$scriptfile")"
        name="${bname%.*}"
        ext="${bname##*.}"

        interp="$(bashrc_utils__get_interp "$ext")" || {
            echo "Err: could not get interp" >&2
            return 1
        }
            
        if [ -n "$interp" ] ; then
            case "$name" in
                _*|lib*) continue;;
                *)
                    [ -n "$DEBUG" ] && echo "alias $name = $interp $scriptfile"
                    alias "$name"="$interp $scriptfile"
                    ;;
            esac
        fi
    done
}


bashrc_utils__file_sourcing(){
    local dir="${1:-}"
    if [ -z "$dir" ]; then 
        echo "Err: no dir" >&2
        return 1
    fi

    for f in $dir/*.*sh; do
        [ -f "$f" ] || continue
        case "${f##*/}" in
            _*|lib*) continue ;;
            *.sh|*.bash)
                [ -n "$DEBUG" ] && echo source $f
                source "$f"
            ;;
            *) : ;;
        esac
    done
}

