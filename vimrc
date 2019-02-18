set nocompatible
syntax enable
filetype plugin indent on

call plug#begin('~/.vim/plugged')

" Syntax/highlighting
Plug 'chase/vim-ansible-yaml'
"Plug 'digitaltoad/vim-jade'
"Plug 'groenewege/vim-less'
Plug 'hail2u/vim-css3-syntax'
"Plug 'kchmck/vim-coffee-script'
Plug 'leafgarland/typescript-vim'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'othree/html5.vim'
Plug 'rodjek/vim-puppet'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-git'
Plug 'zah/nim.vim'

" Text manipulation
Plug 'godlygeek/tabular'

call plug#end()

"colorscheme base16-bright
highlight LineNr ctermfg=grey
let base16colorspace=256
set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set backspace=indent,eol,start
set display+=lastline
set encoding=utf-8
set expandtab
set incsearch
set laststatus=2
set modelines=5
"set mouse=a
set number
set omnifunc=syntaxcomplete#Complete
set path+=**
set ruler
set shiftwidth=2
set smarttab
set splitbelow
set splitright
set softtabstop=2
set tabpagemax=50
set tabstop=2
set wildmenu

command! MakeTags !ctags -R .
