# term-repl.vim
term-repl.vim is a neovim plugin which sends commands to a terminal opened in a
split. 

Example configuration:

    " General part
    nnoremap <F8> :call SendLine()<CR>
    vnoremap <F8> :call SendLines()<CR>
    nnoremap <F11> :call SetThisLastTerm()<CR>

    " Example implementaion for julia to include the current file
    augroup default_repls
        autocmd FileType julia nnoremap <F10> :call SendLine("include(\"".expand("%")."\")")<CR>
    augroup END
