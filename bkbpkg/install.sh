




BASEJUMP=$HOME/base/jump

mkdir -p "$BASEJUMP"


rm -f ~/.bkbpkg
ln -s $PWD ~/.bkbpkg

rm -f "$BASEJUMP"/.bkbpkg
ln -s $PWD "$BASEJUMP"/.bkbpkg


