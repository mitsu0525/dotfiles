" " ノーマルモードで起動、jjでノーマルへ
" call denite#custom#map('insert', 'jj', '<denite:enter_mode:normal>')
"
" " 移動
" call denite#custom#map('normal', '<C-n>', '<denite:move_to_next_line>', 'noremap')
" call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
" call denite#custom#map('normal', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
" call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
"
" call denite#custom#map('insert', '<C-a>', '<Home>')
" call denite#custom#map('insert', '<C-e>', '<End>')
" call denite#custom#map('insert', '<C-f>', '<Right>')
" call denite#custom#map('insert', '<C-b>', '<Left>')
"
" " ウィンドウを閉じる
" call denite#custom#map('normal', '<C-q>', '<denite:quit>', 'noremap')
" call denite#custom#map('insert', '<C-q>', '<denite:quit>', 'noremap')
"
" " ウィンドウを分割して開く
" call denite#custom#map('normal', '<C-v>', '<denite:do_action:vsplit>', 'noremap')
" call denite#custom#map('insert', '<C-v>', '<denite:do_action:vsplit>', 'noremap')
"
" " 新しいタブで開く
" call denite#custom#map('normal', '<C-t>', '<denite:do_action:tabopen>', 'noremap')
" call denite#custom#map('insert', '<C-t>', '<denite:do_action:tabopen>', 'noremap')

" grep
if executable('rg')
  call denite#custom#var('file/rec', 'command',
        \ ['rg', '--files', '--glob', '!.git'])
  call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'default_opts',
        \ ['-i', '--vimgrep', '--no-heading', '--hidden'])
else
  call denite#custom#var('file/rec', 'command',
        \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
endif

call denite#custom#map('insert', '<BS>',
      \ '<denite:smart_delete_char_before_caret>', 'noremap')
call denite#custom#map('insert', '<C-h>',
      \ '<denite:smart_delete_char_before_caret>', 'noremap')

" option
call denite#custom#option('_', 'prompt', '>' )
call denite#custom#source('default', 'matchers', ['matcher/fruzzy'])

" Add custom menus
let s:menus = {}
let s:menus.vim = {
    \ 'description': 'Vim',
    \ }
let s:menus.vim.file_candidates = [
    \ ['    > Edit configuation file (.vimrc)', '~/.vimrc']
    \ ]
call denite#custom#var('menu', 'menus', s:menus)

" customize ignore globs
call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
      \ [ '.git/', '.ropeproject/', '__pycache__/',
      \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])
