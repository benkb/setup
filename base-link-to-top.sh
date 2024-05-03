#!/bin/sh
# link a dir to base/top

HOMEBASE="$HOME/base"
BASEJUMP="$HOMEBASE/jump"

TOPDIR="$HOMEBASE/top"
rm -f "$BASEJUMP/top"
ln -s "$TOPDIR" "$BASEJUMP/top"


warn(){ echo "Warn: $@" >&2; }
info(){ echo "$@" >&2; }
die(){ echo "$@" >&2; exit 1; }

PWDPATH="$(cd "$PWD" >/dev/null; pwd -P)"
PWDNAME="${PWDPATH##*/}"

SCRIPTDIR="$(cd "$(dirname -- "$0")" >/dev/null; pwd -P)"
LIBUTIL="$SCRIPTDIR/libutil.sh"
if [ -f "$LIBUTIL" ] ; then
    . "$LIBUTIL"  || die "Err: could not load libutil under '$LIBUTIL'";
else
    die "Err: could not load libutil under '$LIBUTIL'"
fi

mkdir -p "$TOPDIR"

libutil__link_to_target "$PWD" "$TOPDIR/$PWDNAME"

libutil__link_to_target "$TOPDIR" "$BASEJUMP/top"



