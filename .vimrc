" == General settings ==
set nocompatible		       "to be not compatible with vi
set number			       "set numbers
set relativenumber		       "set relative number
set mouse=a			       "use mouse support
set clipboard=unnamedplus              "use the clipboard
set tabstop=4 shiftwidth=4 expandtab   "spcaes instead of tabs
set autoindent smartindent
syntax on			       "enable syntax highlighting
filetype plugin indent on 	       "Enamble filetype detection

" == Search ==
set ignorecase                         "case insensitive search
set smartcase                          "unless u use capitas
set incsearch                          "Incremental search
set hlsearch			       "Highlight search matches

" == Colorscheme ==
colorscheme slate

" == Key mappings ==
"nnoremap <Space> <Nop>
"let mapleader = " " 

" == Plugins ==
"
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'       " Sensible defaults
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }  " Fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}      " LSP client
call plug#end()
