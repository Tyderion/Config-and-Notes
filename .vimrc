set number
autocmd FileType yaml setlocal ts=2 sw=2 sts=2 expandtab
syntax on
set nowrap
set backspace=indent,eol,start
set autoindent
set copyindent
set shiftround
set showmatch
set ignorecase
set smartcase
set smarttab
set hlsearch
set incsearch
set history=500
set undolevels=500
set wildignore=*.swp,*.bak,*.pyc,*.class
set title
set visualbell
set noerrorbells
set nobackup
set runtimepath^=~/.vim/plugin/*
set mouse=a

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'vim-scripts/ZoomWin'
Plug 'kien/ctrlp.vim'
call plug#end()
"autocmd VimEnter * PlugInstall --sync | source $MYVIMRC

