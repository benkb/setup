
set DEBUG ''

set ALIASES_CACHE_DIR "$HOME/.cache/aliases"

function config_utils__run
    set cmd $argv[1]

    if [ -n "$cmd" ]
        set -e argv[1]
    else
        echo "Err: no cmd" >&2
        return 1
    end

    set dirinput $argv[1]
    if [ -n "$dirinput" ] 
        set -e argv[1]
    else
        echo "Err: no dirinput" >&2
        return 1
    end

    [ -d "$dirinput" ] || begin
        echo "Err: no valid dirinput for $dirinput" >&2
        return 1
    end

    set action
    switch "$cmd" 
        case 'alias_gen' 'file_sourcing'
            set action "config_utils__$cmd"
        case '*'
            echo "Err: wrong cmd '$cmd'"
            return 1
    end


    for folder in $argv 
        set utilsdir "$dirinput/$folder"

        [ -d "$utilsdir" ] || continue

        $action "$utilsdir" || begin
            echo "Err: cmd '$action' failed" >&2
            return 1
        end
    end
end


function config_utils__get_interp
    set ext $argv[1]
    switch $ext
        case 'sh' 'bash' 'dash'
            echo $ext
        case rb
            echo 'ruby'
        case pl
            echo 'perl'
        case py
            echo python
        case '*'
            echo "Warn: extension '$ext' not implemented, skip alias" >&2
            return 1
    end
end

function config_utils__alias_gen
    set utilsdir $argv[1]
    [ -n "$utilsdir" ] || begin
        echo "Err: no utilsdir" >&2
        return 1
    end

    set utilsdirname (perl -e '$ARGV[0] =~ s/[^a-zA-Z0-9]/_/g; print $ARGV[0];' $utilsdir)


    set aliascache ''

    if [ -d "$ALIASES_CACHE_DIR" ] 
        set aliascache "$ALIASES_CACHE_DIR/$utilsdirname" 
        if [ -f "$aliascache" ] 
            if source  $aliascache 
                return 0
            else
                return 1
            end
        end
    end

    for scriptfile in $utilsdir/*
        [ -f "$scriptfile" ] || continue


        set bname (path basename $scriptfile)
        set name (string split -r -m1 . $bname)[1]
        set ext (string split -r -m1 . $bname)[2]

        set interp (config_utils__get_interp $ext)

        if string length --quiet  $interp
            switch "$name" 
                case '_*' 'lib*'
                    continue
                case '*'
                    [ -n "$DEBUG" ] && echo "alias $name = $interp $scriptfile"
                    [ -n "$aliascache" ] && echo "alias $name='$interp $scriptfile'" >> $aliascache
                    alias $name="$interp $scriptfile"
            end
        end
    end
end


function config_utils__file_sourcing        
    set -l dir $argv[1]

    [ -n "$dir" ] || begin
        echo "Err: no dir" >&2
        return 1
    end

    for f in $dir/*.*sh
        [ -f "$f" ] || continue
        switch $f
            case '_*' 'lib*'
                continue
            case '*.sh' '*.fish'
                [ -n "$DEBUG" ] && echo source $f
                source $f
        end
    end
end

