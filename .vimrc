" 设置行号
set nu

" 设置语法高亮
syntax on

" 设置高亮搜索显示
set hlsearch

" 在 insert 模式下，使用 jj 进入 normal 模式
inoremap jj <Esc>

" 使用 <Ctrl> + h/j/k/l 来切换窗口
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap ff <C-f>

" 使用 moring 配色方案
colorscheme morning
