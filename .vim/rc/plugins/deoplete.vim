" <TAB>: completion.
inoremap <silent><expr> <TAB>
   \ pumvisible() ? "\<C-n>" :
   \ <SID>check_back_space() ? "\<TAB>" :
   \ deoplete#manual_complete()
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
endfunction

" <S-TAB>: completion back.
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"

inoremap <expr><C-g> deoplete#refresh()
inoremap <expr><C-e> deoplete#cancel_popup()
inoremap <silent><expr><C-l> deoplete#complete_common_string()

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
    return pumvisible() ? deoplete#close_popup()."\<CR>" : "\<CR>"
endfunction

call deoplete#custom#source('_', 'matchers', ['matcher_fuzzy', 'matcher_length'])
call deoplete#custom#source('denite', 'matchers', ['matcher_full_fuzzy', 'matcher_length'])

call deoplete#custom#source('look', 'filetypes', ['help', 'gitcommit'])
call deoplete#custom#option('ignore_sources', {'_': ['around', 'buffer']})

call deoplete#custom#source('tabnine', 'rank', 300)
call deoplete#custom#source('tabnine', 'min_pattern_length', 1)
call deoplete#custom#var('tabnine', {
      \ 'line_limit': 500,
      \ 'max_num_results': 20,
      \ })
" call deoplete#custom#source('tabnine', 'is_volatile', v:false)

call deoplete#custom#source('zsh', 'filetypes', ['zsh', 'sh'])

call deoplete#custom#source('_', 'converters', [
   \ 'converter_remove_paren',
   \ 'converter_remove_overlap',
   \ 'matcher_length',
   \ 'converter_truncate_abbr',
   \ 'converter_truncate_info',
   \ 'converter_truncate_menu',
   \ 'converter_auto_delimiter',
   \ ])
call deoplete#custom#source('tabnine', 'converters', [
   \ 'converter_remove_overlap',
   \ 'converter_truncate_info',
   \ ])

call deoplete#custom#option('keyword_patterns', {
   \ '_': '[a-zA-Z_]\k*\(?',
   \ 'tex': '[^\w|\s][a-zA-Z_]\w*',
   \ })
call deoplete#custom#option({
     \ 'auto_refresh_delay': 10,
     \ 'camel_case': v:true,
     \ 'skip_multibyte': v:true,
     \ 'prev_completion_mode': 'length',
     \ 'auto_preview': v:true,
     \ })
