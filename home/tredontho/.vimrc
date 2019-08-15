set number
" Indentation/tab related settings
set tabstop=2
set softtabstop=2
set shiftwidth=0 " use same value as tabstop
set expandtab
set autoindent

" Plugins

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/vimplugs')

Plug 'purescript-contrib/purescript-vim'

call plug#end()

" Uncomment to highlight trailing whitespace
"highlight ExtraWhitespace ctermbg=red guibg=red
"match ExtraWhitespace /\s\+$/
