
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
