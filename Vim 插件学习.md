# Vim 插件学习

>  Vim 插件是使用 vimscript 或者其他语言编写的 vim 功能扩展
> 常见的 vim 插件管理器有：vim-plug, Vundle, Pathogen, Dein.Vim, volt 等，推荐使用 vim-plug
> 网址：https://github.com/junegunn/vim-plug

## 1 插件管理器的安装（vim-plug）

1. Unix 下：

  ``` shell
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  ```

2. Windows 下（PowerShell）：

   ``` shell
   md ~\vimfiles\autoload
   $uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
   (New-Object Net.WebClient).DownloadFile(
    $uri,
    $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
    "~\vimfiles\autoload\plug.vim")
   )
   ```

## 2 插件管理器的使用及插件的安装

首先将 vim-plug 片段加入到 `~/.vimrc` （或者 Windows 中是 `_vimrc` ）：

1. vim-plug 片段以 `call plug#begin()` 开始
2. 所有的插件都是以 `Plug` 命令开头
3. 使用 `call plug#end()` 来更新 `&runtimepath` 和初始化插件系统

**示例**：

``` shell
" 为 vim 插件指定一个目录
" - 避免使用像 ‘plug’ 这种标准的 Vim 目录名

call plug#begin('~/.vim/plugged') " 要确保此处使用的是单引号

" 要安装的插件列表
Plug 'mhinz/vim-startify'
Plug 'scrooloose/nerdtree' " 文件目录树浏览插件
" 初始化插件系统
call plug#end()

" ********* NERDTree 插件的使用 *********"
" 如果想要 NERD tree 在软件启动的时候自动运行，需要添加以下命令：
" autocmd vimenter * NERDTree
" 只有当没有指定打开的文件时，才启动 NERD tree 插件
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
```

然后，重新加载 `.vimrc` 配置文件，再在 vim 中使用 `:PlugInstall` 来安装插件

在 .vimrc 配置文件中：

``` shell
" 添加一个映射，使用 Ctrl + n 来快速切换 NERDTree 的状态
map <C-n> :NERDTreeToggle<CR>
nnoremap <leader>v :NERDTreeFind<cr>  "使用 , + v 来快速切换到 NERD Tree 上
```

## 3 Vim 美化插件：让你的 Vim 与众不同

安装主题插件：**gruvbox**

```shell
Plug 'morhetz/gruvbox'

" 在插件安装完成后设置 colorscheme 为 gruvbox，如果在插件安装之前设置有可能会不生效
colorscheme gruvbox
```

## 4 安装 Startify 来快速打开曾经打开过的文件

1. 安装插件：

   ```shell
   Plug 'mhinz/vim-startify'
   ```

2. 配置快捷映射：

   ``` shell
   nnoremap <leader>s :Startify<cr>	" 使用 , + s 来快速开启 Startify
   ```

## 5 使用 ctrlp 配合 NERDTree 来快速切换文件

1. 安装  ctrlp :

   ```shell
   Plug 'ctrlpvim/ctrlp.vim'
   ```

2. 配置快捷映射：

   ```shell
   let g:ctrlp_map = '<c-p>'	" 使用 Ctrl + p 来快速打开 ctrlp 搜索并打开文件
   ```

   

## 6 使用 easymotion 来快速跳转到文件的任意位置

1. 安装  easymotion 插件：

   ```shell
   Plug 'easymotion/vim-easymotion'
   ```

2. 添加映射：

   ```shell
   nmap ss <Plug>(easymotion-s2)  "此处为递归映射
   ```

   