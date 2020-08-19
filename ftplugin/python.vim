""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Title: VIM IDE
" Description: Python settings for VIM IDE
" Author: Tyler Wayne (tylerwayne3@gmail.com)
" Last Modified: 2020-07-27
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" VARIABLES {{{

let t:repl = system("which ipython 2> /dev/null")

if len(t:repl) == 0
  let t:repl = system("which python 2> /dev/null")
endif

" }}}

