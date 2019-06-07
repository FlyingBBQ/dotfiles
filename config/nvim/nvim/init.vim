"
" FlyingBBQ - nvim
"

" === Plugins ===
" ^^^^^^^^^^^^^^^
call plug#begin('~/.local/share/nvim/plugged')

" * Visual
Plug 'gruvbox-community/gruvbox'

" * Motions
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'

" * Steroids
Plug 'junegunn/fzf.vim'

call plug#end()

" === Settings ===
" ^^^^^^^^^^^^^^^^
filetype plugin on
filetype indent on
syntax enable

" * General/Misc
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

" * Tabs
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" * Themes and Colors
set background=dark
let g:gruvbox_termcolors = 16
let g:gruvbox_improved_strings = 0
colorscheme gruvbox

" === Mappings ===
" ^^^^^^^^^^^^^^^^
" * Make double-<Esc> clear search highlights
nnoremap <return> :<C-u>nohlsearch<return><esc>
"nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>

" * Make comments C89 compatible
nnoremap <F9> :%s,//\(.*\),/*\1 */,gc

" * Search (and replace) the word under the cursor
nnoremap <Leader>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

" * Map for destroying trailing whitespace cleanly
nnoremap <Leader>t :let _save_pos=getpos(".") <Bar>
    \ :let _s=@/ <Bar>
    \ :%s/\s\+$//e <Bar>
    \ :let @/=_s <Bar>
    \ :nohl <Bar>
    \ :unlet _s<Bar>
    \ :call setpos('.', _save_pos)<Bar>
    \ :unlet _save_pos<CR><CR>

" * Automatically close brackets
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" === Functions ===
" ^^^^^^^^^^^^^^^^^
" * Function to toggle guides, mapped to F5
function! ToggleGuides()
    if &colorcolumn
        set colorcolumn=0
    else
        set colorcolumn=80
    endif
endfunction
nnoremap <F5> :<C-u>call ToggleGuides()<CR>

" === Plugin Settings ===
" ^^^^^^^^^^^^^^^^^^^^^^^
" * fzf stuff
let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'down': '10' }
nnoremap <C-p> :<C-u>Files<CR>
nnoremap <leader>b :<C-u>Buffers<CR>
nnoremap <leader>g :<C-u>Rg <C-R><C-W><CR>
nnoremap <leader>f :<C-u>BLines<CR>

" === Statusline ===
" ^^^^^^^^^^^^^^^^^^
set laststatus=2
set statusline=

function! StatusActive()
    " * left side
    setlocal statusline=
    setlocal statusline+=%#StatusActive#
    setlocal statusline+=[
    setlocal statusline+=%{NofBuffers()}
    setlocal statusline+=]
    setlocal statusline+=%#statusLineNC#
    setlocal statusline+=\ %t
    setlocal statusline+=%m%r

    " * right side
    setlocal statusline+=%=
    setlocal statusline+=%#statusLine#
    setlocal statusline+=%4.p%%
    setlocal statusline+=\ %#StatusActive#
    setlocal statusline+=[
    setlocal statusline+=%3l/%L\ ::
    setlocal statusline+=%3.c
    setlocal statusline+=]
endfunction

function! StatusInactive()
    " * left side
    setlocal statusline=
    setlocal statusline+=%#StatusInactive#
    setlocal statusline+=[
    setlocal statusline+=%{NofBuffers()}
    setlocal statusline+=]
    setlocal statusline+=%#statusLineNC#
    setlocal statusline+=\ %t
    setlocal statusline+=%m%r

    " * right side
    setlocal statusline+=%=
    "setlocal statusline+=%#statusLine#
    setlocal statusline+=%4.p%%
    setlocal statusline+=\ %#StatusInactive#
    setlocal statusline+=[
    setlocal statusline+=%3l/%L\ ::
    setlocal statusline+=%3.c
    setlocal statusline+=]
endfunction

" * statusline functions
function! NofBuffers()
    return len(getbufinfo({'buflisted':1}))
endfunction

" * colors
hi StatusActive ctermbg=7 ctermfg=0
hi StatusInactive ctermbg=237 ctermfg=7
hi User2 ctermbg=237 ctermfg=7
hi User3 ctermbg=239 ctermfg=15

" * statusline autocmd
augroup status
    autocmd!
    autocmd WinEnter,BufEnter * call StatusActive()
    autocmd WinLeave,BufLeave * call StatusInactive()
augroup END

call StatusActive()
