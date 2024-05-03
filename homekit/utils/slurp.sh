#!/bin/sh
#
# slurp - copy a file into clipboard

USAGE='<file>'


set -e

die(){ echo "$@" >&2 ; exit 1; }


file="${1:-}"
[ -f "$file" ] || die "usage: $USAGE " 


os="$(uname | tr '[:upper:]' '[:lower:]')"

case "$os" in
    linux)
        cat "$file" | xclip -sel clip
    ;;
    darwin)
        cat "$file" | pbcopy 
    ;;
    *)
        if [ -z "$os" ] ; then
            die "Err: could not fetch OS"
        else
            die "Err: OS '$os' is not supported yet" 
        fi
        exit 1;
    ;;
esac
