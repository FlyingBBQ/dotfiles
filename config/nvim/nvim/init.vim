"
" FlyingBBQ - nvim
"

call plug#begin('~/.local/share/nvim/plugged')

Plug 'morhetz/gruvbox'
Plug 'bling/vim-bufferline'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'mhinz/vim-signify'

Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'

Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

Plug 'shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'shougo/deoplete-clangx'

Plug 'lervag/vimtex'
Plug 'vimwiki/vimwiki'

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
set scrolloff=2
set sidescrolloff=5
set updatetime=500

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
let g:gruvbox_termcolors = 16
let g:gruvbox_improved_strings = 0
colorscheme gruvbox
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 0
let g:airline_symbols_ascii = 1
let g:airline_inactive_collapse = 1
let g:bufferline_modified = '[+]'
let g:bufferline_echo = 0
let g:bufferline_solo_highlight = 1
"highlight! link CursorLineNr GruvboxYellowBold

" Keybindings (toggles)
nnoremap <F2> :<C-u>NERDTreeToggle<CR>
nnoremap <F3> :<C-u>TagbarToggle<CR>
nnoremap <F4> :<C-u>VimtexTocOpen<CR>
nnoremap <F5> :<C-u>call ToggleGuides()<CR>
nnoremap <F6> :<C-u>set relativenumber!<CR>

" Make double-<Esc> clear search highlights
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>

" Easy buffer switching (vanilla)
"nnoremap <leader>b :ls<cr>:b<space>

" Make comments C89 compatible
nnoremap <F9> :/\/\/<CR>xxi/*<Esc>A */<Esc>

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

" Function to toggle guides, mapped to F5
let s:enaguides = 1
function! ToggleGuides()
    if s:enaguides
        set colorcolumn=80
        :IndentGuidesEnable
        let s:enaguides = 0
    else
        set colorcolumn=0
        :IndentGuidesDisable
        let s:enaguides = 1
    endif
endfunction

" Sneak stuff
let g:sneak#label = 1

" fzf stuff
let g:fzf_layout = { 'down': '10' }
nnoremap <C-p> :<C-u>Files<CR>
nnoremap <leader>b :<C-u>Buffers<CR>
nnoremap <leader>g :Rg <C-R><C-W><CR>

" IndentGuides stuff
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

" Signify stuff
let g:signify_vcs_list = [ 'git', 'svn' ]
let g:signify_realtime = 1
highlight SignColumn ctermbg=0
highlight link SignifyLineAdd    GruvboxGreen
highlight link SignifySignAdd    GruvboxGreen
highlight link SignifyLineChange GruvboxAqua
highlight link SignifySignChange GruvboxAqua
highlight link SignifyLineDelete GruvboxRed
highlight link SignifySignDelete GruvboxRed

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

" Deoplete stuff
let g:deoplete#enable_at_startup = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
