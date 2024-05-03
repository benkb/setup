#/bin/sh
#
set -u

## 

die () { echo "$@" >&2; exit 1; }
info () { echo "$@" >&2;  }
absdir() {
    if [ -f "${1:-}" ] ; then (cd  "$(dirname -- "${1}" 2>/dev/null)";  pwd -P)
    else (cd "${1:-$PWD}" >/dev/null; pwd -P)
    fi
}

##

SCRIPTNAME="${0##*/}"
SCRIPTDIR="$(absdir "$0")"


PWDNAME="${PWD##*/}"
PWDPATH="$(absdir "${PWD}")"

##

LIBUTIL="$SCRIPTDIR"/'libutil.sh'
if [ -f "$LIBUTIL" ] ; then
    . "$LIBUTIL"  || die "Err: could not load libutil under '$LIBUTIL'";
else
    die "Err: could not load libutil under '$LIBUTIL'"
fi


create_parent_dir(){
    local dir="${1:-}"
    [ -n "$dir" ] || die "Err: no target_item"

    local parent_dir="$(dirname "$dir")"

    if [ -e "$parent_dir" ] ; then
        [ -d "$parent_dir" ] || die "Err: target parent somehow exists in '$parent_dir'"
    else
        rm -f "$parent_dir"
        mkdir -p "$parent_dir"
    fi
}


handle_dir(){
    local cwdir="${1:-}"
    [ -n "$cwdir" ] || die "Err: no cwdir"

   [ -d "$cwdir" ] || die "Err: no valid cwdir '$cwdir'"

   local cwdir_abs=
   cwdir_abs="$(libutil__abspath "$cwdir")" || die "Err: could not get abs path"
   

    for i in "$cwdir_abs"/* ; do
      [ -f "$i" ] || [ -d "$i" ] || continue 

        local bi="${i##*/}"
        local target_name="${bi%.*}"

        if [ -d "$i" ] ; then
            # magic: fish-config -> config/fish; HOME.d -> /home/baba
            local target_folder="$(perl -e '($a)=@ARGV; print(join("/", reverse( map { (/^[A-Z]+$/)?$ENV{$_}:$_ } split("-", $a))))' "$target_name")" 

            local target_path=
            case "$target_folder" in
                /*) die "Err: this absolut path makes no sense '$target_folder'" ;;
                */*) 
                    target_path="$HOME/.$target_folder"
                    create_parent_dir "$target_path"
                    ;;
                *)
                    target_path="$HOME/.$target_folder"
            esac

            case "$bi" in
                -*|*-) die "Err: invalid dirname '$bi'" ;;
                *.d|*.dir)   
                    mkdir -p "$target_path" || die "Err: could not create '$target_path'"
                    for ii in "$i"/*; do
                        local bii="${ii##*/}"
                        libutil__link_to_target "$ii" "${target_path}/${bii}"
                    done

                    ;;
               *.l|*.link) 
                   libutil__link_to_target "$i" "$target_path" 
                   ;;
                *.f|*.files) 
                    for ii in "$i"/* ; do
                        local bii="${ii##*/}"
                        libutil__link_to_target "$ii" "${HOME}/.${bii}" 
                    done
                    ;;
                *) 
                    echo "Info: skipping '$bi'" >&2 
                    continue
                    ;;
            esac


        fi
    done
}

handle_dir "$PWD"
