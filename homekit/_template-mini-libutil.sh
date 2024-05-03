#!/bin/sh

HELP='A simple template that gets libutil script'

USAGE='<option>'

# Template for shell scripts
#
# Shell scripts that also can be used as modules/libraries for other scripts.
# When used as libraries this is how its done:
# - First: set the the MODULINO=1
#
#
#
# Usage: [Options] <Command> [args]
#
# Options:
#   --help      show help
#
# Commands:
#   hello        say hello
#   one         say one
#   two         say two

set -u

SCRIPTNAME="${0##*/}"
PWDNAME="${PWD##*/}"

prn(){ printf "%s" "$@"; }
fail(){ echo "Fail: $@" >&2; }
info(){ echo "$@" >&2; }
die(){ echo "$@" >&2; exit 1; }
usage(){ die "Usage - ${SCRIPTNAME%.*}: $USAGE" ; }
stamp() { date +'%Y%m%d%H%M%S'; }
help(){ perl -ne 'print "$1\n" if /^\s*#\s+(.*)/; exit if /^\s*[^#\s]+/;' "$0"; }
usage(){ help | grep Usage 1>&2 ; die "or: --help" ; }
this_second() { date +'%Y%m%d%H%M%S' ; }

template__init(){
    _bkblib__source 'libstd.sh'
}


 init(){
     SCRIPTBASE="${0##*/}"
     SCRIPTNAME="${SCRIPTBASE%.*}"
     SCRIPTDIR="$(cd $(dirname "$0" 2>/dev/null) && pwd -P)" || die "Err: could not set SCRIPTDIR"
    [ -n "$SCRIPTDIR" ] || die "Err: SCRIPTDIR is empty"
 }

init_script_vars(){
    SCRIPTBASE="${0##*/}"
    SCRIPTNAME="${SCRIPTBASE%.*}"
    SCRIPTDIR="$(absdir "$0")" || { warn "no SCRIPTDIR" ; return 1;  }
}
init_pwd_vars(){
    PWDBASE="${PWD##*/}"
    PWDPATH="$(absdir "$PWD")" || { warn "no PWDPATH" ; return 1; }
}


#### LIBUTIL
LIBUTIL="$(cd "$(dirname -- "$0")" 2>/dev/null; pwd -P)"'/libutil.sh'
if [ -n "${LIBUTIL:-}" ] ; then
    [ -f "$LIBUTIL" ] ||  die "Err: could not load libutil under '$LIBUTIL'"
    . "$LIBUTIL"  || die "Err: could not load libutil under '$LIBUTIL'";
    PWDPATH="$(libutil__abspath "$PWD")"
fi
####
#

#echo pwdpath $PWDPATH

main(){
    while [ $# -gt 0 ] ; do
        case "$1" in
            -h|--help) info "Help: '${SCRIPTNAME%.*}' - $HELP"; die "Usage: $USAGE"  ;;
            -*) usage ;;
            *) break;;
        esac
    done
}


main $@




######## Modulino

if [ -z "${MAINDIR:-}" ] ; then
    MAINDIR="$(cd $(dirname "$0" 2>/dev/null) && pwd -P)" || die "Err: could not set MAINDIR"
    [ -d "$MAINDIR" ] || die "Err: no valid MAINDIR with '$MAINDIR'"
######## Script
    template__init || die "Err: (template__init): could not init, imports failed, or not a modulino"
    template__main "$@"
########
else
    template__init || {
        fail "(template__init): could not init, imports failed or not a modulino"
        return 1
    }
fi
