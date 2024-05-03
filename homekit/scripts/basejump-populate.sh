#!/bin/sh
#

HOMEBASE="$HOME/base"
BASEJUMP="$HOMEBASE/jump"

#PWDNAME="${PWD##*/}"

prn(){ printf "%s" "$@"; }
fail(){ echo "Fail: $@" >&2; }
info(){ echo "$@" >&2; }
die(){ echo "$@" >&2; exit 1; }

LIBUTIL="$(cd "$(dirname -- "$0")" >/dev/null; pwd -P)"/'libutil.sh'
if [ -n "${LIBUTIL:-}" ] ; then
    if [ -f "$LIBUTIL" ] ; then
        . "$LIBUTIL"  || die "Err: could not load libutil under '$LIBUTIL'";
    else
        die "Err: could not load libutil under '$LIBUTIL'"
    fi
fi
#PWDPATH="$(cd "$PWD" >/dev/null; pwd -P)"

mkdir -p "$BASEJUMP"


for fso in $HOME/.*; do
    [ -e "$fso" ] || continue

    fsod="${fso%/*}"
    fsob="${fso##*/}"

    [ "$fsod" = "$fsob" ] && {
        echo "something wrong with '$fso'"
        continue
    }
    
    case "$fsob" in
        .|..) echo "Invalid fsob '$fsob', skipping " 
            continue
            ;;
        $fsod)
            echo "something wrong with '$fso' ('$fsob' vs '$fsod'), skipping"
            continue
            ;;
        *)
    esac

    libutil__link_to_target "$fso" "$BASEJUMP/$fsob"

done


mkdir -p "$BASEJUMP"/home
for fso in $HOME/*; do
    [ -e "$fso" ] || continue

    fsod="${fso%/*}"
    fsob="${fso##*/}"
    
    [ "$fsod" = "$fsob" ] && {
        echo "something wrong with '$fso'"
        continue
    }

    case "$fsob" in
        [A-Z]*) libutil__link_to_target "$fso" "$BASEJUMP/home/$fsob" ;;
        *) : ;;
    esac
done


for d in "$HOMEBASE"/*; do
    [ -d "$d" ] || continue
    bd="${d##*/}"
    ad="$(libutil__abspath "$d")" || die "Err: could not get abspath of $d"

    case "$bd" in 
        jump|j) continue ;;
        top)
            for dd in "$d"/*; do
                [ -d "$dd" ] || continue
                add="$(libutil__abspath "$dd")" || die "Err: could not get abspath of $dd"
                bdd="${dd##*/}"
                

                case "$bdd" in
                    *.*.*) die "Err: please only one '-' dir '$bdd'" ;;
                    *.*)
                        topfolder="${bdd%.*}s"
                        mkdir -p "$BASEJUMP/$topfolder"
                        libutil__link_to_target "$dd" "$BASEJUMP/$topfolder/$bdd"

                        acclvl="${bdd##*.}"
                        #"$(echo "${PWDNAME%.*}"s | tr '[:upper:]' '[:lower:]')"
                        for ddd in "$add"/* ; do 
                            [ -d "$ddd" ] || continue
                            addd="$(libutil__abspath "$ddd")" || die "Err: could not get abspath of $ddd"
                            bddd="${ddd##*/}"
                            linkname="$bddd.$acclvl"
                            libutil__link_to_target "$addd" "$BASEJUMP/$linkname"
                        done
                        ;;
                    *) die "Err: no dash dirname '$bdd'";;
                esac
            done
            ;;
        *) 
            for dd in "$d"/*; do
                [ -d "$dd" ] || continue
                add="$(libutil__abspath "$dd")" || die "Err: could not get abspath of $dd"
                bdd="${dd##*/}"
                libutil__link_to_target "$add" "$BASEJUMP/$bdd"
            done
            ;;
    esac

    libutil__link_to_target "$ad" "$BASEJUMP/$bd"

done
        

