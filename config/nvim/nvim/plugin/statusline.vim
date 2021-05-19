set laststatus=2
set statusline=

" statusline functions
function! StatusActive()
    " left side
    setlocal statusline=
    setlocal statusline+=%#StatusInverse#
    setlocal statusline+=[%{StatusNofBuffers()}]
    setlocal statusline+=%#StatusInactive#\ ::
    setlocal statusline+=%#StatusActive#\ %t
    setlocal statusline+=%#StatusInactive#\ ::
    setlocal statusline+=\ %{StatusGitStatus()}
    setlocal statusline+=%#StatusActive#%h%m%r
    " right side
    setlocal statusline+=%=
    setlocal statusline+=%#StatusInactive#
    "setlocal statusline+=%{coc#status()}
    setlocal statusline+=\ %#StatusActive#
    setlocal statusline+=%4.p%%
    setlocal statusline+=\ %#StatusActive#
    if g:indent_warning
        setlocal statusline+=%#StatusWarn#
        setlocal statusline+=%{StatusMixedIndent()}
        setlocal statusline+=%{StatusTrailingSpace()}
    endif
    setlocal statusline+=%#StatusInverse#
    setlocal statusline+=[%3l/%L\ ::%3.c]
    " enable the cursorline
    setlocal cursorline
endfunction

function! StatusInactive()
    " left side
    setlocal statusline=
    setlocal statusline+=%#StatusInactive#
    setlocal statusline+=[%{StatusNofBuffers()}]
    setlocal statusline+=\ ::\ %t\ ::
    setlocal statusline+=\ %h%m%r
    " right side
    setlocal statusline+=%=
    setlocal statusline+=%4.p%%
    setlocal statusline+=[%3l/%L\ ::%3.c]
    " disable the cursorline
    setlocal nocursorline
endfunction

function! StatusNofBuffers()
    return len(getbufinfo({'buflisted':1}))
endfunction

function! StatusGitStatus()
    let symbols = ['+', '-', '~']
    let [added, modified, removed] = sy#repo#get_stats()
    let stats = [added, removed, modified]  " reorder
    let hunkline = ''

    for i in range(3)
        if stats[i] > 0
            let hunkline .= printf('%s%s ', symbols[i], stats[i])
        endif
    endfor

    if !empty(hunkline)
        let hunkline = printf('[%s]', hunkline[:-2])
    endif

    return hunkline
endfunction

function! StatusTrailingSpace()
    if !exists("b:status_trailing_space")
        let spaces = search('\s\+$', 'nw')

        if spaces > 0
            let b:status_trailing_space = printf("[trailing :: %d]", spaces)
        else
            let b:status_trailing_space = ''
        endif
    endif
    return b:status_trailing_space
endfunction

function! StatusMixedIndent()
    if !exists("b:status_mixed_indent")
        let tabs = search('^\t', 'nw')
        let spaces = search('^ ', 'nw')

        if tabs && spaces
            let b:status_mixed_indent = printf("[mixed-indent :: %d]", tabs)
        else
            let b:status_mixed_indent = ''
        endif
    endif
    return b:status_mixed_indent
endfunction

" statusline colors
highlight link StatusInverse TermCursor
highlight link StatusActive StatusLine
highlight link StatusInactive StatusLineNC
highlight link StatusWarn Visual

" statusline autocmd
augroup status
    autocmd!
    autocmd WinEnter,BufEnter * call StatusActive()
    autocmd WinLeave,BufLeave * call StatusInactive()
    autocmd CursorHold,BufWritePost * unlet! b:status_trailing_space
    autocmd CursorHold,BufWritePost * unlet! b:status_mixed_indent
augroup END

call StatusActive()
