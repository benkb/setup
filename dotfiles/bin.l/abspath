#!/bin/sh
# 
# show real resolved path
#
#
#
[ $# -eq 1 ] || {
   echo "usage <path>" 1>&2 
   exit 1
}

if type realpath > /dev/null 2>&1; then
   realpath "$1"
else
   perl -MCwd -e 'print(Cwd::abs_path(readlink $ARGV[0]))' "$1" 
fi
