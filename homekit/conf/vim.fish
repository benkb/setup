for dir in /usr/local/Cellar/macvim//9.1.0/MacVim.app/Contents/Resources/vim/runtime /usr/local/share/vim/syntax /usr/local//Cellar/vim/9.1.0150/share/vim/vim91
    if [ -d "$dir" ] 
        export VIMRUNTIME="$dir"
    end
end


