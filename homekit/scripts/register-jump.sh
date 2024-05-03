set -u

# register the path and its contents of PWD into ~/base/jump

USAGE='-delete foldername'


HOMEBASE="$HOME/base"
BASEJUMP="$HOMEBASE/jump"

PWDBASE="$(basename "$PWD")"
HEREDIR="$(dirname "$0")"

die () { echo "$@" 1>&2; exit 1; }


BASELIB="$HEREDIR/baselib.sh"
if [ -f "$BASELIB" ] ; then
   . "$BASELIB"
else
   die "Err: script '$BASELIB' missing"
fi

baselib__link2target "$PWD" "$BASEJUMP"
baselib__link2target_plus "$PWD" "$BASEJUMP"

for d in "$PWD"/* ; do
   [ -d "$d" ] || continue
   bd="$(basename "$d")"
   baselib__link2target_plus "$d" "$BASEJUMP"
done

