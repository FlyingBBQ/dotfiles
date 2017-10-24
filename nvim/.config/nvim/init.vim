" FlyingBBQ - nvim

call plug#begin('~/.local/share/nvim/plugged')

Plug 'morhetz/gruvbox'
Plug 'lervag/vimtex'
Plug 'https://github.com/vimwiki/vimwiki.git'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --system-libclang --tern-completer' }
Plug 'majutsushi/tagbar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ctrlpvim/ctrlp.vim'

call plug#end()

filetype plugin on
filetype indent on
syntax enable

set clipboard+=unnamedplus
set cursorline
set mouse=a
set number
set ruler
set showcmd             " show command in bottom bar

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

set foldenable          " enable folding
set foldlevelstart=10   " open level of folds
set foldnestmax=10      " 10 nested folds max
set foldmethod=indent   " fold based on indent level

" themes and colors
let g:gruvbox_termcolors=16
let g:airline_theme='gruvbox'
colorscheme gruvbox
set background=dark

" move vertically by visual line
nnoremap j gj
nnoremap k gk
nnoremap <leader>t :TagbarToggle<CR>
nnoremap <leader>f :NERDTreeToggle<CR>

" NERDTree stuff
let NERDTreeShowHidden = 1

" airline stuff
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#fnamemod = ':t'

" CtrlP stuff
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = '.git'

" LaTeX stuff
let g:tex_flavor = "latex"
let g:vimtex_view_method = 'zathura'
let g:vimtex_fold_enabled = 0
let g:vimtex_indent_enabled = 0

" VimWiki stuff
let g:vimwiki_list = [{'path': '~/documents/vimwiki/'}]
let g:vimwiki_folding = 'expr'

" YouCompleteMe
autocmd FileType c      let g:ycm_global_ycm_extra_conf = "~/.config/nvim/ycm/c/.ycm_extra_conf.py"
autocmd FileType cpp    let g:ycm_global_ycm_extra_conf = "~/.config/nvim/ycm/cpp/.ycm_extra_conf.py"
let g:ycm_auto_trigger = 1
let g:ycm_show_diagnostics_ui = 1
