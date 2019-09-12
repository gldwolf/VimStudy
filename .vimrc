" *********************
"       基本设置
" *********************
set nu            " 显示行号
syntax on         " 打开语法高亮
set showmatch     " 设置匹配模式，相当于括号匹配
set smartindent   " 智能对齐
set hlsearch      " 设置高亮搜索显示
set ai"[!]        "设置自动缩进, 后面的 ！表示的是如果当前为自动缩进模式，那么就切换为不自动缩进模式
" 设置文件的编码方式为 utf-8
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,chinese,cp936
set wrap          " 设置自动换行
set autochdir     " 自动切换当前目录为正在编辑的文件所在的目录
set scrolloff=5   " 设置在光标接近底部或成顶部时自动上滚或下滚
set incsearch     " 设置增量查找
set foldmethod=indent   " 设置代码的折叠方式，换进行折叠

" **********************
"         映射
" **********************
" +++++++ 设置 <leader> 键，来辅助 +++++++++++
let mapleader=","


" ======= insert 模式 =======
inoremap jj <Esc>`^       " 在 insert 模式下，使用 jj 进入 normal 模式，并返回到原来的光标位置
inoremap <C-d> <Esc>ddO   " 在 insert 模式下使用 Ctrl + d 来删除一行
innoremap <leader>w <Esc>:w<cr> " 在 insert 模式下使用 , + w 来将缓冲区写入到文件（即保存）

" ======= normal 模式 =======
" 使用 <Ctrl> + h/j/k/l 来切换窗口
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
nnoremap <space> viw        " 使用空格键来选定一个单词
nnoremap <leader>w :w<cr>   " 在 normal 模式下使用 , + w 来将缓冲区写入到文件

" 使用 moring 配色方案
" colorscheme morning


