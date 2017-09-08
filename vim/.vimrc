se number relativenumber
se smartindent
se tabstop=4 shiftwidth=4
se pastetoggle=<F2>
se mouse=a
se ttymouse=urxvt
se viminfo='100,s10,h
se incsearch hlsearch
se cursorline
se wildmenu
syntax on
color thorn

inoremap <Left>  <NOP>
inoremap <Right> <NOP>
inoremap <Up>    <NOP>
inoremap <Down>  <NOP>

"urxvt translates Application key to this
noremap [29~ <NOP>

"move ugly swap files
set backupdir=~/.cache/vim,/tmp
set directory=~/.cache/vim,/tmp

"Vundle
filetype off
se rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
call vundle#end()

"tags conf
nmap <silent> <leader>b :TagbarToggle<CR>

"quicklist navigation
nmap <C-n> :cn<CR>
nmap <C-p> :cp<CR>

"run line in bash
nmap <C-h> :.w !bash<CR>
nmap <C-l> yyp!!bash<CR>

"save as root
nmap ZR :w !sudo tee %<CR>

filetype plugin indent on
se path+=**
