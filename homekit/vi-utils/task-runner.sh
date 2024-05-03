#!/bin/sh
#
set -u

USAGE='<cmd> <file> <linenr>'

TASKDIR="$HOME/tmp/taskout"

prn(){ printf "%s" "$@"; }
info(){ echo "$@" >&2;  }
die(){ echo "$@" >&2; exit 1; }
print_usage(){ die "usage: $USAGE"; }

[ $# -eq 3 ] || print_usage

CMD="${1:-}" ; FILE="${2:-}"; LNR="${3:-}"

[ -d "$TASKDIR" ] || mkdir -p "$TASKDIR" || die "Err: could not create taskout under '$TASKDIR'"
TASK_STDOUT="$TASKDIR/stdout"
TASK_STDERR="$TASKDIR/stderr"

TASK_OUTPUT="$TASKDIR/output"
TASK_ERROR="$TASKDIR/error"

MAINDIR="$(cd $(dirname "$0" 2>/dev/null) && pwd -P)" || die "Err: could not set MAINDIR"
FILEPATH="$MAINDIR/$FILE"

STAMP="$(date +'%Y%m%d%H%M%S')"

cmd_run(){
    sh ./run.sh 2> "$TASK_STDERR" 1> "$TASK_STDOUT"
}

cmd_test(){
    echo test
}

#### Checks
#
[ -f "$FILEPATH" ] || die "Err: FILEPATH '$FILEPATH' not exists"

case "${LNR}" in
    ''|*[!0-9]*) die "Err: lnr '$LNR' not a number";;
    *) :  ;;
esac

case "${CMD}" in
    run) cmd_run ;;
    test) cmd_test ;;
    *) die "Err: invalid command '${1:-}'" ;;
esac

if [ -s "$TASK_STDOUT" ] ; then
    {
        cat "$TASK_STDOUT"
        echo "----"
        echo "$STAMP"
    } > "$TASK_OUTPUT"
fi

if [ -s "$TASK_STDERR" ] ; then
    {
        cat "$TASK_STDERR"
        echo "----"
        echo "$STAMP"
    } > "$TASK_ERROR"
fi

