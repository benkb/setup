#!/bin/sh
#
set -u

TMUX_SESS='OUT'

say() { printf '%s' "$@"; printf '\n' ; }
prn() { printf "%s" "$@" ; }
die (){ echo "$@" >&2; exit 1 ; }
info (){ echo "$@" >&2; }

absdir(){ prn "$(cd "$(dirname -- "${1:-}")" >/dev/null; pwd -P)";  }

libvim=
libvim="$(absdir $0 )"/libvim.sh
if [ -f "$libvim" ]; then
    . $libvim
else
    die "Err: could not load libvim"
fi
[ -n "${LIBVIM__TMUX_SESS:-}" ] || die "Err: LIBVIM__TMUX_SESS empty"

echo ssss "${LIBVIM__TMUX_SESS:-}" 

[ -f "$VITASK_FILE" ] || die "Err: no task file '$VITASK_FILE'"

mode="$(perl -ne '/^mode:\s*(.*)/ && print $1' "$vitaskfile")" 


pipe=''
pipe="$(libvim__dir_token_pipe "$PWD")"
[ $? -eq 0 ] && [ -n "$pipe" ] || die "Err: could not get pipefile"


if [ -e $pipe ] ; then
    if [ -p $pipe ] ; then
        if [ $# -eq 0 ]; then
            echo "Hello from Process ID (PID)  $$" >$pipe
        else
            echo "$@" >$pipe
        fi
    else
        die "Err: file is not pipe, which is weird, '$pipe'"
    fi
else

    if tmux has-session -t "$LIBVIM__TMUX_SESS" ; then
        tmux_target_win=''
        tmux_target_win="$(libvim__dir_token "$PWD")" || die "Err: could not get tmux_target_win"
        [ -n "$tmux_target_win" ] || die "Err: could not set tmux_target_win"

        tmux_target_sesswin="$LIBVIM__TMUX_SESS:$tmux_target_win"

        this_sesswin="$(tmux display-message -p '#S:#W')"

        if [ "$this_sesswin" = "$tmux_target_sesswin" ] ; then
            tmux send-keys -t "$tmux_target_sesswin" "sh ./vitask.sh $*" Enter
        else
            die "Err: this is a different session : '$this_sesswin' vs '$tmux_target_sesswin'"
        fi
    else
        die "Err: tmux session '$LIBVIM__TMUX_SESS' is not running, run 'vitmux-start' first "
    fi
fi

