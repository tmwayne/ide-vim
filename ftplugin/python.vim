"
" ------------------------------------------------------------------------------
" python.vim
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

function! RegisterHooks()

  " If the interpreter is ipython then we need to wrap
  " multi-line code blocks with a special magic function so that
  " ipython interprets it correctly. We only need to do this if
  " it's a multi-line statement with at least one line indented.
  if stridx(t:interpcmd, "ipython") >= 0

    function! SendKeysPreHook_Python()
      if stridx(@@, "\n\t") >= 0 || stridx(@@, "\n    ") >= 0
        " Instead of having SendKeysPostHook also checking the text
        " we save the result of this to a script-level variable
        let s:add_cpaste=1
        call term_sendkeys(t:interpbufnr, "%cpaste -q\<cr>")

        " There seems to be a race condition happening, which
        " prevents %cpaste from working correctly. A 10ms wait
        " fixes that.
        call term_wait(t:interpbufnr)
      else
        let s:add_cpaste=0
      endif
    endfunction!

    function! SendKeysPostHook_Python()
      if s:add_cpaste
        call term_sendkeys(t:interpbufnr, "--\<cr>")
      endif
    endfunction!

    " Register hooks as tab-scoped variables
    let t:SendKeysPreHook = function("SendKeysPreHook_Python")
    let t:SendKeysPostHook = function("SendKeysPostHook_Python")

  endif
endfunction!

