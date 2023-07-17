let winCol = &columns / 8
let winWidth = &columns - (&columns / 4)
let winRow = &lines / 8
let winHeight = &lines - (&lines / 4)

call ddu#custom#patch_global({
\   'ui': 'ff',
\   'sources': [
\     {
\       'name': 'file_rec',
\       'params': {
\         'ignoredDirectories': ['.git', 'node_modules', 'vendor', '.next']
\       }
\     }
\   ],
\   'sourceOptions': {
\     '_': {
\       'matchers': ['matcher_substring'],
\     },
\   },
\   'filterParams': {
\     'matcher_substring': {
\       'highlightMatched': 'Title',
\     },
\   },
\   'kindOptions': {
\     'file': {
\       'defaultAction': 'open',
\     },
\   },
\   'uiParams': {
\     'ff': {
\       'startFilter': v:true,
\       'prompt': '> ',
\       'split': 'floating',
\       'floatingBorder': 'rounded',
\       'filterFloatingPosition': 'top',
\       'previewFloating': v:true,
\       'previewFloatingBorder': 'rounded',
\       'winCol': winCol,
\       'winWidth': winWidth,
\       'winRow': winRow,
\       'winHeight': winHeight,
\       'previewCol':  winCol + (winWidth / 2) - winWidth,
\       'previewWidth': winWidth / 2,
\       'previewRow': winRow,
\       'previewHeight': winHeight,
\       'previewFloatingZindex': 100,
\       'previewVertical': v:true,
\     }
\   },
\ })

call ddu#custom#patch_local('grep', {
\   'sourceParams' : {
\     'rg' : {
\       'args': ['--column', '--no-heading', '--color', 'never'],
\     },
\   },
\   'uiParams': {
\     'ff': {
\       'startFilter': v:false,
\     }
\   },
\ })

autocmd FileType ddu-ff call s:ddu_my_settings()
function! s:ddu_my_settings() abort
  nnoremap <buffer><silent> <CR>
    \ <Cmd>call ddu#ui#ff#do_action('itemAction', {'name': 'open', 'params': {'command': 'vsplit'}})<CR>

  nnoremap <buffer><silent> <Space>
    \ <Cmd>call ddu#ui#ff#do_action('itemAction', {'name': 'open', 'params': {'command': 'split'}})<CR>

  nnoremap <buffer><silent> a
    \ <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>

  nnoremap <buffer><silent> p
    \ <Cmd>call ddu#ui#ff#do_action('preview')<CR>

  nnoremap <buffer><silent> <Esc>
    \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

autocmd FileType ddu-ff-filter call s:ddu_filter_my_settings()
function! s:ddu_filter_my_settings() abort
  inoremap <buffer><silent> <CR>
    \ <Esc><Cmd>close<CR>

  inoremap <buffer><silent> <Esc>
    \ <Esc><Cmd>close<CR>

  nnoremap <buffer><silent> <CR>
    \ <Cmd>close<CR>

  nnoremap <buffer><silent> <Esc>
    \ <Cmd>close<CR>
endfunction

nmap <silent> -d <Cmd>call ddu#start({})<CR>
nmap <silent> ;g <Cmd>call ddu#start({
\   'name': 'grep',
\   'sources':[
\     {'name': 'rg', 'params': {'input': expand('<cword>')}}
\   ],
\ })<CR>
