#!/bin/sh
#
# check with `checkbashisms --posix` or with `posh`
#
set -u

HELP='A simple shell script template, possibly posix compatible'

USAGE='[-h|--help] [-v|--verbose] <file-input> [target-dir]'

FILE_INPUT=
TARGET_DIR=

prn(){ printf "%s" "$@"; }
info(){ echo "$@" >&2;  }
warn(){ echo "Warn: $@" >&2;  }
die(){ echo "$@" >&2; exit 1; }
stamp() { date +'%Y%m%d%H%M%S'; }
absdir() {
    if [ -f "${1:-}" ] ; then (cd "$(dirname -- "${1}" >/dev/null)"; pwd -P)
    else (cd "${1:-$PWD}" >/dev/null; pwd -P)
    fi
}
init_script_vars(){
    SCRIPTBASE="${0##*/}"
    SCRIPTNAME="${SCRIPTBASE%.*}"
    SCRIPTDIR="$(absdir "$0")" || { warn "no SCRIPTDIR" ; return 1;  }
}
init_pwd_vars(){
    PWDBASE="${PWD##*/}"
    PWDPATH="$(absdir "$PWD")" || { warn "no PWDPATH" ; return 1; }
}

create_new_output_dir(){
    local dir="${1:-}"
    if [ -z "$dir" ] ; then
        warn 'no dir'
        return 1
    fi
    if [ -d "$dir" ] ; then
        warn "dir '$dir' already exists"
        return 1
    else
        mkdir -p "$dir"
    fi
}


OPT_VERBOSE=
while [ $# -gt 0 ] ; do
    case "${1}" in
        -h|--help) echo "$HELP" >&2; die "Usage: $USAGE" >&2 ;;
        -v|--verbose) OPT_VERBOSE=1;;
        -*) die "Err: invalid opt $1, run --help";;
        *) break;;
    esac
    shift
done

FILE_INPUT="${1:-}"
TARGET_DIR="${2:-}"

[ -n "$FILE_INPUT" ] || die "Usage: $USAGE" 
[ -f "$FILE_INPUT" ] || die "Err: need a valid file"

if [ -n "$TARGET_DIR" ] ; then
    [ -d "$TARGET_DIR" ] || die "Err: target dir not exists '$TARGET_DIR'" 
fi

# maybe there are compresession formats that need an output dir, no matter what
# in order to prohibit to decompress all over the place
# TARGET_DIR="$(absdir "$TARGET_DIR_DEFAULT")" || die "Err: could not init 'TARGET_DIR'"
# target_path="$TARGET_DIR/$input_name"

input_base="${FILE_INPUT##*/}"
input_name="${input_base%.*}"
input_ext="${input_base##*.}"
    
case "$input_base" in
    *.tar*) 
        case "$input_ext" in
            tar) tar_opt=xvf ;;
            gz) tar_opt=xvzf ;;
            tgz) tar_opt=xvzf ;;
            bz2) tar_opt=xvjf ;;
            xz) tar_opt=xvJf ;;
            tbz2)  tar_opt=xvjf ;;
            *) die "Err: invalid tar extension '$input_ext'" ;;
        esac
        tar $tar_opt "$FILE_INPUT"
        ;;

    *.lzma)      unlzma "$FILE_INPUT"      ;;
    *.bz2)       bunzip2 "$FILE_INPUT"     ;;
    *.rar)       unrar x -ad "$FILE_INPUT" ;;
    *.gz)        gunzip "$FILE_INPUT"      ;;
    *.zip)       unzip "$FILE_INPUT"       ;;
    *.Z)         uncompress "$FILE_INPUT"  ;;
    *.7z)        7z x "$FILE_INPUT"        ;;
    *.xz)        unxz "$FILE_INPUT"        ;;
    *.exe)       cabextract "$FILE_INPUT"  ;;
    *)           echo "extract: '$input_ext' - unknown archive method" ;;
esac


if [ $? -eq 0 ] ; then
    echo "OK: unpacking worked "
else
    die "Err: unpacking failed"
fi





