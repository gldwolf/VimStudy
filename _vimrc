source $VIMRUNTIME/vimrc_example.vim

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

"设置文件的代码形式 utf8
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,chinese,cp936

" 解决消息乱码的问题
language messages zh_CN.utf-8

"vim的菜单乱码解决
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" 设置行号
set nu

" 设置语法高亮
syntax on

" 设置高亮搜索显示
set hlsearch


" 在 insert 模式下，使用 jj 进入 normal 模式
inoremap jj <Esc>`^

" 使用 <Ctrl> + h/j/k/l 来切换窗口
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
nnoremap <space> viw
inoremap <C-d> <Esc>ddO

" 使用 moring 配色方案
" colorscheme morning

set helplang=cn           "设置中文帮助
set history=500           "保留历史记录
set tabstop=4             "设置tab的跳数
set guifont=Courier\ New:h14    "设置字体为Monaco，大小16
set wrap                  "设置自动换行
"set nowrap               "设置不自动换行
set scrolloff=5           "在光标接近底端或顶端时，自动下滚或上滚
set guioptions-=T           " 隐藏工具栏
"set guioptions-=m           " 隐藏菜单栏
set autoread    "设置当文件在外部被修改，自动更新该文件


"===========================
"查找/替换相关的设置
"===========================
set hlsearch "高亮显示查找结果
set incsearch "增量查找

"===========================
"状态栏的设置
"===========================
set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]       "显示文件名：总行数，总的字符数
set ruler                 "在编辑过程中，在右下角显示光标位置的状态行

"===========================
"代码设置
"===========================
set showmatch "设置匹配模式，相当于括号匹配
set smartindent "智能对齐
"set shiftwidth=4 "换行时，交错使用4个空格
set autoindent "设置自动对齐
set ai! "设置自动缩进
"set cursorcolumn "启用光标列
set cursorline  "启用光标行
set guicursor+=a:blinkon0 "设置光标不闪烁
set fdm=indent "