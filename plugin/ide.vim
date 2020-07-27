""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Title: VIM IDE
" Description: Create a VIM IDE for Python
" Author: Tyler Wayne (tylerwayne3@gmail.com)
" Last Modified: 2020-07-27
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" MAPPINGS {{{

command! -nargs=1 StartREPL call StartREPL(<args>)

nnoremap <silent> <localleader>t :call StartREPL(t:repl)<cr>
nnoremap <silent> <localleader>r :call SendKeys("char")<cr>
vnoremap <silent> <localleader>r :<c-u>call SendKeys(visualmode())<cr>

nnoremap <silent> <localleader>q :call QuitREPL()<cr>

" }}}

" FUNCTIONS {{{

function! FindREPL(repl)
  " Find the full pathname to the supplied REPL
  let repl = system("which " . a:repl)
  if repl == ""
    throw "No path found for REPL " . a:repl . "..."
  endif
  return repl
endfunction

function! StartREPL(repl)
  " Start a terminal using the specified repo
  " Set the buffer number of the terminal as a global variable
  " to reference when using term_sendkeys()
  let repl = FindREPL(a:repl)
  let command = "term " . repl

  if (2.5 * &lines) < &columns
    let command = "vert " . command
  endif

  execute command
  let t:termbufnr=winbufnr(0)
  execute "normal! "
endfunction!

function! QuitREPL()
  call s:CheckForREPL("REPL isn't open...")
  execute "bd! " . t:termbufnr
endfunction!

function! SendKeys(type)
  " Send a command to the terminal
  " If the select is visual, send that.
  " Otherwise, yank the paragraph and send that
  " Use the "@ register and restore it afterwards
  call s:CheckForREPL("No REPL to send commands to...")
  let saved_reg = @@

  if a:type ==? 'V'
    execute "normal! `<" . a:type . "`>y"
  else
    normal yip
  endif

  if a:type !=# 'V'
    let @@ = @@ . "\n"
  endif

  call term_sendkeys(t:termbufnr, @@)

  let @@ = saved_reg
endfunction

function! s:CheckForREPL(msg)
  if bufwinnr(t:termbufnr) == -1
    throw a:msg
  endif
endfunction

" }}}
