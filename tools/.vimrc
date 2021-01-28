" vim 插件管理配置处
set nocompatible              " be iMproved, required
filetype off                  " required
 
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
 
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" vim自动缩进插件
" Plugin 'vim-scripts/indentpython.vim'
set autoindent
set cindent

" 树形目录插件
Plugin 'scrooloose/nerdtree'
" Plugin 'vim-airline/vim-airline'

Plugin 'tpope/vim-fugitive'
" 配色风格
" Plugin 'altercation/vim-colors-solarized'

" 配色风格
" Plugin 'vim-scripts/khaki.vim' 

" 注释自动生成  配置文档:https://blog.csdn.net/bodybo/article/details/78685640
" Plugin 'vim-scripts/DoxygenToolkit.vim'

" 目录生成
" Plugin 'vim-scripts/taglist.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required



" ----------------------------------------------------------------------------------
" 	插件配置
" ----------------------------------------------------------------------------------
" 设置NerdTree快捷键语法 <CR> 代表回车 <F3>代表F3
map <F3> :NERDTreeMirror<CR>
map <F3> :NERDTreeToggle<CR>

" 跳转到下一个上一个位置 与:nb :np 效果相同:ls查看缓冲区
map <F2> :bp<CR>
map <F4> :bn<CR>
" bl(buffer last)
" bf(buffer first)
" bn(buffer next)
" bp(buffer previous)
" b number(b1 b2 b3 ... / b 1 / b 2)等都是合理的

" 配色风格 solarized 配置 light dark
" syntax enable
" set background=dark

" 显示函数列表
map <F5> :TlistToggle<CR>

" 关闭当前缓冲区
map <F6> :bd <CR>

" 转到定义 <cword> 是光标所在的单词
" map <F7> :cs find c expand("<cword>") <CR>
map <F7> :cs find c <cword> <CR>

" Doxygen 一键生成文件注释
" let g:DoxygenToolkit_companyName =""
" let g:DoxygenToolkit_authorName ="dspure"

" 生成注释快捷键
" nmap <C-k>:h :DoxAuthor<CR>
" nmap <C-k>:f :Dox<CR>
" nmap <C-k>:l :DoxLic<CR>
" nmap <C-k>:b :DoxBlock<CR>
set paste
" C
autocmd FileType c nmap [ 0i/*<CR><ESC>
autocmd FileType c nmap ] i<END><CR>*/<ESC>
" C++
autocmd FileType cpp nmap [ 0i/*<CR><ESC>
autocmd FileType cpp nmap ] i<END><CR>*/<ESC>
" shell
autocmd FileType sh nmap [ 0i#<ESC>
autocmd FileType bash nmap [ 0i#<ESC>

" ----------------------------------------------------------------------------------
"  	vim基础设置
" ----------------------------------------------------------------------------------
"set nu		"显示行号
set ruler	"显示光标
set nocp	"关闭兼容模式 兼容模式默认以vi的配置启动
set ic		"不区分大小写
" set noic	"区分大小写
" set cursorline	" 添加下划线
" set mouse=nv	"cmd界面支持鼠标操作
syntax on	" 设置语法高亮

" let Tlist_Show_One_File=1	" 只显示当前文件的tags
let Tlist_WinWidth=40		" 设置taglist宽度
" let Tlist_WinHeight=12	" taglist窗口的高度
let Tlist_Exit_OnlyWindow=1	" tagList窗口是最后一个窗口，则退出Vim
" let Tlist_Use_Left_Window=1	" 在Vim窗口左侧显示taglist窗口
let Tlist_Use_Right_Window=1	" taglist窗口出现在右侧
" let Tlist_Use_SingleClick=1	" 单击tag就跳转
" let Tlist_Auto_Open=1		" 启动VIM后，自动打开taglist窗口


" autocmd VimEnter * NERDTree	" 在 vim 启动的时候默认开启 NERDTree（autocmd 可以缩写为 au）
" let NERDTreeWinPos="right"	" 将 NERDTree 的窗口设置在 vim 窗口的右侧（默认为左侧）
" let NERDTreeShowLineNumbers=1	" 显示行号
" let NERDTreeWinSize=31	" 设置宽度

" ----------------------------------------------------------------------------------
"  	插件配置
" ----------------------------------------------------------------------------------

" 配色风格khaki配置
" if !has("gui_running")                                          
" set t_Co=256                                              
" endif                                                                                         

" 设置配色方案
" colorscheme desert
" colorscheme industry 
" colorscheme khaki

"let g:DoxygenToolkit_authorName="dspure@163.com"	" 设置自动注释生成内容

"let g:airline#extensions#tabline#enabled = 1		" 显示缓冲区

" cscope 自动加载cscope.out
if has("cscope")
	set csprg=/usr/bin/cscope
	set csto=0
        set cst
        set nocsverb
	" add any database in current directory
	if filereadable("cscope.out")
		cs add cscope.out
	" else add database pointed to by environment
	elseif $CSCOPE_DB != ""
		cs add $CSCOPE_DB
	endif
	set csverb
endif

" taglist 插件加载
source ~/.vim/plugin/taglist.vim
" 自动重新加载被修改的文件
set autoread
" 显示状态栏
" set laststatus=2

let g:DoxygenToolkit_companyName="dspure"
let g:DoxygenToolkit_authorName="dspure"

