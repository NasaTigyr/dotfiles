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

" == Colorscheme ==
colorscheme slate

" == Key mappings ==
let mapleader = " " 
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
" Use leader + l to compile
"nnoremap <leader>ll :VimtexCompile<CR>

" Use leader + v to view PDF
"nnoremap <leader>lv :VimtexView<CR>

nnoremap <silent> <LEFT> :vertical resize -2 <CR>
nnoremap <silent> <RIGHT> :vertical resize +2 <CR>
nnoremap <silent> <UP> :resize -2 <CR>
nnoremap <silent> <DOWN> :resize +2 <CR>
nnoremap <silent> K :call ShowDocumentation()<CR>

nnoremap <leader>cd :Ex<CR>

nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<Space>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :Helptags<CR>

nnoremap y "ay
vnoremap y "ay
nnoremap p "ap
vnoremap p "ap

nnoremap yp "+y
vnoremap yp "+y
nnoremap pp "+p
vnoremap pp "+p

" Go to definition
nmap <silent> gd <Plug>(coc-definition)

" Find references
nmap <silent> gr <Plug>(coc-references)

" Show hover documentation
nmap <silent> K :call CocActionAsync('doHover')<CR>

" Rename symbol
nmap <leader>rn <Plug>(coc-rename)

" == Plugins ==
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'       " Sensible defaults
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }  " Fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}      " LSP client
Plug 'lervag/vimtex'

call plug#end()

command! CreateLatexDoc  call CreateLatexDoc()
function! CreateLatexDoc()
execute 'normal! o\documentclass{article}'
execute 'normal! o'
execute 'normal! o\title{My first document}'
execute 'normal! o\date{2013-09-01}'
execute 'normal! o\author{John Doe}'
execute 'normal! o'
execute 'normal! o\begin{document}'
execute 'normal! o\maketitle'
execute 'normal! o\newpage'
execute 'normal! o'
execute 'normal! oHello World!'
execute 'normal! o\end{document}'
endfunction

let g:vimtex_view_method = 'zathura'
