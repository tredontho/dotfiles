set number
set ruler
" Indentation/tab related settings
set tabstop=2
set softtabstop=2
set shiftwidth=0 " use same value as tabstop
set expandtab
set autoindent

set path+=**
syntax enable
set background=dark

" Some split settings
set splitbelow
set splitright

packadd! matchit

" Plugins

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/vimplugs')

Plug 'purescript-contrib/purescript-vim'
Plug 'tpope/vim-fugitive'
Plug 'altercation/vim-colors-solarized'
Plug 'freitass/todo.txt-vim'
Plug 'jceb/vim-orgmode'
Plug 'christoomey/vim-tmux-navigator'

call plug#end()

" Needed on WSL
" set term=screen-256color " vim only?
" set t_ut=
let g:solarized_termcolors=256

colorscheme solarized

" Uncomment to highlight trailing whitespace
"highlight ExtraWhitespace ctermbg=red guibg=red
"match ExtraWhitespace /\s\+$/
