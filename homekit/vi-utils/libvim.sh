# shellcheck shell=sh
# ignore SC3043: 'local' not POSIX
# shellcheck disable=SC3043

set -u

HOMEKIT=$HOME/kit

LIBVIM__PIPE_EXT='.vipipe'
LIBVIM__TMUX_SESS='VIOUT'
VITASK_FILE='vitask.conf'

say() { printf '%s' "$@"; printf '\n'; }
prn() { printf "%s" "$@"; }
die() { echo "$@"; exit 1; }

_absdir() { prn "$(
	cd "$(dirname -- "${1:-}")" >/dev/null
	pwd -P
)"; }

libstd="$HOMEKIT/shutils/libstd.sh"
if [ -f "$libstd" ]; then
    . "$libstd"
else
    _die "Err: no lib under '$libstd'"
fi

libvim__vitask_mode(){
    mode="$(perl -ne '/^mode:\s*(.*)/ && print $1' "${1:-}")"
}

libvim__dir_token() {
	local dir="${1:-}"
	[ -n "$dir" ] || _die "Err: no dir"

    local absdir
    absdir="$(_absdir "$dir")" || die "Err: could not get absdir"
    [ -n "$absdir" ] || die "Err: absdir empty"

    local dirname=
    dirname="$(perl -e '($a)=@ARGV; $a =~ s/[^A-Za-z0-9]+/_/g; print $a;' "${dir##*/}")"

	local token
	token="$(libstd__md5sum "$absdir")" || die "Err: could not get md5sum"
    [ -n "$token" ] || die "Err: token is empty"

	prn "${dirname}-${token}"
}

libvim__dir_token_pipe() {
	local dir="${1:-}"
	[ -n "$dir" ] || _die "Err: no dir"

    local dir_token
    dir_token="$(libvim__dir_token "$dir")" || die "Err: could not get dir_token"
    [ -n "$dir_token" ] || die "Err: dir_token empty"

	[ -n "${LIBVIM__PIPE_EXT}" ] || die "Err: LIBVIM__PIPE_EXT empty"
	prn "${dir_token}${LIBVIM__PIPE_EXT}"
}

