#!/bin/sh

# Template for shell scripts
#
# Usage: [--|- Options] <Command> [args]
#
# Options:
#   --help        show help
#
# Commands:
#   is-up        is tmux running
#   is-inside    is this command called from inside a tmux terminal

prn(){ printf "%s" $@; }
info(){ echo "$@" >&2;  }
die(){ echo "$@" >&2; exit 1; }

help(){ perl -ne 'print "$1\n" if /^\s*#\s+(.*)/; exit if /^\s*[^#\s]+/;' "$0" >&2; }
usage(){ help | grep Usage  ; die "or: --help" ; }


absdir(){ 
    local fso="${1:-}"
    [ -n "$fso" ] || die "Err: no filesystem object (file/dir)"
    if [ -f "$fso" ] ; then (cd "$(dirname "$fso" 2>/dev/null)" && pwd -P)
    elif [ -d "$fso" ] ; then (cd "$fso" 2>/dev/null && pwd -P)
    else die "Err: invalid filesystem object (file/dir) under $fso"
    fi
}


template__main(){
    [ -n "${1:-}" ] || usage

    local cmd
    while [ $# -gt 0 ] ; do
        case "$1" in
            -h|--help) help ; exit 1 ;;
            -*) die "Err: invalid option '$1'";;
            *)  cmd="$1"; shift; break ;;
        esac
        shift
    done 

    [ -n "$cmd" ] || usage

    case "$cmd" in
        one) echo one  "$@";;
        two) echo two  "$@";;
        *) die "Err: invalid command '$cmd'" ;; 
    esac

}



[ -n "${MODULINO:-}" ] || template__main "$@"
