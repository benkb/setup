# Thougths about where/how to manage/store fish configs
# - fish autoload of configs and scripts via ~/.config/fish/conf.d
# - autoload has negative impact when in non-interactive mode (scripting)
# - control the inclusion manually here in ~/.config/fish/config.fish

# start in insert mode

fish_vi_key_bindings insert

set -gx GPG_TTY (/usr/bin/tty)

### Interactive Shell Only
# if this called during the init of a script its time to go
# was not a good idea when using fish from ssh


# sourcing for environment variables and aliases

######## NONINTERACTIVE SHELL


if [ -f ~/.profile ] 
    . ~/.profile
else
    echo "Warn: ~/.profile not found" >&2
end


set config_utils "$HOME/.config/fish/config_utils.fish"
set is_config_utils_sourced ''
[ -f "$config_utils" ] && source "$config_utils" && set is_config_utils_sourced 1 

[ -n "$is_config_utils_sourced" ] && config_utils__run 'file_sourcing' "$HOME/kit/conf"

status is-interactive || return 0 


######## INTERACTIVE SHELL

if [ -n "$is_config_utils_sourced" ] 
    config_utils__run 'alias_gen' "$HOME/kit/" 'utils' 'vi-utils' 'scripts'

    config_utils__run 'file_sourcing' "$HOME/kit" 'conf' 'aliases'

end



