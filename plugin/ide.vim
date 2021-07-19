""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Title: VIM IDE
" Description: Create a VIM IDE for Python
" Author: Tyler Wayne (tylerwayne3@gmail.com)
" Last Modified: 2020-07-27
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" MAPPINGS {{{

command! -nargs=1 StartREPL call StartREPL(<args>)

tnoremap <silent> <c-t> <c-w>::call StartEditor()<cr>

nnoremap <silent> <localleader>t :call StartREPL(t:repl)<cr>
nnoremap <silent> <localleader>r :call SendKeys("char")<cr>
vnoremap <silent> <localleader>r :<c-u>call SendKeys(visualmode())<cr>

nnoremap <silent> <localleader>q :call QuitREPL()<cr>

" }}}

" FUNCTIONS {{{

function! FindREPL(repl)
  " Find the full pathname to the supplied REPL
  let repl = substitute(system("which " . a:repl), "\n", "", "g")

  if repl == ""
    throw "No path found for REPL " . a:repl . "..."
  endif
  return repl
endfunction

function! SplitVertical()
  return (2.5 * &lines) < &columns
endfunction!

function! StartREPL(repl)
  " Start a terminal using the specified repo
  " Set the buffer number of the terminal as a global variable
  " to reference when using term_sendkeys()
  let repl = FindREPL(a:repl)
  let command = "term " . repl

  if SplitVertical()
    let command = "vert " . command
  endif

  execute command
  let t:termbufnr=winbufnr(0)
  set nobuflisted
  execute "normal! "

  " Set filetype for tab in case we accidently close the editor
  let t:filetype=&ft
endfunction!

function! StartEditor()
  " Start a window to hold the script to be edited
  if SplitVertical()
    set splitright!
    vnew 
    set splitright!
  else
    set splitbelow!
    new
    set splitbelow!
  endif
  let &ft=t:filetype
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

  " if a:type !=# 'V'
    " let @@ = @@ . "\n"
  " endif

  call term_sendkeys(t:termbufnr, @@)

  let @@ = saved_reg
endfunction

function! s:CheckForREPL(msg)
  if !exists('t:termbufnr') || bufwinnr(t:termbufnr) == -1
    throw a:msg
  endif
endfunction

" }}}
