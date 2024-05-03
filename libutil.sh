#!/bin/sh
#
prn(){ printf "%s" "$@"; }
info(){ echo "$@" >&2; }
fail(){ echo "Fail: $@" >&2; }
#
#
libutil__abspath(){
    local p="${1:-}"
    if [ -z "$p" ] ; then fail "no path given"; return 1; fi
    if ! [ -e "$p" ] ; then fail "no path '$e' not exists"; return 1; fi

    local respath=
    respath="$(readlink -f "$p" 2>/dev/null )" 
    if [ $? -eq 0 ] && [ -n "$respath" ] && [ -e "$respath" ] ; then
            prn "$respath" || return 1 
    else
        if [ -f "$p" ] ; then
            respath="$(cd "$(dirname -- "$p")" >/dev/null; pwd -P)"/"${p##*/}"
        elif [ -d "$p" ] ; then
            respath="$(cd "$(dirname -- "$p")" >/dev/null; pwd -P)"
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
libutil__link_to_target(){
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
