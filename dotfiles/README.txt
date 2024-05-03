install-dotfiles.sh - rules applied by the installation script: 


- Files in the root are ignored
    Examples: LICENSE, README.txt

- Folder with the ending '.f' or '.file' have their folder name ignored
    The files ar simply linked to ~/.
    Examples: dot.files

- Folder with the ending '.l' or '.link' are linked to ~/.
    Examples: bin.l

- Folder with the ending '.d' or '.link' are linked to ~/.

- Folder with a dash, are (reverse) nested

    Examples: autoload-vim.d -> ~/.vim/autoload/

- Uppercase is eventually evaluated as env variable

    Examples: USER.d => ~/.frankie


