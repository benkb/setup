" --------- start
"  todo: cleaning this up one day

"autowrite for the haxe/vaxe autocompl to work
set autowrite


nnoremap j a
nnoremap a j

vnoremap j a
vnoremap a j

" Wrapping 
highlight ColorColumn ctermbg=gray
set colorcolumn=80

" (optional - will help to visually verify that it's working)
set number 
set textwidth=0
set wrapmargin=0
set wrap
" (optional - breaks by word rather than character)
set linebreak 

"# <<< THIS IS THE IMPORTANT PART
set columns=80 

"
" Searchich
set ignorecase
" When searching try to be smart about cases
set smartcase
" Highlight search results
set hlsearch
" Makes search act like search in modern browsers
set incsearch

set autoindent

set shell=/bin/sh
set modelines=1

set nu
set noerrorbells
set vb t_vb=

set nocompatible
behave xterm

filetype plugin indent on

" tabstop:          Width of tab character
" softtabstop:      Fine tunes the amount of white space to be added
" shiftwidth        Determines the amount of whitespace to add in normal mode
" expandtab:        When this option is enabled, vi will use spaces instead of tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set colorcolumn=80
set textwidth=80

"set splitright
set nosplitright

" because of strange chars in backspace
set backspace=indent,eol,start

let mapleader=","
let maplocalleader=","

syntax enable


set showtabline=2
set guioptions+=e

" Key mappings
" Faster buffer switch
nnoremap <Leader>b :ls<CR>:b<Space>

" escape terminal in nvim
tnoremap <Esc> <C-\><C-n>


inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>
inoremap <C-@> <c-x><c-o>



" Remap arrow keys to resize window
nnoremap <Up>    :resize -2<CR>
nnoremap <Down>  :resize +2<CR>
nnoremap <Left>  :vertical resize -2<CR>
nnoremap <Right> :vertical resize +2<CR>



"refresh syntax higlight (specially helpfulll for large multi-syntax files
"like org-mode
if v:progname ==? 'vim'
   nnoremap s :w<cr>:syn sync fromstart<cr>
   nnoremap m :w<cr>:syn sync fromstart<cr>:MarkDrawer<cr>
endif

" opens file at the last edited location
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif


if !empty(glob(expand("~/.vim/autoload/pathogen.vim")))
   if !empty(glob(expand("~/.vim/bundle")))
      execute pathogen#infect()
   endif
endif



" load custom (plugi) configs
for fpath in split(globpath('~/.config/morevim/', '*.vim'), '\n')
   exe 'source' fpath
endfor


if has("gui_running")
	colorscheme habamax
	"colorscheme koehler
   set	guifont=Monaco:h15
  if has("gui_gtk2")
    set guifont=Inconsolata\ 14
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h18
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  else
    "set guifont=Monospace 12
  endif
	set bs=2
	set ai
endif


set lispwords+=define,define-cfn


" centers the current pane as the middle 2 of 4 imaginary columns
" should be called in a window with a single pane

 function CenterPane()
   lefta vnew
   wincmd w
   exec 'vertical resize '. string(&columns * 0.75)
 endfunction

let g:tagbar_ctags_bin="/usr/local/bin/ctags"

" optionally map it to a key:
nnoremap <leader>c :call CenterPane()<cr>
nnoremap <leader>t :TagbarOpen<cr>
nnoremap <leader>n :bnext<cr>
"nmap <F8> :TagbarToggle<CR>
"
"au BufNewFile,BufRead *.scm,*.ss,*.sld, *.cise setf scheme
autocmd BufNewFile,BufRead *.cise   set syntax=scheme

function! Vitask1(mode)

   echo "suuuuuuuuuu"
endfunction


function! Vitask(mode)


    let task_script = getcwd() . '/task.sh'
   if filereadable(task_script)
       ""
   else
       echo "Err: no task_script.sh file in " . task_script
       return 
   endif

   "let script = "$HOME/kit/vimutils/vitask-send.sh"
   "let realscript = resolve(expand(script))
   let realinput = resolve(expand("%:~:."))
   

   if filereadable(task_script)
      "silent !clear
"      echo "/bin/sh " . shellescape(task_script) . ' ' . a:mode . ' ' . shellescape(realinput) . ' ' . line(".") 
      call system( '/bin/sh ' . shellescape(task_script) . ' ' . a:mode . ' ' . shellescape(realinput) . ' ' . line(".") ) 
      "call system( '/bin/sh ' . shellescape(realscript) . ' ' . a:mode . ' ' .shellescape(getcwd()) . ' ' . shellescape(realinput) . ' ' . line(".") ) 
      "silent execute  '!(/bin/sh ' . shellescape(realscript) . ' ' . a:mode . ' ' . shellescape(getcwd()) . ' ' . shellescape(realinput) . ' ' . line(".") . ' &  > /dev/null)' 
      "redraw!
          "| silent execute  ':redraw!'
   else
      echo "Err: script vitask-send not exist "
   endif
endfunction


nnoremap f :w!<cr>:call Vitask('run')<cr>
nnoremap t :w!<cr>:call Vitask('test')<cr>

let g:ycm_clangd_binary_path = trim(system('brew --prefix llvm')).'/usr/bin/clangd'
"let g:SuperTabNoCompleteAfter = ['^', ',', '\s', '"', "'"]
"
"Syntax highlighting in Markdown
"let g:markdown_fenced_languages = ['html', 'python', 'ruby', 'vim', 'perl']
"let g:vim_markdown_fenced_languages = ['csharp=cs', 'perl=perl']
"let g:vim_markdown_folding_disabled = 1
"let g:pandoc_use_embeds_in_codeblocks_for_langs = { "perl": "perl", "ocaml": "ocaml" }
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'ocaml', 'perl']
let g:vim_markdown_follow_anchor = 1

let g:markdrawer_toc = 'index'
nnoremap <Leader>md :MarkDrawer<cr>
let g:markdrawer_width = "45"



" ymc also in markdown files
let g:ycm_filetype_blacklist = {}

" goal, while typing in insert mode, is to automatically soft-wrap text (only visually) at 80 columns:


" tab for `make` files
autocmd FileType make setlocal noexpandtab
