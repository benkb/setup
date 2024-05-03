# shellcheck shell=sh
# shellcheck disable=SC3043
set -u 

die() { echo "$@" 1>&2; exit 1; }

baselib__main(){
   baselib__fileaction  -l link ~/build/microperl   foo
}


baselib__fileaction() {

   local opt_backup=''
   local opt_postfix=''
   local opt_middlefolder=''
   local opt_log=''
   while [ $# -gt 0 ] ; do
      case "$1" in
         -l|--log) opt_log=1 ;;
         -b|--backup) opt_overwrite=1 ;;
         -p|--postfix) 
            opt_postfix="$2"
            [ -n "$opt_postfix" ] || die "Err: no value for opt_postfix"
            shift ;;
         -m|--middlefolder) 
            opt_middlefolder="${2:-}"
            [ -n "$opt_middlefolder" ] || die "Err: no value for opt_middlefolder"
            shift ;;
         -*) die "Err: invalid opt" ;;
         *) break;;
      esac
      shift
   done

   local action="${1:-}"
   [ -n "$action" ] || die "Err: no action given"

   local source="${2:-}"
   [ -n "$source" ] || die "Err: no source given"

   local target="${3:-}"
   [ -n "$target" ] || die "Err: no target given"

   local target_name="${4:-}"
   local folder="${5:-}"

   [ -d "$source" ] || [ -f "$source" ]  || die "Err(link2j): source '$source' not exitst"

   [ -d "$target" ] || target="$PWD/$target"

   [ -n "$target_name" ] || target_name="$(basename "$source")"


   local target_fullname=''
   if [ -n "$opt_postfix" ] ; then
      local source_dirname="${source%/*}"
      target_fullname="${target_name}${opt_postfix}${source_dirname##*/}"
   else
      target_fullname="$target_name"
   fi

   local target_dirname=''
   if [ -n "$opt_middlefolder" ] ; then
      target_dirname="$target/$opt_middlefolder"
   else
      target_dirname="$target"
   fi

   local target_path="$target_dirname/$target_fullname"

   if [ -f "$target_path" ] ; then
      if [ -n "$opt_backup" ] ; then
         local stamp="$(date +%s)"
         [ -n "$stamp" ] || die "Err: no stamp"
         if [ -n "$opt_log" ] ; then
            echo "mv '$target_path' '${target_path}_${stamp}'"
         else
            mv "$target_path" "${target_path}_${stamp}"
         fi
      else
         if [ -n "$opt_log" ] ; then
            echo "rm -f '$target_path'"
         else
            rm -f "$target_path"
         fi
      fi
   elif [ -d "$target_path" ] ; then
      if [ -L "$target_path" ] ; then
         if [ -n "$opt_log" ] ; then
            echo "rm -f '$target_path'"
         else
            rm -f "$target_path"
         fi
      else
         die "Err: there is already a target folder '$target_path', will not delete"
      fi
   else
      if [ -n "$opt_log" ] ; then
         echo "mkdir -p '$target_dirname'"
      else
         mkdir -p "$target_dirname"
      fi
   fi

   

   case "$action" in
      copy) 
         if [ -L "$source" ] ; then
            if [ -n "$opt_log" ] ; then
               echo "cp -P '$source' '$target_path'"
            else
               cp -P "$source" "$target_path"
            fi
         elif [ -d "$source" ] ; then
            if [ -n "$opt_log" ] ; then
               echo "cp -r '$source' '$target_path'"
            else
               cp -r "$source" "$target_path"
            fi
         else
            if [ -n "$opt_log" ] ; then
               echo "cp  '$source' '$target_path'"
            else
               cp  "$source" "$target_path"
            fi
         fi
         ;;
      link) 
         if [ -L "$source" ] ; then
            if [ -n "$opt_log" ] ; then
               echo "cp -P '$source' '$target_path'"
            else
               cp -P "$source" "$target_path"
            fi
         else
            if [ -n "$opt_log" ] ; then
               echo "ln -s  '$source' '$target_path'"
            else
               ln -s  "$source" "$target_path"
            fi
         fi
         ;;
      move) 
         if [ -n "$opt_log" ] ; then
            echo "mv '$source' '$target_path'"
         else
            mv "$source" "$target_path"
         fi
         ;;
      *) die "Err: invalid path" ;;
   esac
}


[ -n "${MODULINO:-}" ]  ||  baselib__main "$@"

