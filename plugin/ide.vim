"
" ------------------------------------------------------------------------------
" ide.vim
" ------------------------------------------------------------------------------
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

command! -nargs=1 StartInterp call StartInterp(<args>)

nnoremap <silent> <localleader>r :call RunCode("char")<cr>
vnoremap <silent> <localleader>r :<c-u>call RunCode(visualmode())<cr>

" Restore the editor window when it's been accidentally closed
tnoremap <silent> <c-t> <c-w>: :call RestoreEditor()<cr>

" Press \q in the editor window to close the interpreter
nnoremap <silent> <localleader>q :call QuitInterp()<cr>

" Press <Ctrl-q> in the interpreter window to close the interpreter
tnoremap <silent> <c-q> <c-w>: :call QuitInterp()<cr>

" Close interpreter window when quitting from the editor window.
augroup close_interp_on_exit
  autocmd!
  autocmd QuitPre * :call QuitInterp()
augroup END

" }}}

" FUNCTIONS {{{

function! SplitVertical()
  " Check the terminal dimensions.
  " When Vim is in full screen, the interpreter window will be opened
  " to the left or right, whichever is default.
  " On the otherhand, when Vim is in half screen, 
  " the interpreter window will be either above or below.
  return (2.5 * &lines) < &columns
endfunction!

function! StartInterp(cmd)
  " Start a terminal by running the provided command.
  " Set the buffer number of the terminal as a global variable
  " to reference when using term_sendkeys()

  let command = "term " . a:cmd

  if SplitVertical()
    let command = "vert " . command
  endif

  execute command
  let t:interpbufnr=winbufnr(0)
  " Remove the interpreter buffer from the buffer list. This prevents
  " accidentally opening a duplicate of the interpreter buffer in the
  " editor window.
  set nobuflisted

  " Return cursor to editor window
  execute "normal! "

  " Set filetype for tab in case we accidently close the editor
  let t:interpcmd=a:cmd
  let t:filetype=&ft

  " Load any filetype specific hooks. These hooks are registered
  " as tab-scoped variables, allowing multiple tabs with interpreters
  " to be opened without the hooks interferring with each other
  if exists("*RegisterHooks")
    call RegisterHooks()
  endif
endfunction!

function! RestoreEditor()
  " Restores the editor window when it's been accidentally closed.
  " The calls to split<side> around new ensure that the editor
  " window is opened on the opposite side that the interpreter window was
  " opened on. This restores the position of the two window.

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

function! s:ExistsInterp()
  " Check if the terminal buffer exists and if the buffer number is set
  return exists('t:interpbufnr') && bufwinnr(t:interpbufnr) != -1
endfunction

function! RunCode(type)
  " Send a command to the terminal.
  " If the selection is visual, send that.
  " Otherwise, yank the paragraph and send that.
  " Use the "@ register and restore it afterwards

  if !s:ExistsInterp()
    return
  endif

  let saved_reg = @@

  if a:type ==? 'V'
    execute "normal! `<" . a:type . "`>y"
  else
    normal yip
  endif

  " Exit any pager that may be open before sending keys (e.g., help screen).
  " Otherwise the code won't execute properly, if at all.
  " call term_sendkeys(t:interpbufnr, "q\<c-H>")

  if exists("t:SendKeysPreHook")
    call t:SendKeysPreHook()
  endif

  call term_sendkeys(t:interpbufnr, @@)

  if exists("t:SendKeysPostHook")
    call t:SendKeysPostHook()
  endif

  let @@ = saved_reg
endfunction!

function! s:CleanupTab()
  " Delete tab-scoped variables

  unlet! t:filetype t:interpbufnr t:interpcmd
  if exists("t:SendKeysPreHook")
    unlet! t:SendKeysPreHook
  endif
  
  if exists("t:SendKeysPostHook")
    unlet! t:SendKeysPostHook
  endif
endfunction!

function! QuitInterp()
  if s:ExistsInterp()
    execute "bd! " . t:interpbufnr
  endif
  call s:CleanupTab()
endfunction!

" }}}
