#!/bin/sh
set -u

USAGE='[--[c]class | --[s]ource] <java file>'

HELP='run java programs like scripts, directly without explicit compilation '


java_version=22


info() { echo "$@" >&2; }
die() { echo "$@" >&2; exit 1; }

mode=
while [ $# -gt 0 ] ; do 
    case "$1" in
        -h|--help)
            info "usage: $USAGE"
            info "Help:"
            info "$HELP"
            exit 1
            ;;
        -c|--class) mode='class' ;;
        -s|--source) mode='source' ;;
        -*) die "Err: invalid option" ;;
        *) break ;;
    esac
    shift
done


input="${1:-}"
[ -n "$input" ] || die "usage: $USAGE"
[ -f "$input" ] || die "Err: no file under '$input'"

[ -z "$mode" ] && mode='source'



case "$mode" in
    source) java --source "$java_version" --enable-preview "$input" ;;
    class)
        file_base="${input##*/}"
        file_name="${file_base%.*}"
        file_path= 
        case "$input" in
            */*) file_path="${input%/*}/${file_name}" ;;
            *) file_path="${file_name}" ;;
        esac
        file_class="$file_path.class"

        if [ -f "$file_class" ] ; then
            if [ "$input" -nt "$file_class" ]; then
                rm -f "$file_class"
                javac --release "$java_version" --enable-preview "$input" || die "Err: failed to compile"
            else
                :
            fi
        else
                javac --release "$java_version" --enable-preview "$input" || die "Err: failed to compile"
        fi
        if [ -f "$file_class" ] ; then
            java  --enable-preview "$file_path" 
        else
            die "Err: could not generate class file '$file_class'"
        fi

        ;;
    *)
        die "Err: invalid mode '$mode'";;
esac






