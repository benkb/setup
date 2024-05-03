# shellcheck shell=sh
# ignore SC3043: 'local' not POSIX
# shellcheck disable=SC3043
#
set -u


LIBSTD__HAS_REALPATH="$(command -v realpath)"
LIBSTD__HAS_MD5SUM="$(command -v md5sum)"

prn() { printf "%s" "$@"; }
fail() { printf "Fail %s\n" "${1:-}" 1>&2; }

libstd__hello() {
    local res
    if res="$(libstd__md5sum 'gagatest')" ; then
		echo "Hello from stdlib, test successfully '$res'"
	else
		fail "(hello): cmd fuailed"
		return 1
	fi

}

libstd__is_number(){
    case "${1:-}" in
        ''|*[!0-9]*) die "Err: lnr '${1:-}' not a number";;
        *) :  ;;
    esac
}

libstd__absdir() {
	local fso="${1:-}"
    if [ -z "$fso" ]; then
		fail "(libstd__absdir):  no filesystem object (file/dir)"
		return 1
    fi
	if [ -f "$fso" ]; then
		(cd "$(dirname "$fso" 2>/dev/null)" && pwd -P)
	elif [ -d "$fso" ]; then
		(cd "$fso" 2>/dev/null && pwd -P)
	else
		fail "(libstd__absdir): invalid filesystem object (file/dir) under $fso"
		return 1
	fi
}

libstd__realpath() {
	local path="${1:-}"
	if [ -z "$path" ]; then
		fail "(libstd__realpath): no path given"
		return 1
    fi

    local realp
	if [ -n "${LIBSTD__HAS_REALPATH:-}" ]; then
        realp="$(realpath "$path")" || {
			fail "(realpath): could not run realpath"
			return 1
		}
	else
        realp="$(perl -MCwd -e 'print(Cwd::abs_path($ARGV[0]))' "${path}")" || {
            fail "(realpath): could not run perl realpath"
            return 1
        }
	fi
    if [ -n "$realp" ]; then
        prn "$realp"
    else
        fail "libstd_md5sum: could not get md5sum from string '$string'"
        return 1
    fi
}

libstd__md5sum() {
	local string="${1:-}"
	if [ -z "$string" ]; then
		fail "(libstd__md4sum): no string given"
		return 1
    fi

	if [ -n "${LIBSTD__HAS_MD5SUM:-}" ]; then
        local md5str
		md5str="$(prn "$string" | md5sum | cut -f1 -d" " || {
			fail "(m5sum): could not run shell commands"
			return 1
		})"
	else
        md5str="$(perl -MDigest::MD5 -e 'print(Digest::MD5::md5_hex($ARGV[0]))' "$string")" || {
			fail "(md5sum) could not run perl command"
			return 1
		}
	fi
    if [ -n "$md5str" ]; then
        prn "$md5str"
    else
        fail "libstd_md5sum: could not get md5sum from string '$string'"
        return 1
    fi
}

libstd__absdir(){ 
    local fso="${1:-}"
    if [ -z "$fso" ]; then fail "(absdir): no filesystem object (file/dir)"; return 1; fi

    local abspath abspath="$(readlink -f "$fso")"
    local absd
    if [ -n "$abspath" ] ; then
        if [ -f "$abspath" ] ; then absd="$(dirname "$abspath")" || { fail '(absdir); dirname fail'; return 1; }
        elif [ -d "$abspath" ] ; then absd="$abspath" 
        fi
    else
        if [ -f "$fso" ] ; then absd="$(cd $(dirname "$fso" 2>/dev/null) && pwd -P)" || { fail '(absdir file) pwd'; return 1; }
        elif [ -d "$fso" ] ; then absd="$(cd "$fso" 2>/dev/null && pwd -P)" || { fail '(absdir dir) pwd'; return 1; }
        fi
    fi
    if [ -n "$absd" ] ; then prn "$absd"
    else
        fail "(absdir) could not get absdir for '$fso'"
        return 1
    fi
}
#libstd__hello
