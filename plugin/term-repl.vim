" term-repl.vim - Neovim REPL Support
" Author:       Sebastian Pech
" Version:      0.2

" Sends a text to the terminal defined in last_term_job_id.
function! SendToLastTerm(text)
    call jobsend(g:last_term_job_id,a:text)
endfunction

" Reads the lines from visual selection or reads the current line from buffer.
" Alternatively a specific command can be passed.
" In case last_term_job_id was not set, the function opens a new Terminal.
" In case an error occurs it spawns a new terminal an retries once.
function! SendLine(...)
    if a:0 == 0
        let line = getline(".")
    else
        let line = a:1
    endif
    call CheckTerminal()
    call SendToLastTerm(line."\r")
endfunction

" Just a wrapper for correct visual mode semantics.
function! SendLines()
    call SendLine()
endfunction

" Sets the current terminal as last id.
function! SetThisLastTerm()
    let g:last_term_job_id = b:terminal_job_id
endfunction

" Ensures a terminal is available.
" * if open and visible -> use it
" * if open but hidden -> show it 
" * if not open -> create a new from optional or syntax
function! CheckTerminal()
    " Optional argument for string in terminal title.
    " If not provided, syntax is used.
    if exists("b:REPL")
        let syn = b:REPL
    else
        let syn = &syntax
    endif
    " Get buffer id of terminal matching last_term_job_id
    if exists("g:last_term_job_id") && g:last_term_job_id != ''
        let term_buf_id = filter(range(1, bufnr('$'))
                        \ ,'getbufvar(v:val,"terminal_job_id") == ' . g:last_term_job_id)
        if len(term_buf_id) == 0
            let term_visible = 0
        else
            let term_visible = bufwinid(term_buf_id[0]) != -1
        endif
    else
        let term_visible = 0
    endif
    " If buffer is visible use it, otherwise search for one where the title is
    " contains syn.
    if term_visible == 0
        " Search for terminal buffers witch contain syn.
        let term_buf_id = filter(range(1, bufnr('$'))
                        \ ,"getbufvar(v:val,'term_title') =~ '\\c" . syn ."'")

        echo term_buf_id
        " If a terminal buffer with syn in title was found create a new
        " split below right, load the buffer and switch back to the current
        " buffer.
        " In case no buffer matching the criteria was found just open a new
        " one and run the provided command from syn.
        let currentWindow=winnr()
        botright split
        if len(term_buf_id) > 0
            exe 'b ' . term_buf_id[0]
            let g:last_term_job_id = getbufvar(term_buf_id[0],'terminal_job_id')
        else
            exe 'e term://' . syn
            let g:last_term_job_id = getbufvar('%','terminal_job_id')
        endif
        " switch back to the last split.
        exe currentWindow . "wincmd w"
    endif
endfunction
