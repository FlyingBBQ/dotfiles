"
" FlyingBBQ » nvim
"

" ==========# Plugins #==========
call plug#begin('~/.local/share/nvim/plugged')

" Visual
Plug 'flyingbbq/darcula'
Plug 'unblevable/quick-scope'

" Motions
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'

" Steroids
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

" Autocomplete
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" LaTeX
Plug 'lervag/vimtex'

" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

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
set completeopt=menuone,noselect
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

command! Tb8 :set tabstop=8 shiftwidth=8 softtabstop=8
command! Tb4 :set tabstop=4 shiftwidth=4 softtabstop=4

" Themes and Colors
set background=dark
set termguicolors
colorscheme darcula

" Add highlighting to C header files
autocmd BufRead,BufNewFile *.h set filetype=c

" ==========# Mappings #==========
" Make double <Esc> clear search highlights
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>

" Make comments C89 compatible
nnoremap <F9> :%s,//\(.*\),/*\1 */,gc

" Search (and replace) the word under the cursor
nnoremap <Leader>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
" Search (and replace) the selected text
vnoremap <Leader>r "hy:%s/<C-r>h//gc<left><left><left>

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

" Move line up and down in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

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

" Commands to edit and source init.vim
command! Vime :sp $MYVIMRC
command! Vims :so $MYVIMRC

" ==========# Plugin Settings #==========
" fzf stuff
let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.6, 'highlight': 'NvimFloat' } }
let g:fzf_preview_window = ['right:50%:hidden', 'ctrl-l']
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

" Vsnip stuff
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" LaTeX stuff
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_fold_enabled = 1
let g:vimtex_indent_enabled = 0

" Quick-scope stuff
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_hi_priority = 1

let g:mkdp_browser = 'chromium'
let g:mkdp_page_title = '${name}'

" Load lua configuration
lua require('config')
