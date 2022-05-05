"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ide.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Tyler Wayne @ 2022
"

" MAPPINGS {{{

command! -nargs=1 StartREPL call StartREPL(<args>)

tnoremap <silent> <c-t> <c-w>::call StartEditor()<cr>

" nnoremap <silent> <localleader>t :call StartREPL(t:repl)<cr>
nnoremap <silent> <localleader>r :call SendKeys("char")<cr>
vnoremap <silent> <localleader>r :<c-u>call SendKeys(visualmode())<cr>

nnoremap <silent> <localleader>q :call QuitREPL()<cr>

" }}}

" FUNCTIONS {{{

function! SplitVertical()
  return (2.5 * &lines) < &columns
endfunction!

function! StartREPL(cmd)
  " Start a terminal using the specified repo
  " Set the buffer number of the terminal as a global variable
  " to reference when using term_sendkeys()
  let command = "term " . a:cmd

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

function! s:existsREPL()
  " Check if the terminal buffer exists and if the a buffer number is set
  return exists('t:termbufnr') && bufwinnr(t:termbufnr) != -1
endfunction

function! SendKeys(type)
  " Send a command to the terminal
  " If the select is visual, send that.
  " Otherwise, yank the paragraph and send that
  " Use the "@ register and restore it afterwards
  if !s:existsREPL()
    return
  endif

  let saved_reg = @@

  if a:type ==? 'V'
    execute "normal! `<" . a:type . "`>y"
  else
    normal yip
  endif

  call term_sendkeys(t:termbufnr, @@)

  let @@ = saved_reg
endfunction

function! QuitREPL()
  if !s:existsREPL()
    return
  endif

  execute "bd! " . t:termbufnr
endfunction!

" function! FindREPL(repl)
"   " Find the full pathname to the supplied REPL
"   let repl = substitute(system("which " . a:repl), "\n", "", "g")
" 
"   if repl == ""
"     throw "No path found for REPL " . a:repl . "..."
"   endif
"   return repl
" endfunction

" function! StartREPL(repl)
"   " Start a terminal using the specified repo
"   " Set the buffer number of the terminal as a global variable
"   " to reference when using term_sendkeys()
"   let repl = FindREPL(a:repl)
"   let command = "term " . repl
" 
"   if SplitVertical()
"     let command = "vert " . command
"   endif
" 
"   execute command
"   let t:termbufnr=winbufnr(0)
"   set nobuflisted
"   execute "normal! "
" 
"   " Set filetype for tab in case we accidently close the editor
"   let t:filetype=&ft
" endfunction!

" function! StartDockerREPL(image)
"   " Start a terminal using the specified repo
"   " Set the buffer number of the terminal as a global variable
"   " to reference when using term_sendkeys()
"   let command = "term docker-compose run --rm " . a:image
" 
"   if SplitVertical()
"     let command = "vert " . command
"   endif
" 
"   execute command
"   let t:termbufnr=winbufnr(0)
"   set nobuflisted
"   execute "normal! "
" 
"   " Set filetype for tab in case we accidently close the editor
"   let t:filetype=&ft
" endfunction!


" }}}
