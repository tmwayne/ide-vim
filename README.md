# ide-vim

## About
`ide-vim` turns Vim into a simple IDE . The plugin is a thin
wrapper around the asynchronous terminal feature released in Vim v8.1.

The plugin handles opening a REPL, managing the buffers and windows,
running code in the REPL, and closing the REPL. It's meant to be as
thin as possible with only the essential functionality, as opposed to
being feature rich.

## Installation
Using Vim 8's native package loader, on Linux.
```
mkdir -p ~/.vim/pack/my-plugins/start && cd $_
git clone --depth=1 git@github.com:tmwayne/ide-vim
```

Alternatively, if you feel so inclined you can bypass the package loader,
as the plugin is a single file.
```
git clone --depth=1 git@github.com:tmwayne/ide-vim
cp ide-vim/plugin/ide.vim ~/.vim/plugin
```

## Usage
To start a REPL, enter `:StartREPL "<repl>"`. Replace `<repl>`
with any valid bash command that opens a REPL. 

Use visual mode to highlight code you want to run and press `\r`.
If no code is highlighted, then the paragraph will be run.

To quit and close the REPL window, press `\q` if the cursor
is in the editor window or press `<Ctrl-Q>` if the cursor is
in the REPL window.

Sometimes the editor window is accidentally closed which leaves
the REPL window stranded. Pressing `<Ctrl-T>` restores
the editor window.

## Requirements
- Vim v8.1+

## Issues
- Some interactive REPLs require autoindentation to be turned off
for `ide-vim` to work correctly.
