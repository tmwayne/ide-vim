# ide-vim

## About
`ide-vim` turns Vim into a simple IDE . The plugin is a thin
wrapper around the asynchronous terminal feature released in Vim v8.1.

The plugin handles opening a interpreter, managing the buffers and windows,
running code in the interpreter, and closing the interpreter. It's meant to be as
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
To start a interpreter, enter `:StartInterp "<interp>"`. 
Replace `<interp>` with any valid shell command that opens a interpreter.

Use visual mode to highlight code you want to run and press `\r`.
If no code is highlighted, then the paragraph will be run.

To quit and close the interpreter window, press `\q` if the cursor
is in the editor window or press `<Ctrl-Q>` if the cursor is
in the interpreter window.

Sometimes the editor window is accidentally closed which leaves
the interpreter window stranded. Pressing `<Ctrl-T>` restores
the editor window.

## Requirements
- Vim v8.1+

## Issues
- Some interpreters require autoindentation to be turned off
for `ide-vim` to work correctly.
