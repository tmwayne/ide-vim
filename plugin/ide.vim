"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ide.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Copyright (c) 2022 Tyler Wayne
" 
" Licensed under the Apache License, Version 2.0 (the "License");
" you may not use this file except in compliance with the License.
" You may obtain a copy of the License at
" 
"     http://www.apache.org/licenses/LICENSE-2.0
" 
" Unless required by applicable law or agreed to in writing, software
" distributed under the License is distributed on an "AS IS" BASIS,
" WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
" See the License for the specific language governing permissions and
" limitations under the License.
"

" MAPPINGS {{{

command! -nargs=1 StartREPL call StartREPL(<args>)

nnoremap <silent> <localleader>r :call RunCode("char")<cr>
vnoremap <silent> <localleader>r :<c-u>call RunCode(visualmode())<cr>

" Restore the editor buffer when it's accidentally been closed
tnoremap <silent> <c-t> <c-w>: :call RestoreEditor()<cr>

" Press \q in the editor buffer to close the REPL
nnoremap <silent> <localleader>q :call QuitREPL()<cr>

" Press <Ctrl-q> in the REPL buffer to close the REPL
tnoremap <silent> <c-q> <c-w>: :call QuitREPL()<cr>

" }}}

" FUNCTIONS {{{

function! SplitVertical()
  return (2.5 * &lines) < &columns
endfunction!

function! StartREPL(cmd)
  " Start a terminal by running the provided command.
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

function! RestoreEditor()
  " Restores the editor buffer when it's been accidentally closed
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

function! s:ExistsREPL()
  " Check if the terminal buffer exists and if the buffer number is set
  return exists('t:termbufnr') && bufwinnr(t:termbufnr) != -1
endfunction

function! RunCode(type)
  " Send a command to the terminal.
  " If the selection is visual, send that.
  " Otherwise, yank the paragraph and send that.
  " Use the "@ register and restore it afterwards
  if !s:ExistsREPL()
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
  if s:ExistsREPL()
    execute "bd! " . t:termbufnr
  endif
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

" }}}
