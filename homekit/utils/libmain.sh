#
set -u

# shellcheck shell=sh
# ignore SC3043: 'local' not POSIX
# shellcheck disable=SC3043
#
#echo helloo

#BKB_HOST_HAS_READLINK=
#BKB_HOST_HAS_MD5SUM=
#BKB_HOST_OS=


prn() { printf "%s" "$@"; }
info() { echo "$@" >&2; }
fail() { echo "Fail: $*" >&2; }
stampsec() { date +'%Y%m%d%H%M%S'; }

utils_libmain__get_host_os(){

	if [ -z "${BKB_HOST_OS:-}" ]; then
        local hostos=
        hostos="$(uname -s)" && [ -n "$hostos" ]  ||  {
            fail 'could not run uname -s'
            return 1
        }

        local hostosuc=
        hostosuc="$(prn "$hostos" | tr '[:lower:]' '[:upper:]')" && [ -n "$hostosuc" ]  || {
            fail 'could not run uname -s'
            return 1
        }
        case "${hostosuc}" in
            LINUX|DARWIN|CYGWIN|MINGW|MSYS_NT) 
                BKB_HOST_OS="$hostosuc" 
                prn "$hostosuc"
                ;;
            *) info "Host os not supported '$hostosuc'" ;;
        esac
    else
        prn "$BKB_HOST_OS"
	fi
}

_utils_libmain__lib_check() {
	local mainscript_ext="${1:-}"

	if [ -z "$mainscript_ext" ]; then
		fail "no mainscript_ext"
		return 1
	fi

	local lib_ext="${1:-}"

	if [ -z "$lib_ext" ]; then
		fail "no lib_ext"
		return 1
	fi

	case "$main_script_ext" in
	sh | dash)
		case "$lib_ext" in
		sh | dash) : ;;
		*)
			fail "incompatible script types main('$main_script_ext') vs '$lib_ext'"
			return 1
			;;
		esac
		;;
	bash)
		case "$lib_ext" in
		sh | dash | bash) : ;;
		*)
			fail "incompatible script types main('$main_script_ext') vs '$lib_ext'"
			return 1
			;;
		esac
		;;
	zsh)
		case "$lib_ext" in
		sh | dash | bash | zsh) : ;;
		*)
			fail "incompatible script types main('$main_script_ext') vs '$lib_ext'"
			return 1
			;;
		esac
		;;
	*)
		fail "incompatible script types main('$main_script_ext') vs '$lib_ext'"
		return 1
		;;
	esac
}

_utils_libmain__calc_libstr() {
	local lib_ext="${1:-}"
	if [ -z "$lib_ext" ]; then
		fail 'no lib_ext'
		return 1
	fi
	shift

	local lib="${1:-}"
	local pkg="${2:-}"
	local version="${3:-}"

	local lib_str=
	case $# in
	3) lib_str="${lib_ext}lib/$version/$pkg/${lib}" ;;
	*)
		case $# in
		1) lib_str="${lib}" ;;
		2) lib_str="$pkg/${lib}" ;;
		*)
			fail "wrong number of args many args for lib search "
			return 1
			;;
		esac
		;;
	esac

	prn "$lib_str"
}

_utils_libmain__getlib() {
	local lib_str="${1:-}"
	if [ -z "$lib_str" ]; then
		fail "(get_libpath): no lib_str"
		return 1
	fi

	local lib="${2:-}"
	if [ -z "$lib" ]; then
		fail "(get_libpath): no lib"
		return 1
	fi

	local pkg="${3:-}"
	local version="${4:-}"

	case "$lib" in
	*/*)
		fail "no directory in lib and no whitespace "
		return 1
		;;
	*.pl)
		fail "todo pl"
		return 1
		;;
	*.sh | *.dash | .bash | *.zsh) : ;;
	*)
		fail "invalid lib name '$lib'"
		return 1
		;;
	esac

	local main_script="$0"
	local main_script_ext="${main_script##*.}"
	local lib_name="${lib%.*}"
	local lib_ext="${lib##*.}"

	_utils_libmain__lib_check "$main_script_ext" "$lib_ext"

	local lib_path
	case "$lib_str" in
	*/*/*)
		for libhome in ${BKB_LIBRARY_HOME:-} "$HOME/.bkblib" "$HOME/.local/bkblib"; do
			[ -n "$libhome" ] || continue
			if [ -f "$libhome/$lib_str" ]; then
				lib_path="$libhome/$lib_str"
				break
			fi
		done
		;;
	*)
		if [ -n "${BKB_MODULINO_MAINDIR:-}" ]; then
			if [ -f "$BKB_MODULINO_MAINDIR/$lib_str" ]; then
				lib_path="$BKB_MODULINO_MAINDIR/$lib_str"
			fi
		fi
		;;
	esac

	if [ -z "$lib_path" ]; then
		fail "could not find lib '$lib'"
		return 1
	fi

	if ! [ -f "$lib_path" ]; then
		fail "lib_path not valid '$lib'"
		return 1
	fi

	prn "${lib_path}"
}

utils_libmain__getlib() {
	local lib="${1:-}"
	if [ -z "$lib" ]; then
		fail "(get_libpath): no lib"
		return 1
	fi

	local lib_ext="${lib##*.}"

	local lib_str
	lib_str="$(_utils_libmain__calc_libstr "$lib_ext" $@)"
	if [ -z "$lib_str" ]; then
		fail 'no lib_str'
		return 1
	fi

	_utils_libmain__getlib "$lib_str" $@
}

utils_libmain__loadlib() { # for foolib.sh modulino.dash
	local lib="${1:-}"
	if [ -z "$lib" ]; then
		fail "lib empty"
		return 1
	fi

	local lib_ext="${lib##*.}"

	local lib_str=
	lib_str="$(_utils_libmain__calc_libstr "$lib_ext" $@)"
	if [ -z "$lib_str" ]; then
		fail 'no lib_str'
		return 1
	fi

	for l in ${BKB_SCRIPT_LIBS:-}; do
		if [ "${l%,*}" = "$lib" ]; then
			if [ "${l##*,}" = "$lib_str" ]; then
				echo already
				return 0
			else
				fail "(utils_libmain__loadlib): a lib '$lib' already loaded, but u  '$lib_str' not loaded"
				fail "but under different path ('${l##*,}' / '$lib_str'"
				return 1
			fi
		fi
	done
	local lib_path=
	lib_path="$(_utils_libmain__getlib "$lib_str" "$@")" || {
		fail "(_utils_libmain__source): library not loaded '$lib'"
		return 1
	}

	if [ -z "$lib_path" ]; then
		fail 'no lib_path'
		return 1
	fi
	if ! [ -f "$lib_path" ]; then
		fail "no filepath under lib_path '$lib_path'"
		return 1
	fi

	BKB_SCRIPT_LIBS="${lib},${lib_str} ${BKB_SCRIPT_LIBS:-}"

	. "$lib_path" || {
		fail "loadlib: could not source '$lib_path'"
		return 1
	}
}

#        realp="$(perl -MCwd -e 'print(Cwd::abs_path($ARGV[0]))' "${path}")" || {

_utils_libmain__readlink_shell() {
	local fso="${1:-}"
	if [ -z "$fso" ]; then
		fail "(abspath): no filesystem object (file/dir)"
		return 1
	fi
	if [ -f "$fso" ]; then
		local absd=
		absd="$(
			cd $(dirname "$fso" 2>/dev/null)
			pwd -P
		)" || {
			fail '(absdir file) pwd'
			return 1
		}
		if [ -d "$absd" ]; then
			prn "$absd/${fso##*/}"
			return 0
		else
			fail 'could not get absd'
			return 1
		fi
	elif [ -d "$fso" ]; then
		local absd=
		absd="$(cd "$fso" 2>/dev/null && pwd -P)" || {
			fail '(absdir dir) pwd'
			return 1
		}
		if [ -d "$absd" ]; then
			prn "$absd"
			return 0
		else
			fail 'could not get absd'
			return 1
		fi
	fi
}

utils_libmain__readlink() {
	local fso="${1:-}"
	if [ -z "$fso" ]; then
		fail "(abspath): no filesystem object (file/dir)"
		return 1
	fi

	if [ -z "${utils_libmain__HAS_READLINK:-}" ]; then
        if command -q readlink ; then
			BKB_HOST_HAS_READLINK=1
        else
			BKB_HOST_HAS_READLINK=0
        fi
	fi

	case "${BKB_HOST_HAS_READLINK:-}" in
	1) readlink -f "$fso" ;;
	0)
		_utils_libmain__readlink_shell "$fso" || {
			fail '_bkblib_abspath_shell_ failed'
			return 1
		}
		;;
	*)
		fail 'could not calculate abspath'
		return 1
		;;
	esac
}

utils_libmain__absdir() {
	local fso="${1:-}"
	if [ -z "$fso" ]; then
		fail "(abspath): no filesystem object (file/dir)"
		return 1
	fi

	local absp
	absp="$(bkblib_abspath "$fso")" || {
		fail 'bkblib_abspath failed'
		return 1
	}

	if [ -z "$absp" ]; then
		fail 'absp empty'
		return 1
	fi

	if [ -d "$absd" ]; then
		prn "$absd"
	elif [ -f "$absd" ]; then
		dirname "$absd"
	else
		fail "unknown filetype of fso '$fso'"
		return 1
	fi
}

##  Link something to a target
# - a file or a dir, or a link
# - copy the link  or symlink depending on the source
#
utils_libmain__link_to_target() {
	local source="${1:-}"
	if [ -z "$source" ]; then
		fail "no source"
		return 1
	fi

	local target="${2:-}"
	if [ -z "$target" ]; then
		fail "no target"
		return 1
	fi

	if ! [ -e "$source" ]; then
		fail "no valid source '$source'"
		return 1
	fi

    local target_dir=
    target_dir="$(dirname "$target")" && [ -d "$target_dir" ] ||
		fail "no valid target_dir '$target_dir'"
		return 1
    }

	if [ -e "$target" ]; then
		if ! [ -L "$target" ]; then
			fail "target exists and is not a link '$target'"
			return 1
		fi
	fi

	rm -f "$target"

	if [ -L "$source" ]; then
		cp -P "$source" "$target"
	else
		# echo ln -s "$source" "$target"
		ln -s "$source" "$target"
	fi
}

utils_libmain__is_number() {
	case "${1:-}" in
	'' | *[!0-9]*) die "Err: lnr '${1:-}' not a number" ;;
	*) : ;;
	esac
}

utils_libmain__absdir() {
	local fso="${1:-}"
	if [ -z "$fso" ]; then
		fail "(utils_libmain__absdir):  no filesystem object (file/dir)"
		return 1
	fi
	if [ -f "$fso" ]; then
		(cd "$(dirname "$fso" 2>/dev/null)" && pwd -P)
	elif [ -d "$fso" ]; then
		(cd "$fso" 2>/dev/null && pwd -P)
	else
		fail "(utils_libmain__absdir): invalid filesystem object (file/dir) under $fso"
		return 1
	fi
}

utils_libmain__md5sum() {
	local string="${1:-}"
	if [ -z "$string" ]; then
		fail "(utils_libmain__md4sum): no string given"
		return 1
	fi

	if [ -z "${utils_libmain__HAS_MD5SUM:-}" ]; then
        if command -q md5sum ; then
			BKB_HOST_HAS_MD5SUM=1
        else
			BKB_HOST_HAS_MD5SUM=0
        fi
	fi


	local md5str=
	case "${BKB_HOST_HAS_MD5SUM:-}" in
	1)
		md5str="$(prn "$string" | md5sum | cut -f1 -d" ")" && [ -n "$md5str" ] ||  {
			fail "(m5sum): could not run shell commands"
			return 1
		}
		;;

	0)
		md5str="$(perl -MDigest::MD5 -e 'print(Digest::MD5::md5_hex($ARGV[0]))' "$string")" && [ -n "$md5str" ] || {
			fail "(md5sum) could not run perl command"
			return 1
		}
		;;
	*)
		fail 'could not calculate md5sum'
		return 1
		;;
	esac

	if [ -n "$md5str" ]; then
		prn "$md5str"
	else
		fail "bkblib_md5sum: could not get md5sum from string '$string'"
		return 1
	fi
}

#utils_libmain__get_host_os
