" FlyingBBQ - nvim

call plug#begin('~/.local/share/nvim/plugged')

Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'
Plug 'lervag/vimtex'
Plug 'https://github.com/vimwiki/vimwiki.git'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --system-libclang --tern-completer' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'godlygeek/tabular'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'

call plug#end()

filetype plugin on
filetype indent on
syntax enable

" General/Misc
set clipboard+=unnamedplus
set cursorline
set mouse=a
set number
set relativenumber
set ruler
set showcmd

" Tabs
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Folds
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent

" Themes and Colors
set background=dark
let g:gruvbox_termcolors=16
let g:gruvbox_improved_strings=0
colorscheme gruvbox
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 0
let g:airline_symbols_ascii = 1
let g:bufferline_modified = '[+]'
let g:bufferline_echo = 0
let g:bufferline_solo_highlight = 1

" Keybindings (toggles)
nnoremap <F2> :NERDTreeToggle<CR>
nnoremap <F3> :TagbarToggle<CR>
nnoremap <F4> :VimtexTocOpen<CR>
nnoremap <F5> :IndentGuidesToggle<CR>
nnoremap <F6> :set relativenumber!<CR>

" Make double-<Esc> clear search highlights
nnoremap <Esc><Esc> :nohlsearch<CR>

" Easy buffer switching
nnoremap <leader>b :ls<cr>:b<space>

" Easymotion stuff
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
map  <leader>  <Plug>(easymotion-prefix)
map  <Leader>f <Plug>(easymotion-bd-fl)
map  <Leader>w <Plug>(easymotion-bd-wl)
nmap <leader>s <Plug>(easymotion-overwin-f2)

" CtrlP stuff
let g:ctrlp_show_hidden = 1
let g:Ctrlp_custom_ignore = '.git'

" Indent Guides stuff
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

" LaTeX stuff
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_fold_enabled = 1
let g:vimtex_indent_enabled = 0

" VimWiki stuff
let wiki_1 = {'path': '~/documents/vimwiki/', 'diary_rel_path': '.diary/'}
let wiki_2 = {'path': '~/thesis/wiki/'}
let g:vimwiki_list = [wiki_1, wiki_2]
let g:vimwiki_folding = 'expr'

" YouCompleteMe
autocmd FileType c      let g:ycm_global_ycm_extra_conf = "~/.config/nvim/ycm/c/.ycm_extra_conf.py"
autocmd FileType cpp    let g:ycm_global_ycm_extra_conf = "~/.config/nvim/ycm/cpp/.ycm_extra_conf.py"
let g:ycm_auto_trigger = 1
let g:ycm_show_diagnostics_ui = 1
