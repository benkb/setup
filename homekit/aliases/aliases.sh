test -f "$HOME/build/mrsh/mrsh/build/mrsh" && alias mrsh="$HOME/build/mrsh/mrsh/build/mrsh"

test -f "$HOME/dev/benkb-pub/sew/sew.git/sew.sh" && alias sew='sh $HOME/dev/benkb-pub/sew/sew.git/sew.sh'

test -f "$HOME/.bin/millw.sh" && alias millw="/usr/bin/env dash $HOME/.bin/millw.sh"

test -d "$HOME/build/lobster" &&  export PATH="$HOME/build/lobster/bin:$PATH"
alias ,shfmt='shfmt -i 4 -w'
# dir constants
#
#echo loading aliases

alias ,b="bash"

#alias ,cwd='printf "%q\n" "$(pwd)" | pbcopy'
alias ,cwd='perl -MCwd  -e  "print(Cwd::abs_path())" | pbcopy && pbpaste' 


alias ,shfmt='shfmt -i 3 -w'


# ack --follow: follow symlinks
alias ,grep="/usr/bin/env perl $DOTLOCAL_BIN/ack --follow "

alias ,rename="/usr/bin/perl $DOTLOCAL_BIN/rename"

alias smlnj='/usr/local/smlnj/bin/sml'

alias bob="java -jar $HOME/bin/bob.jar"

#alias vv='mvim --servername VIM --remote-tab'
alias vv='nvim --server ~/.cache/nvim/server.pipe --remote'
