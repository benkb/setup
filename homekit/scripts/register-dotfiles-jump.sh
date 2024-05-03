

set -u

SCRIPTDIR="$(dirname "$(cd "$(dirname "$0")"; pwd)/$(basename "$0")")"

die () { echo "$@" ; exit 1; }

install_dotfiles="$HOME/base/dotfiles0/install-dotfiles.sh"
[ -f "$install_dotfiles" ] || echo "Err: could not install dotfiles, no script in '$install_dotfiles'"

register_jump="$SCRIPTDIR/register-jump.sh"
[ -f "$register_jump" ] || die "Err: could not install to jump, no script in '$register_jump'"

sh "$install_dotfiles"

sh "$register_jump"
