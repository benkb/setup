
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
