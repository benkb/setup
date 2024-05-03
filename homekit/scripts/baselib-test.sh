#!/bin/sh

set -u

baselib_sh="$HOME/.$USER/shlib/baselib/baselib_v20240321.sh"

if [ -f "$baselib_sh" ] ; then
   MODULINO=1 && . "$baselib_sh"
else
   die "Err: could not load baselib '$baselib_sh', install dotfiles first"
fi


