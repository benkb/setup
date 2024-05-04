#!/bin/sh

# untar - unpack compressed files
#
# Usage: [Options] [filename]
#
# Options:
#   --help          show help
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


unpack__file(){
    local input_file="${1:-}"
    if [ -z "$input_file" ] || ! [ -f "$input_file" ] ; then
        fail "invalid input file under '$input_file'"
        return 1
    fi

    local input_base="${input_file##*/}"
    local input_name="${input_base%.*}"
    local input_ext="${input_base##*.}"

    case "$input_base" in
    *.tar*)
        local tar_opt=
        case "$input_ext" in
            tar) tar_opt=xvf ;;
            gz) tar_opt=xvzf ;;
            tgz) tar_opt=xvzf ;;
            bz2) tar_opt=xvjf ;;
            xz) tar_opt=xvJf ;;
            tbz2) tar_opt=xvjf ;;
        *) die "Err: invalid tar extension '$input_ext'" ;;
        esac
        tar $tar_opt "$input_file"
        ;;

    *.lzma) unlzma "$input_file" ;;
    *.bz2) bunzip2 "$input_file" ;;
    *.rar) unrar x -ad "$input_file" ;;
    *.gz) gunzip "$input_file" ;;
    *.zip) unzip "$input_file" ;;
    *.Z) uncompress "$input_file" ;;
    *.7z) 7z x "$input_file" ;;
    *.xz) unxz "$input_file" ;;
    *.exe) cabextract "$input_file" ;;
    *) echo "extract: '$input_ext' - unknown archive method" ;;
    esac
}



unpack__main() {
	local usage_pl='die "$1\n" if /^#\s+(Usage:.*)$/'
	local help_pl='print "$1\n" if /^\s*#\s+(.*)/; exit if /^\s*[^#\s]+/;'

	while [ $# -gt 0 ]; do
		case "$1" in
		-h | --help)
			perl -ne "$help_pl" "$0" >&2
			exit 1
			;;
		-*)
			info "unknown option"
			perl -ne "$usage_pl" "$0" >&2
			exit 1
			;;
		*) break ;;
		esac
		shift
	done

	if [ $# -gt 0 ]; then
        unpack__file "$1"
	else
		perl -ne "$usage_pl" "$0" >&2
		exit 1
	fi



    if [ $? -eq 0 ]; then
        echo "OK: unpacking worked "
    else
        die "Err: unpacking failed"
    fi

}

unpack__main "$@" 
