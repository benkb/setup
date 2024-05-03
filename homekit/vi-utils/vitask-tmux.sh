#!/bin/sh
#
# start a server 
#
# TODO: improve exit/trap mechanism 

set -u

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



vitask="$PWD/vitask.sh"
[ -f "$vitask" ] || die "Err: no vitask file in '$vitask'" 

tmux info &> /dev/null || die "Err: tmux server not yet running"
tmux has-session -t "$LIBVIM__TMUX_SESS" || "Err: no vitmux session running '$LIBVIM__TMUX_SESS', please start manually first"


tmux_target_win=''
tmux_target_win="$(libvim__dir_token "$PWD")" || die "Err: could not get tmux_target_win"
[ -n "$tmux_target_win" ] || die "Err: tmux_target_win is empty"

tmux_target_sesswin="${LIBVIM__TMUX_SESS}:${tmux_target_win}"

# check if inside tmux session
# because in iTerm/Tmux , each new tab opens a tmux windows
if [ "$TERM_PROGRAM" = tmux ]; then 
    this_sess=''
    this_sess="$(tmux display-message -p '#S')" || die "Err: could not get session name "
    [ -n "$this_sess" ] || die "Err: session is empty"

    [ "$this_sess" = "$LIBVIM__TMUX_SESS" ] || die "Err: this is in the wrong session, its in '$this_sess', but should be in '$LIBVIM__TMUX_SESS'"

    this_win=''
    this_win="$(tmux display-message -p '#W')" || die "Err: could not get this window name "
    [ -n "$this_win" ] || die "Err: window is empty"


    this_sesswin="${this_sess}:${this_win}"

    if [ "$this_sesswin" = "$tmux_target_sesswin" ] ; then
        say "OK, I'm alreay in the correct tmux session, try vitask-send "
    else
        say "Q: should I rename window from '$this_win' to '$tmux_target_win' [n|Y]?"
        read answ
        case "$answ" in
            n|N|no|No|NO) "Err: Ok leave" ;;
            *) 
                echo tmux rename-window -t "$this_win" "$tmux_target_win"  
                tmux rename-window -t "$this_win" "$tmux_target_win" 
                echo ok
                ;;
        esac
    fi
else
    if tmux has-session -t "$tmux_target_sesswin" ; then
        say "Q: should I attach window from  to '$tmux_target_sesswin' [n|Y]?"
        read answ
        case "$answ" in
            n|N|no|No|NO) "Err: Ok leave" ;;
            *) tmux attach -t "$tmux_target_sesswin"  ;;
        esac
    else
        say "Q: should I create window  '$tmux_target_sesswin' [n|Y]?"
        read answ
        case "$answ" in
            n|N|no|No|NO) "Err: Ok leave" ;;
            *) 
                tmux new-window -t "$LIBVIM__TMUX_SESS" -n "$tmux_target_win" 
                #tmux attach -t "$tmux_target"  ;;
                ;;
        esac
    fi
fi

