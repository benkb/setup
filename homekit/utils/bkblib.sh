#!/bin/sh
#
prn(){ printf "%s" "$@"; }
info(){ echo "$@" >&2; }
fail(){ echo "Fail: $@" >&2; }
#
######## Bkblib
#
bkblib__stamp(){
    date +'%Y%m%d%H%M%S';
}

bkblib__bkb_getpath(){
    local lib="${1:-}"; local pkg="${2:-}"; local version="${3:-}"
    local lib_str
    case $# in 3) lib_str="$pkg/${lib%.*}/${lib%.*}_${version}.${lib##*.}" ;; 2) lib_str="$pkg/${lib}";; 1) lib_str="${lib}";; esac
    if [ -z "$lib_str" ]; then
        fail  "(libpath): could not set lib_str, wrong number of args"
        return 1
    fi
    local lib_path
    for dir in "${MAINDIR:-}" ${BKBLIB_LIBRARY_PATH:-} "$HOME/.local/bkblib"; do
        if [ -f "$dir/$lib_str" ]; then lib_path="$dir/$lib_str";   BKBLIB_LOADED_LIBS="${lib},${lib_str} ${BKBLIB_LOADED_LIBS:-}"; break ; fi
    done
    if [ -f "${lib_path:-}" ]; then
        prn "${lib_path}"
    else
        fail "(libpath): could not find lib for '$lib' for '$lib_str'  under lib_path '${lib_path:-}'" 
        return 1
    fi
}

_bkblib__bkb_sourcing(){ # for foolib.sh modulino.dash 
    local lib="${1:-}";
    case "${lib:-}" in lib*.sh|*.dash) : ;; *) fail "loadlib: not a valid lib '${lib:-}'"; return 1 ;; esac
    local lib_str
    for l in ${BKBLIB_LOADED_LIBS:-}; do 
        if [ "${l%,*}" = "$lib" ]; then
            if [ "${l##*,}" = "$lib_str" ]; then  return 0; else fail "(_bkblib__source): lib '$lib' loaded,  '$lib_str' not loaded"; return 1; fi
        fi
    done
    local lib_path; lib_path="$(_bkblib__getpath "$@")" || { fail "(_bkblib__source): library not loaded '$lib'" ; return 1; }
    . "$lib_path" || { fail "loadlib: could not source '$lib_path'" ; return 1; }
}

#
bkblib__abspath(){
    local p="${1:-}"
    if [ -z "$p" ] ; then fail "no path given"; return 1; fi
    if ! [ -e "$p" ] ; then fail "no path '$e' not exists"; return 1; fi

    local respath=
    respath="$(readlink -f "$p" 2>/dev/null )" 
    if [ $? -eq 0 ] && [ -n "$respath" ] && [ -e "$respath" ] ; then
            prn "$respath" || return 1 
    else
        if [ -f "$p" ] ; then
            respath="$(cd "$(dirname -- "$p")" 2>/dev/null; pwd -P)"/"${p##*/}"
        elif [ -d "$p" ] ; then
            respath="$(cd "$(dirname -- "$p")" 2>/dev/null; pwd -P)"
        else
            fail "unknown fs type (not a dir/file)"
        fi
        if [ $? -eq 0 ] && [ -n "$respath" ] && [ -e "$respath" ] ; then
            prn "$respath" || return 1 
        else
            fail "Could not get abspath"
        fi
    fi
}

        
        


##  Link something to a target 
# - a file or a dir, or a link
# - copy the link  or symlink depending on the source
#
bkblib__link_to_target(){
    local source="${1:-}"
    if [ -z "$source" ] ; then
        fail " no source"
        return 1
    fi
    local target="${2:-}"
    if [ -z "$target" ] ; then
       info "Err: no target"
       return 1
    fi

    if ! [ -e "$source" ] ; then 
        fail "no valid source '$source'"
        return 1
    fi

    local target_dir="$(dirname "$target")"
    if ! [ -d "$target_dir" ] ; then 
        fail "no valid target_dir '$target_dir'"
        return 1
    fi

    if [ -e "$target" ] ; then
        if ! [ -L "$target" ] ; then 
            fail "target exists and is not a link '$target'"
            return 1
        fi
    fi
    
    rm -f "$target"

    if [ -L "$source" ] ; then
        cp -P "$source" "$target"
    else
        # echo ln -s "$source" "$target"
        ln -s "$source" "$target"
    fi
}
