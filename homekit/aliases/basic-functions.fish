



function m
    if [ -z $argv ] 
        echo "Err: no directory given" 
        return 1
    end
    mkdir -p $argv
    cd $argv
end
