" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
" }

" Environment {

    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        set nocompatible        " Must be first line
        if !WINDOWS()
            set shell=/bin/zsh
        endif
    " }
    
    " 打开自动定位到最后编辑位置 {
        if has("autocmd")
            au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
        endif
    " }

" }

" Key (re)Mappings {
    let mapleader = ';'
    vnoremap <Leader>y "+y 
    nmap <Leader>p "+p

    noremap LB ^
    noremap LE $

    map <space> /

    " 命令行模式 <C-b> 移动至行首 <C-e> 移动至行尾
    cnoremap <C-b> <Home>
    cnoremap <C-e> <End>

    " 去掉搜索高亮
    noremap <silent> <Leader>/ :nohls<CR>

    " python run {
		
        function PythonRun()
            setlocal makeprg=python\ -u  
            set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m 
            silent make %
            copen
        endfunction

        au filetype python map <F5> :w<CR>:call PythonRun()<CR>

    " }

" }

" General {

    filetype on                 " 开启文件类型侦测 
    "filetype indent on          " 根据文件类型采用不同缩进
    filetype plugin on          " 根据侦测到的不同类型加载对应的插件
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif


    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set history=1000                    " Store a ton of history (default is 20)
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator
" }

" Vim UI {

    if !WINDOWS()
        set guifont=YaHei\ Consolas\ Hybrid\ 10.5
    else
        set guifont=Consolas:h14
    endif

    set background=dark         " Assume a dark background
    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode
    set cursorline                  " Highlight current line
    set ruler                   " Show the ruler
    set showcmd                 " Show partial commands in status line and
                                " Selected characters/lines in visual mode
    set laststatus=2

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set relativenumber              " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set wildmenu                    " Show list instead of just completing
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set foldmethod=indent
	set nofoldenable

" }

" Formatting {

    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)

" }

" FileEncode Settings {
    set encoding=utf-8
    set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
    set helplang=cn
    if WINDOWS()
        set langmenu=zh_CN.UTF-8
        source $VIMRUNTIME/delmenu.vim
        source $VIMRUNTIME/menu.vim
    endif
    set termencoding=utf-8
" }

" Vundle {
    filetype off
    set rtp+=~/.vim/bundle/Vundle.vim
    " vundle 管理的插件列表必须位于 vundle#begin() 和 vundle#end() 之间
    call vundle#begin()

    Plugin 'VundleVim/Vundle.vim'
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'joshdick/onedark.vim'
    " Plugin 'python-mode/python-mode'
    Plugin 'Lokaltog/vim-powerline'
    Plugin 'Yggdroot/indentLine'
    Plugin 'tell-k/vim-autopep8'
    Plugin 'majutsushi/tagbar'
    Plugin 'scrooloose/nerdtree'
    Plugin 'fholgado/minibufexpl.vim'
    Plugin 'Shougo/neocomplete.vim'
    Plugin 'scrooloose/nerdcommenter'
    Plugin 'davidhalter/jedi-vim'
    " Plugin 'Valloric/YouCompleteMe'

    " 插件列表结束
    call vundle#end()
    filetype plugin indent on

    " colorscheme { 
        if !WINDOWS()
            let g:solarized_termtrans=1
            colorscheme solarized             " Load a colorscheme
        else
            colorscheme onedark
        endif
    " }

    " vim-powerline {
        let g:Powerline_stl_path_style = 'full'
        let g:Powerline_colorscheme='solarized256'
    " }

    " indentLine {
        " 缩进指示线
        let g:indentLine_chare='|'
        let g:indentLine_enabled=1
    " }
    
    " autopep8 {
        let g:autopep8_disable_show_diff=1
    " }

    " NeoComplete {
        let g:neocomplete#enable_at_startup = 1
        let g:neocomplete#enable_smart_case = 1
    " }

    " NERD Commenter {
        " Add spaces after comment delimiters by default
        let g:NERDSpaceDelims = 1

        " Use compact syntax for prettified multi-line comments
        let g:NERDCompactSexyComs = 1

        " Align line-wise comment delimiters flush left instead of following code indentation
        let g:NERDDefaultAlign = 'left'

        " Set a language to use its alternate delimiters by default
        let g:NERDAltDelims_java = 1

        " Add your own custom formats or override the defaults
        let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

        " Allow commenting and inverting empty lines (useful when commenting a region)
        let g:NERDCommentEmptyLines = 1

        " Enable trimming of trailing whitespace when uncommenting
        let g:NERDTrimTrailingWhitespace = 1

        " Enable NERDCommenterToggle to check all selected lines is commented or not 
        let g:NERDToggleCheckAllLines = 1

        map <F4> <plug>NERDCommenterInvert
    " }

    " MiniBufExpl {
        let g:miniBufExplorerAutoStart = 1
        noremap <C-TAB>   :MBEbn<CR>
        noremap <C-S-TAB> :MBEbp<CR>
    " }

    " NERDTree {
        " F2 开启和关闭树
        map <F2> :NERDTreeToggle<CR>
        let NERDTreeChDirMode=1
        " 显示书签
        let NERDTreeShowBookmarks=1
        " 设置忽略文件类型
        let NERDTreeIgnore=['\~$', '\.pyc$', '\.swp$']
        " 窗口大小
        let NERDTreeWinSize=25
    " }

    " jedi-vim {

    let g:jedi#use_splits_not_buffers = "right"
    " }
" }

