




BASEJUMP=$HOME/base/jump

mkdir -p "$BASEJUMP"


rm -f ~/.bkblib
ln -s $PWD ~/.bkblib

rm -f "$BASEJUMP"/.bkblib
ln -s $PWD "$BASEJUMP"/.bkblib


