" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

" dein.vim 関連 {{{
" インストールディレクトリの指定 {{{
let s:dein_dir = expand($XDG_DATA_HOME . '/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
" }}}

" deinがインストールされているか確認 {{{
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . s:dein_repo_dir
endif
" }}}

" deinの読み込み開始 {{{
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " .tomlファイルの場所
  let s:rc_dir = expand($XDG_CONFIG_HOME . '/nvim/rc/')
  if !isdirectory(s:rc_dir)
    call mkdir(s:rc_dir, 'p')
  endif
  let s:toml = s:rc_dir . '/dein.toml'
  let s:lazy_toml = s:rc_dir . '/dein_lazy.toml'

  " .tomlファイルを読み込む
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

 " 終了
  call dein#end()
  call dein#save_state()
endif
" }}}

" プラグインが不足していればインストールする {{{
if dein#check_install()
  call dein#install()
endif
" }}}

" .tomlファイルに記述されていないプラグインを削除する {{{
let s:removed_plugins = dein#check_clean()
  if len(s:removed_plugins) > 0
  call map(s:removed_plugins, "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endif
" }}}

let g:python3_host_prog = '/usr/bin/python3'

lua require('plugins')
set cmdheight=0

" Auto change directory
set autochdir

" 文字コード
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8 " 保存時の文字コード
" Default fileformat.
set fileformat=unix
" Automatic recognition of a new line cord.
set fileformats=unix,dos,mac

" 表示関係
set t_Co=256
set background=dark
set cursorline  " カーソルラインをハイライト
set ruler       " カーソル位置が右下に表示される
set showcmd     " コマンドを画面の最下部に表示する
set list        " 不可視文字を表示
set listchars=tab:▸-,trail:-,precedes:«,nbsp:%
set showbreak=↪ " showbreaks
set laststatus=3

" Display another buffer when current buffer isn't saved.
set hidden

" ヘルプ関係
set keywordprg=:help " Open Vim internal help by K command
set helplang& helplang=ja,en " Language help

" タブ・インデント
set expandtab     " タブ入力を複数の空白入力に置き換える
set tabstop=2     " 画面上でタブ文字が占める幅
set softtabstop=2 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent    " 改行時に前の行のインデントを継続する
set smartindent   " 改行時に前の行の構文をチェックし次の行のインデントを増減する
set shiftwidth=2  " smartindentで増減する幅

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
set wildmenu
set wildmode=longest,full
set history=10000

" Define mapleader
let g:mapleader = ','
let g:maplocalleader = ','

" ESC to jj
inoremap <silent> jj <ESC>
inoremap j<Space> j
" IM settings
set iminsert=0 imsearch=0 " IM off when starting up
set noimcmdline " Disable IM on cmdline

" Smart space mapping
" Notice: when starting other <Space> mappings in noremap, disappeared [Space]
nmap <Space> [Space]
xmap <Space> [Space]
nnoremap [Space] <Nop>
xnoremap [Space] <Nop>
noremap [Space]<Space> :
noremap [Space]w  :<C-u>w<CR>
noremap [Space]q  :<C-u>qa<CR>
noremap [Space]Q  :<C-u>q!<CR>
" 行選択していない状態から実行
nnoremap [Space]<CR> V:!sh<CR>
" 行選択中に実行
xnoremap [Space]<CR> :!sh<CR>
" atcoder-tools
nnoremap [Space]t :<C-u>!atcoder-tools test<CR>
nnoremap [Space]s :<C-u>!atcoder-tools submit -u

" カーソル移動
noremap [Space]h ^
noremap [Space]l $
noremap H ^
noremap L $
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-h> <C-o>u
inoremap <C-d> <Del>
" Smart <C-f>, <C-b>.
noremap <silent> <expr> <C-j> max([winheight(0) - 2, 1]) . "\<C-d>" . (line('w$') >= line('$') ? "L" : "M")
noremap <silent> <expr> <C-k> max([winheight(0) - 2, 1]) . "\<C-u>" . (line('w0') <= 1 ? "H" : "M")

" Command-line mode keymappings:
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
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
" if dein#check_install('auto-pairs')
"     inoremap [ []<LEFT>
"     inoremap ( ()<LEFT>
"     inoremap " ""<LEFT>
"     inoremap ' ''<LEFT>
"     inoremap ` ``<LEFT>
" endif

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

" Better x
nnoremap x "_x

" Diable
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q  q

" マウス
if has('mouse')
  set mouse=
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
" if has('unnamedplus')
"     set clipboard& clipboard+=unnamedplus
" else
"     set clipboard& clipboard+=unnamed
" endif

if system('uname -a | grep microsoft') != ""
    let g:clipboard = {
   \   'name': 'wslClipboard',
   \   'copy': {
   \       '+': 'win32yank.exe -i',
   \       '*': 'win32yank.exe -i',
   \   },
   \   'paste': {
   \       '+': 'win32yank.exe -o',
   \       '*': 'win32yank.exe -o',
   \   },
   \   'cache_enabled': 1,
   \}
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

set termguicolors
" set winblend=0
" set wildoptions=pum
" set pumblend=5

" Disable default plugins------------------
let g:did_install_default_menus = 1
let g:did_install_syntax_menu   = 1
let g:did_indent_on             = 1
let g:did_load_filetypes        = 1
" let g:did_load_ftplugin         = 1
let g:loaded_2html_plugin       = 1
let g:loaded_gzip               = 1
let g:loaded_man                = 1
let g:loaded_matchit            = 1
let g:loaded_matchparen         = 1
let g:loaded_netrwPlugin        = 1
let g:loaded_remote_plugins     = 1
let g:loaded_shada_plugin       = 1
let g:loaded_spellfile_plugin   = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tutor_mode_plugin  = 1
let g:loaded_zipPlugin          = 1
let g:skip_loading_mswin        = 1
let g:do_legacy_filetype        = 1
