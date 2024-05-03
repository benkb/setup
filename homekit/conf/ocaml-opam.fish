set opam_init "$HOME/.opam/opam-init/init.fish"

if test -f "$opam_init" 
   source "$opam_init" > /dev/null 2> /dev/null; or true
end
