function MyTabLine()
    let s = ''
    let i = 1
    while i <= tabpagenr('$')
        " set the tab page number (for mouse clicks)
        let s .= '%' . i . 'T'

        " set the page number and color
        let s .= '%#TabLineSel#'
        let s .= ' ' . i . ' '

        " select the highlighting
        if i == tabpagenr()
            let s .= '%#TermCursor#'
        else
            let s .= '%#TabLine#'
        endif

        " the label is made by MyTabLabel()
        let s .= '%{MyTabLabel(' . i . ')}'

        let s .= '%#TabLineSep#  '
        let i += 1
    endwhile

    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
        let s .= '%=%#TabLine#%999X[X]'
    endif

    return s
endfunction

function MyTabLabel(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let bufnr = buflist[winnr - 1]

    let file = fnamemodify(bufname(bufnr), ':t')
    if file == ''
        let file = '[No Name]'
    endif

    let modified = ''
    for b in buflist
        if getbufvar(b, '&modified')
            let modified = '+'
            break
        endif
    endfor

    let nwins = tabpagewinnr(a:n, '$')
    let label = ''
    let label .= '[' . nwins . modified . ']'
    let label .= ' ' . file . ' '
    return label
endfunction

highlight! link TabLineSep Normal

set tabline=%!MyTabLine()
