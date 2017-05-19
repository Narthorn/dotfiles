se rnu ai ts=4 sw=4 pt=<F2> mouse=a
se vi='100,s10,h

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

filetype plugin on
se path+=**
