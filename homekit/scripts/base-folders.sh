set -u

die() { echo "$@" >&2; exit 1; }

HOMEBASE="$HOME/base"
BASEJUMP="$HOMEBASE/jump"
mkdir -p "$BASEJUMP"


BASEFOLDERS="$HOMEBASE/folders"
mkdir -p "$BASEFOLDERS"

[ -d "$HOMEBASE" ] || die "Err: no  homebase"

for d in $PWD/* ; do
    [ -d "$d" ] || continue

    dbase="${d##*/}"
    dname="${dbase%.*}"

    dwords="$(perl -e '($a)=@ARGV; $a =~ s/[^a-zA-Z0-9]/ /g; print $a; ' "${dname##*/}")"

    for w in $dwords; do
        for f in "$d"/*; do
            fbase="${f##*/}"
            fname="${fbase%%.*}"
            
            case "$fbase" in
                *$w*) 
                    mkdir -p "$BASEFOLDERS/$w"
                    rm -f "$BASEFOLDERS/$w/$fbase"
                    ln -s "$f" "$BASEFOLDERS/$w/$fbase"
                    ;;
                *) : ;;
            esac
        done
    done
done

for d in "$BASEFOLDERS"/* ; do
    [ -d "$d" ] || continue

    dbase="${d##*/}"

    rm -f "$BASEJUMP/$dbase"
    ln -s "$d" "$BASEJUMP/$dbase"
done
