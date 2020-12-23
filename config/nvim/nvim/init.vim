"
" FlyingBBQ » nvim
"

" ==========# Plugins #==========
call plug#begin('~/.local/share/nvim/plugged')

" Visual
Plug 'doums/darcula'
Plug 'sheerun/vim-polyglot'

" Motions
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'

" Steroids
Plug 'junegunn/fzf.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

" Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" LaTeX
Plug 'lervag/vimtex'

call plug#end()

" ==========# Settings #==========
filetype plugin on
filetype indent on
syntax enable

" General/Misc
set clipboard+=unnamedplus
set cursorline
set mouse=a
set number
set relativenumber
set showcmd
set scrolloff=2
set sidescrolloff=5
set updatetime=500
set ignorecase smartcase
set lazyredraw
set inccommand=split
let mapleader = ' '

if has('persistent_undo')
    silent !mkdir ~/.local/share/nvim/undodir > /dev/null 2>&1
    set undodir=~/.local/share/nvim/undodir
    set undofile
endif

" Tabs
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

command! Tb8 :setlocal tabstop=8 shiftwidth=8 softtabstop=8
command! Tb4 :setlocal tabstop=4 shiftwidth=4 softtabstop=4

" Themes and Colors
set background=dark
set termguicolors
colorscheme darcula
highlight link diffAdded String
highlight link diffRemoved Comment
highlight link diffLine Number

" Add highlighting to C header files
autocmd BufRead,BufNewFile *.h set filetype=c

" ==========# Mappings #==========
" Make double <Esc> clear search highlights
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>

" Make comments C89 compatible
nnoremap <F9> :%s,//\(.*\),/*\1 */,gc

" Search (and replace) the word under the cursor
nnoremap <Leader>r :%s///gc<Left><Left><Left>

" Map for destroying trailing whitespace cleanly
nnoremap <Leader>w :let _save_pos=getpos(".") <Bar>
    \ :let _s=@/ <Bar>
    \ :%s/\s\+$//e <Bar>
    \ :let @/=_s <Bar>
    \ :nohl <Bar>
    \ :unlet _s<Bar>
    \ :call setpos('.', _save_pos)<Bar>
    \ :unlet _save_pos<CR><CR>

" Automatically close brackets
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" Call clang-format to format selection
map <C-K> :py3f /usr/share/clang/clang-format.py<cr>

" ==========# Functions #==========
" Function to toggle guides, mapped to F5
function! ToggleGuides()
    if &colorcolumn
        set colorcolumn=0
        let g:indent_warning = 0
        call StatusActive()
    else
        set colorcolumn=80,100
        let g:indent_warning = 1
        call StatusActive()
    endif
endfunction
let g:indent_warning = 0
nnoremap <F5> :<C-u>call ToggleGuides()<CR>

" Display the highlight group of the word under the cursor
function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
command! Syng :call SynGroup()<CR>

" command to edit init.vim
command! Vimrc :sp $MYVIMRC

" ==========# Plugin Settings #==========
" fzf stuff
let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.6, 'highlight': 'NvimFloat' } }
nnoremap <C-p> :<C-u>Files<CR>
nnoremap <leader>b :<C-u>Buffers<CR>
nnoremap <leader>g :<C-u>Rg <C-R><C-W><CR>
nnoremap <leader>f :<C-u>BLines<CR>
nnoremap <leader>t :<C-u>BTags<CR>
nnoremap <leader>q :<C-u>Help<CR>

" Signify stuff
let g:signify_vcs_list = [ 'git', 'svn' ]
let g:signify_realtime = 1
let g:signify_update_on_focusgained = 1
let g:signify_cursorhold_normal = 0
let g:signify_cursorhold_insert = 0
highlight link SignifyLineAdd    CursorLineNR
highlight link SignifySignAdd    CursorLineNR
highlight link SignifyLineChange CursorLineNR
highlight link SignifySignChange CursorLineNR
highlight link SignifyLineDelete CursorLineNR
highlight link SignifySignDelete CursorLineNR

" Coc stuff
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Use <tab> for trigger completion and navigate to the next complete item
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>cr  <Plug>(coc-rename)
nmap <leader>cs :<C-u>CocCommand clangd.switchSourceHeader<cr>

let g:coc_global_extensions = ['coc-clangd', 'coc-python', 'coc-sh']
let g:coc_global_extensions += ['coc-json', 'coc-vimlsp', 'coc-yaml']

highlight! link CocErrorSign ErrorSign
highlight! link CocWarningSign WarningSign
highlight! link CocInfoSign InfoSign
highlight! link CocHintSign InfoSign
highlight! link CocErrorFloat Pmenu
highlight! link CocWarningFloat Pmenu
highlight! link CocInfoFloat Pmenu
highlight! link CocHintFloat Pmenu
highlight! link CocHighlightText IdentifierUnderCaret
highlight! link CocHighlightRead IdentifierUnderCaret
highlight! link CocHighlightWrite IdentifierUnderCaretWrite
highlight! link CocErrorHighlight CodeError
highlight! link CocWarningHighlight CodeWarning
highlight! link CocInfoHighlight CodeInfo
highlight! link CocHintHighlight CodeHint

" LaTeX stuff
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_fold_enabled = 1
let g:vimtex_indent_enabled = 0

" ==========# Statusline #==========
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
    setlocal statusline+=%{coc#status()}
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
