#!/bin/sh

USAGE='<cmd> <file> <linenr>'


prn(){ printf "%s" "$@"; }
info(){ echo "$@" >&2;  }
die(){ echo "$@" >&2; exit 1; }
print_usage(){ die "usage: $USAGE"; }

MAINDIR="$(cd $(dirname "$0" 2>/dev/null) && pwd -P)" || die "Err: could not set MAINDIR"

CMD="${1:-}" ; FILE="${2:-}"; LNR="${3:-}"

FILEPATH="$MAINDIR/$FILE"

[ -f "$FILEPATH" ] || die "Err: FILEPATH '$FILEPATH' not exists"

cmd_run(){
    echo run 
}

cmd_test(){
    echo test
}

[ $# -eq 3 ] || print_usage

case "$1" in
    run) cmd_run ; break ;;
    test) cmd_test; break ;;
    *) die "Err: invalid command '${1:-}'" ;;
esac

