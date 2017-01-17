# term-repl.vim
term-repl.vim is a neovim plugin which sends commands to a terminal opened in a
split. 

## Installation
For [pathogen.vim](https://github.com/tpope/vim-pathogen) copy and paste:

    cd ~/.vim/bundle
    git clone git://github.com/tpope/vim-dispatch.git

For [vundle.vim](https://github.com/VundleVim/Vundle.vim) copy and paste:

    Plugin 'sebastianpech/term-repl'

# Configuration
Example configuration:

    " General part
    nnoremap <F8> :call SendLine()<CR>
    vnoremap <F8> :call SendLines()<CR>
    nnoremap <F11> :call SetThisLastTerm()<CR>

    " Example implementaion for julia to include the current file
    augroup default_repls
        autocmd FileType julia nnoremap <F10> :call SendLine("include(\"".expand("%")."\")")<CR>
    augroup END

term-repl.vim tries to guess the REPL by using the syntax name. In some cases
e.g. python, the REPL differs from the syntax name. To change the REPL loaded
`b:REPL` has to be set, interactively or in an autocommand:

    autocmd FileType python let b:REPL ='ipython'
