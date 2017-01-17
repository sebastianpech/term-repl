" term-repl.vim - Neovim REPL Support
" Author:       Sebastian Pech
" Version:      0.1

" Sends a text to the terminal defined in last_term_job_id.
function! SendToLastTerm(text)
    call jobsend(g:last_term_job_id,a:text)
endfunction

" Reads the lines from visual selection or reads the current line from buffer.
" Alternatively a specific command can be passed.
" In case last_term_job_id was not set, the function opens a new Terminal.
" In case an error occurs it spawns a new terminal an retries once.
function! SendLine(...)
    if !exists("g:last_term_job_id")
        botright new | terminal
    endif
    if a:0 == 0
        let line = getline(".")
    else
        let line = a:1
    endif
    try
        call SendToLastTerm(line."\r")
    catch
        botright new | terminal
        call SendToLastTerm(line."\r")
    endtry
endfunction

" Just a wrapper for correct visual mode semantics.
function! SendLines()
    call SendLine()
endfunction

" Sets the current terminal as last id.
function! SetThisLastTerm()
    let g:last_term_job_id = b:terminal_job_id
endfunction

" Let and unlet the terminal id on terminal open.
au TermOpen * let g:last_term_job_id = b:terminal_job_id
au TermClose * unlet g:last_term_job_id
