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
highlight link SignifyLineAdd    CursorLineNR
highlight link SignifySignAdd    CursorLineNR
highlight link SignifyLineChange CursorLineNR
highlight link SignifySignChange CursorLineNR
highlight link SignifyLineDelete CursorLineNR
highlight link SignifySignDelete CursorLineNR

" Compe stuff
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

lua << EOF
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
EOF

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
highlight link QuickScopePrimary Visual
highlight link QuickScopeSecondary Search

" Treesitter stuff
lua <<EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "c", "rust", "go",
        "python", "bash", "lua",
        "yaml", "json",
        "comment", "rst",
    },
    highlight = {
        enable = true,
        -- disable = { "c" },
        custom_captures = {
        -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
        -- ["foo.bar"] = "Identifier",
        },
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
    indent = {
        enable = true,
        disable = { "c" },
    }
}
EOF

highlight! link TSNote Todo
highlight! link TSWarning Todo
highlight! link TSDanger Error
highlight! link TSError Error

" LSP stuff
lua << EOF
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}

require'lspconfig'.clangd.setup{
    capabilities = capabilities,
}
require'lspconfig'.pyright.setup{}
require'lspconfig'.rust_analyzer.setup{}
EOF

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
