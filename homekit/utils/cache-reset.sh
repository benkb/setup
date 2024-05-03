#!/bin/sh

HELP='A simple template that gets libutil script'

USAGE='[-q|--quiet] <cache>'

set -u

INPUT_DIR="${1:-}"

SCRIPTNAME="${0##*/}"
PWDNAME="${PWD##*/}"

CACHE_DIR_XDG="${XDG_CACHE_HOME:-}"
CACHE_DIR_ALT="$HOME/.cache"

prn(){ printf "%s" "$@"; }
fail(){ echo "Fail: $@" >&2; }
info(){ echo "$@" >&2; }
die(){ echo "$@" >&2; exit 1; }
usage(){ die "Usage - ${SCRIPTNAME%.*}: $USAGE" ; }


#### LIBUTIL
#LIBUTIL="$(cd "$(dirname -- "$0")" >/dev/null; pwd -P)"'/libutil.sh'
if [ -n "${LIBUTIL:-}" ] ; then
    [ -f "$LIBUTIL" ] ||  die "Err: could not load libutil under '$LIBUTIL'"
    . "$LIBUTIL"  || die "Err: could not load libutil under '$LIBUTIL'";
    PWDPATH="$(libutil__abspath "$PWD")"
fi
####
#

#echo pwdpath $PWDPATH
#
clean_cache(){
    local cache_home="${1:-}"
    if [ -z "$cache_home" ] ; then
        fail "no cache_home given"
        return 1
    fi
    local cache_folder="${2:-}"
    if [ -z "$cache_folder" ] ; then
        fail "no cache_folder given"
        return 1
    fi

    if ! [ -d "$cache_home" ] ; then
        fail "invalid cache_home '$cache_home'"
    fi

    local cache_dir="$cache_home/$cache_folder"

    if [ -d "$cache_dir" ] ; then
        rm -rf "$cache_dir"/*
        prn "$cache_dir"
    fi
}
    

main(){

    local opt_quiet=
    while [ $# -gt 0 ] ; do
        case "$1" in
            -h|--help) info "Help: '${SCRIPTNAME%.*}' - $HELP"; die "Usage: $USAGE"  ;;
            -q|--quiet) opt_quiet=1 ;;
            -*) usage ;;
            *) break;;
        esac
    done

    if [ -z "$INPUT_DIR" ] ; then
        info "Err: no input"
        usage
    fi

    local cachedir_input=
    local cachedir_output=
    if [ -n "$CACHE_DIR_XDG" ]; then
        cachedir_input="$CACHE_DIR_XDG/$INPUT_DIR"
        cachedir_output="$(clean_cache "$CACHE_DIR_XDG" "$INPUT_DIR")"  || die "Err: error with clear cache '$cachedir_input'"
    else
        cachedir_input="$CACHE_DIR_ALT/$INPUT_DIR"
        cachedir_output="$(clean_cache "$CACHE_DIR_ALT" "$INPUT_DIR")"  || die "Err: error with clear cache '$cachedir_input'"
    fi

    if [ -n "$cachedir_output" ] ; then
        [ -n "$opt_quiet" ] || echo "OK, cachedir '$cachedir_output' clean"
        exit 0

    else
        [ -n "$opt_quiet" ] || die "Err; '$cachedir_input' not yet existing"
    fi

}


main $@


