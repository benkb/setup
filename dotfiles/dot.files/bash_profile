# bash_profile: loaded in interactive login shell
# 
# Because of this file's existence, neither ~/.bash_login nor ~/.profile
# will be sourced.
# This eventually source ~/.bashrc which inturn sources ~/.profile


# The following sources ~/.bashrc in the interactive login case,
# because .bashrc isn't sourced for interactive login shells:
# Example $-: 'himBH'
#
case "$-" in 
    *i*) 
        if [ -r ~/.bashrc ]; then 
            . ~/.bashrc
        else
            echo "Warn: could not load ~/.bashrc" >&2
        fi
    ;;
    *) echo "Warn: ~/.bashrc, not loades" >&2 
    ;; 
esac
