"
" FlyingBBQ » nvim
"

" ==========# Plugins #==========
call plug#begin('~/.local/share/nvim/plugged')

" Visual
Plug 'gruvbox-community/gruvbox'

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

" * Themes and Colors
set background=dark
let g:gruvbox_termcolors = 16
let g:gruvbox_improved_strings = 0
colorscheme gruvbox

" ==========# Mappings #==========
" Make double-<Esc> clear search highlights
"nnoremap <return> :<C-u>nohlsearch<return><esc>
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>

" Make comments C89 compatible
nnoremap <F9> :%s,//\(.*\),/*\1 */,gc

" Search (and replace) the word under the cursor
nnoremap <Leader>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

" Map for destroying trailing whitespace cleanly
nnoremap <Leader>t :let _save_pos=getpos(".") <Bar>
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

" ==========# Functions #==========
" Function to toggle guides, mapped to F5
function! ToggleGuides()
    if &colorcolumn
        set colorcolumn=0
        let g:indent_warning = 0
        call StatusActive()
    else
        set colorcolumn=80
        let g:indent_warning = 1
        call StatusActive()
    endif
endfunction
let g:indent_warning = 0
nnoremap <F5> :<C-u>call ToggleGuides()<CR>

" command to edit init.vim
command! Vimrc :sp $MYVIMRC

" ==========# Plugin Settings #==========
" fzf stuff
let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'down': '10' }
nnoremap <C-p> :<C-u>Files<CR>
nnoremap <leader>b :<C-u>Buffers<CR>
nnoremap <leader>g :<C-u>Rg <C-R><C-W><CR>
nnoremap <leader>f :<C-u>BLines<CR>
nnoremap <leader>q :<C-u>Help<CR>

" Signify stuff
let g:signify_vcs_list = [ 'git', 'svn' ]
let g:signify_realtime = 1
let g:signify_update_on_focusgained = 1
let g:signify_cursorhold_normal = 0
let g:signify_cursorhold_insert = 0
highlight SignColumn ctermbg=0
highlight link SignifyLineAdd    GruvboxGreen
highlight link SignifySignAdd    GruvboxGreen
highlight link SignifyLineChange GruvboxAqua
highlight link SignifySignChange GruvboxAqua
highlight link SignifyLineDelete GruvboxRed
highlight link SignifySignDelete GruvboxRed

" Coc stuff
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" use <tab> for trigger completion and navigate to the next complete item
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

nnoremap <silent> gi :<C-u>CocList diagnostics<cr>
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>cr  <Plug>(coc-rename)

let g:coc_global_extensions = ['coc-python', 'coc-json', 'coc-vimlsp']

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
    setlocal statusline+=%#StatusActive#
    setlocal statusline+=[%{StatusNofBuffers()}]
    setlocal statusline+=%#statusLineNC#\ ::
    setlocal statusline+=%2*\ %t
    setlocal statusline+=%#statusLineNC#\ ::
    setlocal statusline+=\ %{StatusGitStatus()}%h
    setlocal statusline+=%4*%m
    setlocal statusline+=%5*%r
    " right side
    setlocal statusline+=%=
    setlocal statusline+=%#statusLineNC#
    setlocal statusline+=%{coc#status()}
    setlocal statusline+=\ %#statusLine#
    setlocal statusline+=%4.p%%
    setlocal statusline+=\ %#statusLine#
    if g:indent_warning
        setlocal statusline+=%6*
        setlocal statusline+=%{StatusMixedIndent()}
        setlocal statusline+=%{StatusTrailingSpace()}
    endif
    setlocal statusline+=%#StatusActive#
    setlocal statusline+=[%3l/%L\ ::%3.c]
    " enable the cursorline
    setlocal cursorline
endfunction

function! StatusInactive()
    " left side
    setlocal statusline=
    setlocal statusline+=%#StatusInactive#
    setlocal statusline+=[%{StatusNofBuffers()}]
    setlocal statusline+=%#statusLineNC#
    setlocal statusline+=\ ::\ %t\ ::
    setlocal statusline+=\ %h%m%r
    " right side
    setlocal statusline+=%=
    setlocal statusline+=%4.p%%
    setlocal statusline+=\ %#StatusInactive#
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
hi StatusActive     ctermbg=7   ctermfg=0
hi StatusInactive   ctermbg=237 ctermfg=7
hi User2 cterm=bold ctermbg=237 ctermfg=15
hi User3 ctermbg=239 ctermfg=15
hi User4 ctermbg=237 ctermfg=11
hi User5 ctermbg=237 ctermfg=9
hi User6 ctermbg=3 ctermfg=0

" statusline autocmd
augroup status
    autocmd!
    autocmd WinEnter,BufEnter * call StatusActive()
    autocmd WinLeave,BufLeave * call StatusInactive()
    autocmd CursorHold,BufWritePost * unlet! b:status_trailing_space
    autocmd CursorHold,BufWritePost * unlet! b:status_mixed_indent
augroup END

call StatusActive()
