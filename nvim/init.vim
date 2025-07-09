" == General settings ==
set nocompatible		               "to be not compatible with vi
set number			                   "set numbers
set relativenumber		               "set relative number
set mouse=a			                   "use mouse support
set clipboard=unnamedplus              "use the clipboard
set tabstop=4 shiftwidth=4 expandtab   "spcaes instead of tabs
set autoindent smartindent
syntax on			                   "enable syntax highlighting
filetype plugin indent on 	           "Enamble filetype detection

"set cursorcolumn 
set cursorline
" == Search ==
set ignorecase                         "case insensitive search
set smartcase                          "unless u use capitas
set incsearch                          "Incremental search
set hlsearch			               "Highlight search matches
highlight Comment cterm=NONE ctermfg=grey guifg=#808080

" == Colorscheme ==
  colorscheme slate

" == Key bindings ==
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" Use leader + l to compile
nnoremap <leader>ll :VimtexCompile<CR>

" Use leader + v to view PDF
nnoremap <leader>lv :VimtexView<CR>

let $FZF_DEFAULT_OPTS = '--bind=ctrl-j:down,ctrl-k:up'

nnoremap <silent> <LEFT> :vertical resize -2 <CR>
nnoremap <silent> <RIGHT> :vertical resize +2 <CR>
nnoremap <silent> <UP> :resize -2 <CR>
nnoremap <silent> <DOWN> :resize +2 <CR>
nnoremap <silent> K :call ShowDocumentation()<CR>

"nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
"" Do default action for previous item
"nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
"
"" Find files using Telescope command-line sugar.
"nnoremap <leader>ff <cmd>Telescope find_files<cr>
"nnoremap <leader>fg <cmd>Telescope live_grep<cr>
"nnoremap <leader>fb <cmd>Telescope buffers<cr>
"nnoremap <leader>fh <cmd>Telescope help_tags<cr>
"
"" Using Lua functions
"nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
"nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
"nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
"nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" FZF replacements for Telescope
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<Space>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :Helptags<CR>

nnoremap y "ay
vnoremap y "ay
nnoremap py "ap
vnoremap py "ap

nnoremap yp "+y
vnoremap yp "+y
nnoremap pp "+p
vnoremap pp "+p

" == Plugins ==
call plug#begin('~/.local/share/nvim/plugged')

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }

"autocomplete shit 
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neovim/nvim-lspconfig'

"vim plugs
Plug 'tpope/vim-sensible'       " Sensible defaults
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }  " Fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}      " LSP client
Plug 'lervag/vimtex'

call plug#end()


command! CreateHtmlFile call CreateHtmlTemplate()
function! CreateHtmlTemplate()
    execute 'normal! i<!DOCTYPE html>'
    execute 'normal! o<html lang="en">'
    execute 'normal! o<head>'
    execute 'normal! o    <meta charset="UTF-8">'
    execute 'normal! o    <meta name="viewport" content="width=device-width, initial-scale=1.0">'
    execute 'normal! o    <title>Document</title>'
    execute 'normal! o</head>'
    execute 'normal! o<body>'
    execute 'normal! o    <h1>Hello, World!</h1>'
    execute 'normal! o</body>'
    execute 'normal! o</html>'
    execute 'normal! gg'
endfunction

let g:vimtex_view_method = 'zathura'
