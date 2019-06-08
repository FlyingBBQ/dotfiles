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
nnoremap <return> :<C-u>nohlsearch<return><esc>
"nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>

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
    else
        set colorcolumn=80
    endif
endfunction
nnoremap <F5> :<C-u>call ToggleGuides()<CR>

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

" ==========# Statusline #==========
set laststatus=2
set statusline=

" statusline functions
function! StatusActive()
    " left side
    setlocal statusline=
    setlocal statusline+=%#StatusActive#
    setlocal statusline+=[%{NofBuffers()}]
    setlocal statusline+=%#statusLineNC#\ ::
    setlocal statusline+=%2*\ %t
    setlocal statusline+=%#statusLineNC#\ ::
    setlocal statusline+=\ %{GitStats()}
    setlocal statusline+=%4*%m
    setlocal statusline+=%5*%r
    " right side
    setlocal statusline+=%=
    setlocal statusline+=%#statusLine#
    setlocal statusline+=%4.p%%
    setlocal statusline+=\ %#StatusActive#
    setlocal statusline+=[%3l/%L\ ::%3.c]
    " enable the cursorline
    setlocal cursorline
endfunction

function! StatusInactive()
    " left side
    setlocal statusline=
    setlocal statusline+=%#StatusInactive#
    setlocal statusline+=[%{NofBuffers()}]
    setlocal statusline+=%#statusLineNC#
    setlocal statusline+=\ ::\ %t\ ::
    setlocal statusline+=\ %m%r
    " right side
    setlocal statusline+=%=
    setlocal statusline+=%4.p%%
    setlocal statusline+=\ %#StatusInactive#
    setlocal statusline+=[%3l/%L\ ::%3.c]
    " disable the cursorline
    setlocal nocursorline
endfunction

function! NofBuffers()
    return len(getbufinfo({'buflisted':1}))
endfunction

function! GitStats()
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

" statusline colors
hi StatusActive     ctermbg=7   ctermfg=0
hi StatusInactive   ctermbg=237 ctermfg=7
hi User2 cterm=bold ctermbg=237 ctermfg=7
hi User3 ctermbg=239 ctermfg=15
hi User4 ctermbg=237 ctermfg=3
hi User5 ctermbg=237 ctermfg=9

" statusline autocmd
augroup status
    autocmd!
    autocmd WinEnter,BufEnter * call StatusActive()
    autocmd WinLeave,BufLeave * call StatusInactive()
augroup END

call StatusActive()
