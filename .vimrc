" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
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

  " TOML 読み込み
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" インストールされていないプラグインがあればインストールする
" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
"End dein Scripts-------------------------

" 文字コード
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8 " 保存時の文字コード
set fileencodings=ucs-boms,utf-8,euc-jp,cp932 " 読み込み時の文字コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac " 改行コードの自動判別. 左側が優先される
set ambiwidth=double " □や○文字が崩れる問題を解決

""" 表示関係
set t_Co=256
set background=dark
set number              " 行番号の表示
set cursorline          " カーソルラインをハイライト
set ruler               " カーソル位置が右下に表示される
set showcmd             " コマンドを画面の最下部に表示する
set showbreak=↪ " showbreaks

" ヘルプ関係
set helplang& helplang=ja " Language help
autocmd FileType help nnoremap <buffer> q <C-w>c " qでhelpを閉じる
" ヘルプを新しいタブで開く
cabbrev help tab help
cabbrev h tab help

" タブ・インデント
set expandtab " タブ入力を複数の空白入力に置き換える
set tabstop=4 " 画面上でタブ文字が占める幅
set softtabstop=4 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent " 改行時に前の行のインデントを継続する
set smartindent " 改行時に前の行の構文をチェックし次の行のインデントを増減する
set shiftwidth=4 " smartindentで増減する幅

" 文字列検索
set incsearch " インクリメンタルサーチ. １文字入力毎に検索を行う
set ignorecase " 検索パターンに大文字小文字を区別しない
set smartcase " 検索パターンに大文字を含んでいたら大文字小文字を区別する
set hlsearch " 検索結果をハイライト
set wrapscan
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR> " ESCキー2度押しでハイライトの切り替え

" Swapファイル, Backupファイルを全て無効化する
set nowritebackup
set nobackup
set noswapfile

" カーソル
set backspace=indent,eol,start " Backspaceキーの影響範囲に制限を設けない
set whichwrap=b,s,h,l,<,>,[,]  " 行頭行末の左右移動で行をまたぐ

" カッコ・タグジャンプ
set showmatch " 括弧の対応関係を一瞬表示する
source $VIMRUNTIME/macros/matchit.vim " Vimの「%」を拡張する

" コマンド補完
set wildmenu " コマンドライン補完が強力になる
set history=10000

" ESC to jj
inoremap <silent> jj <ESC>:<C-u>w<CR>
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>

nnoremap gs  :<C-u>%s///g<Left><Left><Left>
vnoremap gs  :s///g<Left><Left><Left>

nnoremap <Space><Space> :
nnoremap <Space>w  :<C-u>w<CR>
nnoremap <Space>q  :<C-u>q<CR>
nnoremap <Space>Q  :<C-u>q!<CR>

nnoremap <Space>h  ^
nnoremap <Space>l  $
nnoremap <Space>/  *
nnoremap g<Space>/ g*<C-o>
noremap <Space>m  %
vnoremap <Space>h  ^
vnoremap <Space>l  $
vnoremap <Space>/  *
vnoremap g<Space>/ g*<C-o>
vnoremap <Space>m  %

" 空行挿入
nnoremap <CR> o<ESC>

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap <C-j> gj
nnoremap <C-k> gk

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
" クリップボードをデフォルトのレジスタとして指定。後にYankRingを使うので
" 'unnamedplus'が存在しているかどうかで設定を分ける必要がある
if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus,unnamed
else
    set clipboard& clipboard+=unnamed
endif

if has('vim_starting')
	if exists('$TMUX')
        " 挿入モード時に非点滅の縦棒タイプのカーソル
        let &t_SI .= "\ePtmux;\e\e[6 q\e\\"
        " ノーマルモード時に非点滅のブロックタイプのカーソル
        let &t_EI .= "\ePtmux;\e\e[2 q\e\\"
        " 置換モード時に非点滅の下線タイプのカーソル
        let &t_SR .= "\ePtmux;\e\e[4 q\e\\"
	else
	    " 挿入モード時に非点滅の縦棒タイプのカーソル
	    let &t_SI .= "\e[6 q"
	    " ノーマルモード時に非点滅のブロックタイプのカーソル
	    let &t_EI .= "\e[2 q"
	    " 置換モード時に非点滅の下線タイプのカーソル
	    let &t_SR .= "\e[4 q"
	endif
endif

" Disable bell.
set t_vb=
set novisualbell
set belloff=all

nmap gc <Plug>NERDCommenterToggle
nmap ga <Plug>NERDCommenterAppend
nmap gb <Plug>NERDCommenterSexy
vmap gc <Plug>NERDCommenterToggle
vmap ga <Plug>NERDCommenterAppend
vmap gb <Plug>NERDCommenterSexy
