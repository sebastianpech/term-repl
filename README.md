# term-repl.vim
term-repl.vim is a neovim plugin which sends commands to a terminal opened in a
split.

## Installation
For [pathogen.vim](https://github.com/tpope/vim-pathogen) copy and paste:

    cd ~/.vim/bundle
    git clone git://github.com/sebastianpech/term-repl.git

For [vundle.vim](https://github.com/VundleVim/Vundle.vim) copy and paste:

    Plugin 'sebastianpech/term-repl'

## Configuration
Example configuration:

    " General part
    nnoremap <F8> :call SendLine()<CR>
    nnoremap <F20> :call CloseTerminal() <bar> :call SendLine()<CR>

    vnoremap <F8> :call SendLines()<CR>
    vnoremap <F20> :call CloseTerminal() <bar> :call SendLines()<CR>

    " Example implementaion for julia to include the current file
    augroup default_repls
        autocmd FileType julia nnoremap <F10> :call SendLine("include(\"".expand("%")."\")")<CR>
    augroup END

term-repl.vim tries to guess the REPL by using the syntax name. In some cases
e.g. python the REPL differs from the syntax name. To change the used REPL
command `b:REPL` has to be set interactively or in an autocommand:

    autocmd FileType python let b:REPL = 'ipython'

In case the terminal can not be found by the terminal name, like when it's a
bash instance running the REPL. The command `:AttachTo` can be used to attach
the current buffer to an open terminal.

The window size for newly created splits can be changed with:

    let g:REPLHeight = 12
