

basejump=$HOME/base/jump

mkdir -p "$basejump"

rm -f "$HOME/kit" 
ln -s "$PWD" "$HOME/kit"

rm -f "$basejump/homekit" 
ln -s "$PWD" "$basejump/homekit"
