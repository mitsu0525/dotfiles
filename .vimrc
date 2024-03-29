" reset augroup
augroup MyAutoCmd
    autocmd!
augroup END

" dein Scripts-----------------------------
if &compatible
    set nocompatible " Be iMproved
endif

let s:dein_path = expand('~/.vim/dein')
let s:dein_repo_path = s:dein_path . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github からclone
if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_path)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_path
    endif
    execute 'set runtimepath^=' . fnamemodify(s:dein_repo_path, ':p')
endif

if dein#load_state(s:dein_path)
    call dein#begin(s:dein_path)

    let g:config_dir  = expand('~/.vim/rc')
    let s:toml        = g:config_dir . '/dein.toml'
    let s:lazy_toml   = g:config_dir . '/dein_lazy.toml'

    " Load TOML
    call dein#load_toml(s:toml,      {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})

    call dein#end()
    call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
    call dein#install()
endif
" End dein Scripts-------------------------
let g:python3_host_prog = '/usr/bin/python3'

" 文字コード
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8 " 保存時の文字コード
" Default fileformat.
set fileformat=unix
" Automatic recognition of a new line cord.
set fileformats=unix,dos,mac
set ambiwidth=double " □や○文字が崩れる問題を解決

" 表示関係
set t_Co=256
set background=dark
set cursorline  " カーソルラインをハイライト
set ruler       " カーソル位置が右下に表示される
set showcmd     " コマンドを画面の最下部に表示する
set list        " 不可視文字を表示
set listchars=tab:▸\ ,trail:-,precedes:«,nbsp:%
set showbreak=↪ " showbreaks

" Display another buffer when current buffer isn't saved.
set hidden

" ヘルプ関係
set keywordprg=:help " Open Vim internal help by K command
set helplang& helplang=ja,en " Language help

" タブ・インデント
set expandtab     " タブ入力を複数の空白入力に置き換える
set tabstop=4     " 画面上でタブ文字が占める幅
set softtabstop=4 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent    " 改行時に前の行のインデントを継続する
set smartindent   " 改行時に前の行の構文をチェックし次の行のインデントを増減する
set shiftwidth=4  " smartindentで増減する幅
set shiftround    " shiftwidthの倍数に丸める

"  コメントアウト補完無効
autocmd MyAutoCmd BufEnter * setlocal formatoptions-=r
autocmd MyAutoCmd BufEnter * setlocal formatoptions-=o

" 文字列検索
set incsearch  " インクリメンタルサーチ. １文字入力毎に検索を行う
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase  " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch   " 検索結果をハイライト
set wrapscan
" ESCキー2度押しでハイライトの切り替え
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>

" Swapファイル, Backupファイルを全て無効化する
set nowritebackup
set nobackup
set noswapfile

" Disable bell.
set t_vb=
set novisualbell
set belloff=all

" Cursor
set backspace=indent,eol,start " Backspaceキーの影響範囲に制限を設けない
set whichwrap=b,s,h,l,<,>,[,]  " 行頭行末の左右移動で行をまたぐ
set nostartofline " Moves the cursor to the same column when cursor move

" カッコ・タグジャンプ
set showmatch " 括弧の対応関係を一瞬表示する
set matchpairs& matchpairs+=<:> " Increase the corresponding pairs

" コマンド補完
if has('nvim')
  " Display candidates by popup menu.
  set wildmenu
  set wildmode=full
  set wildoptions+=pum
else
  " Display candidates by list.
  set nowildmenu
  set wildmode=list:longest,full
endif
" Increase history amount.
set history=1000
" Display all the information of the tag by the supplement of the Insert mode.
set showfulltag
" Can supplement a tag in a command-line.
set wildoptions+=tagfile

" Define mapleader
let g:mapleader = ','
let g:maplocalleader = ','

" ESC to jj
inoremap <silent> jj <ESC>
inoremap j<Space> j

" Smart space mapping
" Notice: when starting other <Space> mappings in noremap, disappeared [Space]
nnoremap [Space] <Nop>
xnoremap [Space] <Nop>
nmap <Space> [Space]
xmap <Space> [Space]
noremap [Space]<Space> :
noremap [Space]w  :<C-u>w<CR>
noremap [Space]q  :<C-u>qa<CR>
noremap [Space]Q  :<C-u>q!<CR>
" 行選択していない状態から実行
nnoremap [Space]<CR> V:!sh<CR>
" 行選択中に実行
xnoremap [Space]<CR> :!sh<CR>

" カーソル移動
noremap [Space]h ^
noremap [Space]j L
noremap [Space]k H
noremap [Space]l $
" Smart <C-f>, <C-b>.
noremap <expr> <C-j> max([winheight(0) - 2, 1]) . "\<C-d>" . (line('w$') >= line('$') ? "L" : "M")
noremap <expr> <C-k> max([winheight(0) - 2, 1]) . "\<C-u>" . (line('w0') <= 1 ? "H" : "M")

" Insert mode keymappings:
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-h> <BS>
inoremap <C-d> <Del>

" Command-line mode keymappings:
cnoremap <C-p> <Up>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-h> <BS>
cnoremap <C-d> <Del>
cnoremap <C-q> <C-c>

" 検索・置換・インデント
nnoremap sg :<C-u>%s//g<Left><Left>
xnoremap sg :s//g<Left><Left>
nnoremap > >>
nnoremap < <<
xnoremap > >gv
xnoremap < <gv
" Make Y behave like other capitals
nnoremap Y y$

" 補完
if dein#check_install('lexima.vim')
    inoremap [ []<LEFT>
    inoremap ( ()<LEFT>
    inoremap " ""<LEFT>
    inoremap ' ''<LEFT>
    inoremap ` ``<LEFT>
endif

" 空行挿入
nnoremap <silent> <CR> :<C-u>call append(line('.'),'')<CR><Down>

" バッファ移動
nnoremap <silent> <C-l> :<C-u>bnext<CR>
nnoremap <silent> <C-h> :<C-u>bprev<CR>
nnoremap <silent> <C-q> :<C-u>bdelete<CR>

" ウィンドウ操作
nnoremap <silent> sp    :<C-u>vsplit<CR>:wincmd w<CR>
nnoremap <silent> so    :<C-u>only<CR>
nnoremap <silent> <Tab> :wincmd w<CR>
nnoremap <silent><expr> q winnr('$') != 1 ? ':<C-u>close<CR>' : ""

" Diable
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q  q

" マウス
if has('mouse')
    set mouse=a
    if has('mouse_sgr')
        set ttymouse=sgr
    elseif v:version > 703 || v:version is 703 && has('patch632')
        set ttymouse=sgr
    else
        set ttymouse=xterm2
    endif
endif

" ペースト
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

" " Use clipboard register.
if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus
else
    set clipboard& clipboard+=unnamed
endif

if has('vim_starting')
    if exists('$TMUX')
        " 挿入モード時に非点滅の縦棒カーソル
        let &t_SI .= "\ePtmux;\e\e[6 q\e\\"
        " ノーマルモード時に非点滅のブロックカーソル
        let &t_EI .= "\ePtmux;\e\e[2 q\e\\"
        " 置換モード時に非点滅の下線カーソル
        let &t_SR .= "\ePtmux;\e\e[4 q\e\\"
    else
        " 挿入モード時に非点滅の縦棒カーソル
        let &t_SI .= "\e[6 q"
        " ノーマルモード時に非点滅のブロックカーソル
        let &t_EI .= "\e[2 q"
        " 置換モード時に非点滅の下線カーソル
        let &t_SR .= "\e[4 q"
    endif
endif

" v_p doesn't replace register
function! RestoreRegister()
    let @" = s:restore_reg
    return ''
endfunction
function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<CR>"
endfunction
xmap <silent> <expr> p <SID>Repl()

" For conceal.
set conceallevel=2 concealcursor=niv

" Disable default plugins------------------
let g:loaded_2html_plugin      = 1
let g:loaded_logiPat           = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_gzip              = 1
let g:loaded_man               = 1
let g:loaded_matchit           = 1
let g:loaded_matchparen        = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_rrhelper          = 1
let g:loaded_shada_plugin      = 1
let g:loaded_spellfile_plugin  = 1
let g:loaded_tarPlugin         = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_zipPlugin         = 1
