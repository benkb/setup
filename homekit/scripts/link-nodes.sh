set -u

die () { echo "$@" ; exit 1; }

sourcedir="${1:-}"
targetdir="${2:-}"

[ -n "$sourcedir" ] || die "Err: no sourcedir"
[ -d "$sourcedir" ] || die "Err: sourcedir no dir"


[ -n "$targetdir" ] || targetdir="$HOME/base/nodes"
[ -d "$targetdir" ] || die "Err: targetdir no dir"


# cloud01-clone_ben_drive01_maestral-dropbox

for d in "$sourcedir"/* ; do
   [ -d "$d" ] || continue
   bd="$(basename "$d")"
   case "$bd" in 
      *_*_*_*_*) continue ;;
      **.*.*.*) continue ;;
      *.*.*) node="$bd" ;;
      *_*_*_*) 
         node="$(perl -e 'if ($ARGV[0] =~ /^([^_]+)_([^_]+)_[^_]+_([^_]+)$/){ print("$1.$2.$3")}' "$bd")";;
      *) continue ;;
   esac

   if [ -n "$node" ] ;then
      echo ln -s "$d" "$targetdir"/"$node"
      rm -f "$targetdir"/"$node"
      ln -s "$d" "$targetdir"/"$node"
   else
      echo "Warn: omit '$d'"
   fi
done
