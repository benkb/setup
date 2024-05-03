set -u

INPUT="${1:-}"

USAGE='-delete foldername'


HOMEBASE="$HOME/base"
BASEJUMP="$HOMEBASE/jump"

PWDBASE="$(basename "$PWD")"
HEREDIR="$(dirname "$0")"

die () { echo "$@" 1>&2; exit 1; }

delete_folder=''
while [ $# -gt 0 ] ; do
   case "$1" in
      -reset) 
         if [ -n "${2:-}" ] ; then
            delete_folder="${2}"
            shift
         else
            die "Err: not enough args for -reset"
         fi
         ;;
      -h|-help|--help) die "usage: $USAGE" ;;
      -*) die "Err: invalid option" ;;
      *) break ;;
   esac
   shift 
done

BASELIB="$HEREDIR/baselib.sh"
if [ -f "$BASELIB" ] ; then
   . "$BASELIB"
else
   die "Err: script '$BASELIB' missing"
fi

if [ -n "$delete_folder" ] ; then
   rm -rf "$HOMEBASE/$delete_folder"
   rm -f "$BASEJUMP/$delete_folder"
fi

mkdir -p "$BASEJUMP"
baselib__link2target "$PWD" "$BASEJUMP"
baselib__link2target "$BASEJUMP" "$HOMEBASE" 'j'
baselib__link2target "$HOMEBASE" "$BASEJUMP" 'b'
baselib__link2target "$HOMEBASE" "$BASEJUMP" 'base'


regex='$ARGV[0]=~ /^(\w+)-\w+$/ && print $1'

myfolder=
myfoldertarget=

foldername=
if [ -n "$INPUT" ] ; then
   foldername="$INPUT"
else
   foldername="$PWDBASE"
fi

case "$foldername" in 
   *-*-*)
      echo "Err: base folder $foldername does not have the correct form -...-..-.."
      exit 1
      ;;
   *-*) 
      myfolder="$(perl -e '$ARGV[0]=~ /^(\w+)-\w+$/ && print $1' "$foldername")"
      myfoldertarget="$(perl -e '$ARGV[0]=~ /^\w+-(\w+)$/ && print $1' "$foldername")"
      ;;

   *) 
      echo "Err:  foldername '$foldername' not a dashed folder"
      exit 1
      ;;
esac

[ -n "$myfolder" ] || die "Err: no myfolder" 
[ -n "$myfoldertarget" ] || die "Err: no foldertarget"

mkdir -p "$HOMEBASE/$myfolder"
baselib__link2target "$PWD" "$HOMEBASE/$myfolder" "$myfoldertarget"

baselib__link2target "$HOMEBASE/$myfolder" "$BASEJUMP"

baselib__link2target "$PWD" "$BASEJUMP" "$myfoldertarget-$myfolder"

if [ -f 'favorites.txt' ] ; then
   while read ln; do
      favdir="$PWD/$ln"
      if [ -d "$favdir" ] ; then
         baselib__link2target "$favdir" "$HOMEBASE"
         baselib__link2target "$favdir" "$BASEJUMP"
      else
         echo "Warn: favorite $ln not exists"
      fi
   done <'favorites.txt'
fi

echo ok
