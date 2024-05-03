

set UTILS $HOME/.local/utils

function cdreal;
    switch (count $argv)
        case '0'
            cd (pwd -P)
        case '1'
            set dir  $argv[1]
            if [ -f $argv[1] ] ; 
                set dir (dirname (realpath $argv[1]))
            else if [ -d $argv[1] ] ; 
                set dir (realpath $argv[1])
            else
                echo "Warn cannot get dir"
            end
            [ -n "$dir" ] && cd (realpath $dir)
    case '*'
        echo "Warn: invalid number of args"
        return 1
   end
end


function ,cdreal; 
   set -l truepath $UTILS/truepath
   if [ -f "$truepath" ] ; 
      set realdir "$(truepath $(pwd))"
      cd $realdir
   else
      cd (realpath)
   end
end



# grep with support for symbolic links

# find -L ~/y/.local/aliases/  -type f -exec grep -li 'aliases' '{}' \;

#### Find funcs
alias ,f=,find
alias ,fx=,findx ; 
alias ,fdx=,find-dirsx ; 
alias ,flsfx=,findls-filesx ; 
alias ,flsf=,findls-files ; 
alias ,fd=,find-dirs ; 
#function #,findls ; 
#function ,findls-dirsx ; 

function ,findx ; 
   switch (count $argv)
      case '0'
         find .  -print0
      case '1'
         find . -iname $argv[1] -print0
      case '2'
         find $argv[1] -iname $argv[2] -print0
      case '*'
         set -l dir $argv[1]
         set -l name $argv[2]
         set --erase argv[1]
         set --erase argv[1]
         find $dir $argv -iname $name -print0
   end
end


function ,find ; 
   switch (count $argv)
      case '0'
         find . 
      case '1'
         find . -iname $argv[1] 
      case '2'
         find $argv[1] -iname $argv[2] 
      case '*'
         set -l dir $argv[1]
         set --erase argv[1]
         set -l name $argv[1]
         set --erase argv[1]
         find $dir $argv -iname $name 
   end
end

function ,find-dirs ; 
   switch (count $argv)
      case '0'
         find . -type d
      case '1'
         find . -type d -iname $argv[1] 
      case '2'
         find $argv[1] -type d -iname $argv[2] 
      case '*'
         set -l dir $argv[1]
         set --erase argv[1]
         set -l name $argv[1]
         set --erase argv[1]
         find $dir $argv -type d -iname $name 
   end
end

function ,find-dirsx ; 
   switch (count $argv)
      case '0'
         find . -type d  -print0
      case '1'
         find . -type d -iname $argv[1] -print0
      case '2'
         find $argv[1] -type d -iname $argv[2] -print0
      case '*'
         set -l dir $argv[1]
         set --erase argv[1]
         set -l name $argv[1]
         set --erase argv[1]
         find $dir $argv -type d -iname $name  -print0
   end
end

function ,findls ; 
   switch (count $argv)
      case '0'
         find . -depth 1  
      case '1'
         find . -iname $argv[1] -depth 1
      case '2'
         find $argv[1] -iname $argv[2] -depth 1 
      case '*'
         set -l dir $argv[1]
         set -l name $argv[2]
         set --erase argv[1]
         set --erase argv[1]
         find $dir $argv -iname $name -depth 1 
   end
end

function ,findls-dirs ; 
   switch (count $argv)
      case '0'
         find . -type d 
      case '1'
         find . -type d -iname $argv[1] 
      case '2'
         find $argv[1] -type d -iname $argv[2] 
      case '*'
         set -l dir $argv[1]
         set --erase argv[1]
         set -l name $argv[1]
         set --erase argv[1]
         find $dir $argv -type d -iname $name 
   end
end

function ,findls-dirsx ; 
   switch (count $argv)
      case '0'
         find . -type d  -print0
      case '1'
         find . -type d -iname $argv[1] -print0
      case '2'
         find $argv[1] -type d -iname $argv[2] -print0
      case '*'
         set -l dir $argv[1]
         set --erase argv[1]
         set -l name $argv[1]
         set --erase argv[1]
         find $dir $argv -type d -iname $name  -print0
   end
end

function ,findls-files ; 
   switch (count $argv)
      case '0'
         find . -type f -depth 1 
      case '1'
         find . -type f -depth 1 -iname $argv[1] 
      case '2'
         find $argv[1] -type f -depth 1 -iname $argv[2] 
      case '*'
         set -l dir $argv[1]
         set --erase argv[1]
         set -l name $argv[1]
         set --erase argv[1]
         find $dir $argv -type f -depth 1 -iname $name 
   end
end

function ,findls-filesx ; 
   switch (count $argv)
      case '0'
         find . -type f -depth 1 -print0
      case '1'
         find . -type f -depth 1 -iname $argv[1] -print0
      case '2'
         find $argv[1] -type f -depth 1 -iname $argv[2] -print0
      case '*'
         set -l dir $argv[1]
         set --erase argv[1]
         set -l name $argv[1]
         set --erase argv[1]
         find $dir $argv -type f -depth 1  -iname $name  -print0
   end
end


function ,gclone ;
   git clone $argv.git
end
