""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Title: VIM IDE
" Description: Create a VIM IDE for Python
" Author: Tyler Wayne (tylerwayne3@gmail.com)
" Last Modified: 2020-07-27
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" MAPPINGS {{{

command! -nargs=1 StartREPL call StartREPL(<args>)

nnoremap <buffer> <silent> <localleader>t :call StartREPL(t:repl)<cr>
nnoremap <buffer> <silent> <localleader>r :call SendKeys("char")<cr>
vnoremap <buffer> <silent> <localleader>r :<c-u>call SendKeys(visualmode())<cr>

" }}}

" FUNCTIONS {{{

function! FindREPL(repl)
  " Find the full pathname to the supplied REPL
  let repl = system("which " . a:repl)
  return repl
endfunction

function! StartREPL(repl)
  " Start a terminal using the specified repo
  " Set the buffer number of the terminal as a global variable
  " to reference when using term_sendkeys()
  let repl = FindREPL(a:repl)
  execute "term " . repl
  let t:termbufnr=winbufnr(0)
  execute "normal! "
endfunction!

function! SendKeys(type)
  " Send a command to the terminal
  " If the select is visual, send that.
  " Otherwise, yank the paragraph and send that
  " Use the "@ register and restore it afterwards
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

" }}}
