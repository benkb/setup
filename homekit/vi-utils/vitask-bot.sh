#!/bin/sh
#
# start a server 
#
# TODO: improve exit/trap mechanism 

set -u

trap clean_trap INT
trap clean_trap EXIT

say() { printf '%s' "$@"; printf '\n' ; }
prn() { printf "%s" "$@" ; }
die (){ echo "$@" >&2; exit 1 ; }
info (){ echo "$@" >&2; }
absdir(){ prn "$(cd "$(dirname -- "${1:-}")" >/dev/null; pwd -P)";  }

pipe=''
clean_trap () { 
    echo "trap: cleaning"

    [ -d "$pipe" ] && info "Warn: pipe looks like a directory" 
    [ -e "$pipe" ] && rm -f $pipe 
    info "Info: exiting trap"
}

libvim=
libvim="$(absdir $0 )"/libvim.sh
if [ -f "$libvim" ]; then
    . $libvim
else
    die "Err: could not load libvim"
fi

pipe="$(libvim__dir_token_pipe "$PWD")" || die "Err: could not get pipe name"
[ -n "$pipe" ] || die "Err: could not get pipefile"


if [ -e "$pipe" ]; then
    say "Question : there is already a pipe file under '$pipe'"
    say "Would you like to delete [N|y]?"
    read answ
    case "$answ" in
        y|Y|yes|YES|Yes) rm -f "$pipe" ;;
        *) die "Err: there is already a pipefile under '$pipe'" ;;
    esac
fi

[ -p $pipe ] || mkfifo $pipe

[ -p $pipe ] || die "Err: could not start pipe '$pipe'"

vitask="$PWD/vitask.sh"

handle_vitask(){
    local line="${1:-}"
    [ -n "$line" ] || die "Err: no line given"

    [ -f "$vitask" ] || die "Err: no vitask file in '$vitask'" 

    case "$line" in
        virun:*|vitest:*) 
            echo "> $line"
            sh "$vitask" $line
            echo '----------'
            ;;
        *) die "Err: '$line' unknown vitask " ;;
    esac
}

handle_botcmd(){
    local line="${1:-}"
    [ -n "$line" ] || die "Err: no line given"

    case "$line" in
        :info) 
            say "pipe file: $pipe"
            ;;
        :quit) die "Quit";;
        :help)
            say "Help:"
            say "   quit with :quit" 
        ;;
    *) die "Err: '$line' unknown command" ;;
    esac
}

echo "Start server on $PWD , quit with :quit, more bot-cmds under :help"
while true; do
    if [ -p "$pipe" ] ; then
        if read line <$pipe; then
            case "$line" in
                :*) handle_botcmd "$line";;
                vi*:*) handle_vitask "$line" ;;
                *) echo "echo (:help) line '$line' " ;;
            esac
        fi
    else
        die "Err: no or no valid pipe under '$pipe'"
    fi
done

echo "Reader exiting"
exit
