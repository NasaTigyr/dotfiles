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

" == Cyrilic support ==
" Vim Cyrillic setup
set encoding=utf-8
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0

" Let word motions and search work in Cyrillic
set langmap=АA,аa,БB,бb,ВV,вv,ГG,гg,ДD,дd,ЕE,еe,ЗZ,зz,ИI,иi,ЙJ,йj,КK,кk,ЛL,лl,МM,мm,НN,нn,ОO,оo,ПP,пp,РR,рr,СS,сs,ТT,тt,УU,уu,ФF,фf,ХH,хh,ЦC,цc,ЧQ,чq,ШW,шw,ЩX,щx,Ъ\",ъ\",ЫY,ыy,Ь',ь',ЭE,эe,ЮU,юu,ЯA,яa
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

" FZF replacements for Telescope
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

Plug 'ThePrimeagen/vim-be-good'

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
