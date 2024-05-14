#!/bin/sh

# Template for shell scripts
#
# Shell scripts that also can be used as modules/libraries for other scripts.
# When used as libraries this is how its done:
#
#
#
# Usage: [Options] [filter] [filename] [extension]
#
# Options:
#   --help          show help
#   -w|--write      write to file (with a .sh extension)
#

set -u

prn() { printf "%s" "$@"; }
fail() { echo "Fail: $*" >&2; }
info() { echo "$@" >&2; }
die() {
	echo "$@" >&2
	exit 1
}
stamp() { date +'%Y%m%d%H%M%S'; }

main() {

	local usage_script='die "$1\n" if /^#\s+(Usage:.*)$/'
	while [ $# -gt 0 ]; do
		case "$1" in
		-h | --help)
			perl -ne 'print "$1\n" if /^\s*#\s+(.*)/; exit if /^\s*[^#\s]+/;' "$0" >&2
			perl -ne "$usage_script" "$0" >&2
			exit 1
			;;
		-*)
			perl -ne "$usage_script" "$0" >&2
			exit 1
			;;
		*) break ;;
		esac
		shift
	done

    local os
    os="$(uname | tr '[:upper:]' '[:lower:]')" ||  die 'could no get os'

    if [ -z "$os" ] ; then die 'could not get os'; fi

    case "$os" in
        darwin) 
            prn "$PWD" | pbcopy && prn "$PWD"
            ;;
        *)
            die "Err: todo cwdcopy fo ros '$os'"
            ;;
    esac
}

main "$@" || "Abort ..."
