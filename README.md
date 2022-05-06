# ide-vim

## About
`ide-vim` is a IDE for use with VIM. The package is a thin
wrapper around the asynchronous terminal feature released in Vim v8.1.

The package handles opening a REPL, managing the buffers,
sending keys to the REPL, and closing the REPL. It's meant to be as
thin as possible while providing essential functionality, rather than
being feature rich.

## Installation
Using Vim 8's native package loader, on Linux.
```
mkdir -p ~/.vim/pack/my-plugins/start && cd $_
git clone --depth=1 git@github.com:tmwayne/ide-vim
```

## Usage
To start a REPL, enter `:StartREPL "ipython"`.

To run lines in the REPL, highlight the code and enter `\r`. 
If you don't highlight the text, the paragraph will be run.

To quit the REPL and close its buffer, enter `\q`. 
Note that this requires being in the editor buffer.

## Requirements
- Vim v8.1+

## Issues
- Some REPLs, such as IPython require autoindentation to be turned off for
`ide-vim` to work correctly. 
- Also, with IPython, sending functions that
contain new lines doesn't currently work. To current workaround is to replace
the newlines with a comment character.
- Closing file in the current editor buffer with `:bd` will close the buffer
altogether. If the REPL hasn't been closed, then this will strand it.
