scriptencoding utf-8

let s:mo_glyph = '+'
let s:ro_glyph = 'RO'
let s:help_glyph = '?'
let s:ale_linting_glyph = '...'

function! lightline#delphinus#components#readonly() abort
    return &buftype ==# 'terminal' ? '' :
        \ &filetype ==# 'help' ? s:help_glyph :
        \ &filetype !~# 'vimfiler\|gundo\|tagbar' && &readonly ? s:ro_glyph :
        \ ''
endfunction

function! lightline#delphinus#components#filepath() abort
    if &buftype ==# 'terminal' || &filetype ==# 'tagbar'
        return ''
    endif
    if &filetype ==# 'denite'
        let ctx = get(b:, 'denite_context', {})
        return get(ctx, 'sorters', '')
    endif
    let ro_string = '' !=# lightline#delphinus#components#readonly() ? lightline#delphinus#components#readonly() . ' ' : ''
    if &filetype ==# 'vimfilter' || &filetype ==# 'unite' || winwidth(0) < 70
        let path_string = ''
    else
        if exists('+shellslash')
            let saved_shellslash = &shellslash
            set shellslash
        endif
        let path_string = substitute(expand('%:h'), fnamemodify(expand($HOME),''), '~', '')
        if winwidth(0) < 120 && len(path_string) > 30
            let path_string = substitute(path_string, '\v([^/])[^/]*%(/)@=', '\1', 'g')
        endif
        if exists('+shellslash')
            let &shellslash = saved_shellslash
        endif
    endif

    return ro_string . path_string
endfunction

function! lightline#delphinus#components#filename() abort
    return (&buftype ==# 'terminal' ? has('nvim') ? b:term_title . ' (' . b:terminal_job_pid . ')' : '' :
                \ &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
                \ &filetype ==# 'unite' ? unite#get_status_string() :
                \ &filetype ==# 'denite' ? denite#get_status_sources() :
                \ &filetype ==# 'tagbar' ? get(g:lightline, 'fname', '') :
                \ '' !=# expand('%:t') ? expand('%:t') : '[No Name]') .
                \ ('' !=# lightline#delphinus#components#modified() ? ' ' . lightline#delphinus#components#modified() : '')
endfunction

function! lightline#delphinus#components#fugitive() abort
    if &buftype ==# 'terminal' || winwidth(0) < 100
        return ''
    endif
    try
        if &filetype !~? 'vimfiler\|gundo\|denite\|tagbar' && exists('*fugitive#head')
            return fugitive#head()
        endif
    catch
    endtry
    return ''
endfunction

function! lightline#delphinus#components#fileformat() abort
    return &buftype ==# 'terminal' || &filetype =~# 'denite\|tagbar' ? '' :
                \ winwidth(0) > 120 ? &fileformat . (exists('*WebDevIconsGetFileFormatSymbol') ? ' ' . WebDevIconsGetFileFormatSymbol() : '') : ''
endfunction

function! lightline#delphinus#components#filetype() abort
    return &buftype ==# 'terminal' || &filetype =~# 'denite\|tagbar' ? '' :
                \ winwidth(0) > 120 ? (strlen(&filetype) ? &filetype . (exists('*WebDevIconsGetFileTypeSymbol') ? ' ' . WebDevIconsGetFileTypeSymbol() : '') : 'no ft') : ''
endfunction

function! lightline#delphinus#components#fileencoding() abort
    return &buftype ==# 'terminal' || &filetype =~# 'denite\|tagbar' ? '' :
                \ winwidth(0) > 120 ? (strlen(&fileencoding) ? &fileencoding : &encoding) : ''
endfunction

function! lightline#delphinus#components#mode() abort
    if &filetype ==# 'denite'
        let mode = denite#get_status('raw_mode')
        call lightline#link(tolower(mode[0]))
        return 'Denite'
    endif
    let fname = expand('%:t')
    return fname =~# 'unite' ? 'Unite' :
                \ fname =~# 'vimfiler' ? 'VimFilter' :
                \ fname =~# '__Gundo__' ? 'Gundo' :
                \ &filetype ==# 'tagbar' ? 'Tagbar' :
                \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! lightline#delphinus#components#charcode() abort
    if &buftype ==# 'terminal' || &filetype =~# 'denite\|tagbar'
        return ''
    endif
    if winwidth(0) <= 120
        return ''
    endif
    let tmp = ''
    " if char on cursor is `Λ̊`, :ascii returns below.
    " <Λ> 923, 16進数 039b, 8進数 1633 < ̊> 778, 16進数 030a, 8進数 1412
    redir => tmp | silent! ascii | redir END
    let chars = []
    call substitute(tmp, '<.>\s\+\d\+,\s\+\S\+ \x\+,\s\+\S\+ \d\+', '\=add(chars, submatch(0))', 'g')
    if len(chars) == 0
        return ''
    endif
    let ascii = []
    for c in chars
        let m = matchlist(c, '<\(.\)>\s\+\d\+,\s\+\S\+ \(\x\+\)')
        if len(m) > 0
            call add(ascii, printf('%s %s', m[1], m[2]))
        endif
    endfor
    return join(ascii, ', ')
endfunction

let s:ale_linting = 0
function! lightline#delphinus#components#ale_pre() abort
    let s:ale_linting = 1
    call lightline#update()
endfunction

function! lightline#delphinus#components#ale_post() abort
    let s:ale_linting = 0
    call lightline#update()
endfunction

function! s:ale_string(mode)
    if !exists('g:ale_buffer_info') || &buftype ==# 'terminal' || &filetype =~# 'denite\|tagbar'
        return ''
    endif
    if s:ale_linting
        " it shows an icon in linting with the `warning` color.
        return a:mode == 1 ? s:ale_linting_glyph : ''
    endif

    let buffer = bufnr('%')
    let counts = ale#statusline#Count(buffer)
    let [error_format, warning_format, no_errors] = g:ale_statusline_format

    if a:mode == 0 " Error
        let errors = counts.error + counts.style_error
        return errors ? printf(error_format, errors) : ''
    elseif a:mode == 1 " Warning
        let warnings = counts.warning + counts.style_warning
        return warnings ? printf(warning_format, warnings) : ''
    endif

    return counts.total ? '' : no_errors
endfunction

function! lightline#delphinus#components#lineinfo() abort
    return &filetype ==# 'denite' ? denite#get_status_linenr() :
                \ &filetype ==# 'tagbar' ? '' :
                \ printf('%3d:%-2d', line('.'), col('.'))
endfunction

function! lightline#delphinus#components#percent() abort
    if &filetype ==# 'tagbar'
        return ''
    endif
    let line = &filetype ==# 'denite' ? denite#get_status('line_cursor') : line('.')
    let total = &filetype ==# 'denite' ? denite#get_status('line_total') : line('$')
    return total ? printf('%d%%', 100 * line / total) : '0%'
endfunction

let s:save_cpo = &cpoptions
set cpoptions&vim

let g:lightline = {
    \ 'colorscheme': 'solarized_improved'
    \ 'active': {
        \ 'left': [
        \   [ 'mode', 'paste' ],
        \   [ 'fugitive' ],
        \   [ 'filepath' ],
        \   [ 'filename', 'ale_error', 'ale_warning', 'ale_ok' ]
        \ ],
        \ 'right': [
        \   [ 'lineinfo' ],
        \   [ 'percent' ],
        \   [ 'char_code', 'fileformat', 'fileencoding', 'filetype' ]
        \ ],
    \ },
    \ 'inactive': {
        \ 'left':  [ [ 'filepath' ], [ 'filename' ] ],
        \ 'right': [ [ 'lineinfo' ], [ 'percent' ] ],
    \ },
    \ 'component_function': {
        \ 'modified':     'lightline#delphinus#components#modified',
        \ 'readonly':     'lightline#delphinus#components#readonly',
        \ 'fugitive':     'lightline#delphinus#components#fugitive',
        \ 'filepath':     'lightline#delphinus#components#filepath',
        \ 'filename':     'lightline#delphinus#components#filename',
        \ 'fileformat':   'lightline#delphinus#components#fileformat',
        \ 'filetype':     'lightline#delphinus#components#filetype',
        \ 'fileencoding': 'lightline#delphinus#components#fileencoding',
        \ 'mode':         'lightline#delphinus#components#mode',
        \ 'char_code':    'lightline#delphinus#components#charcode',
        \ 'lineinfo':     'lightline#delphinus#components#lineinfo',
        \ 'percent':      'lightline#delphinus#components#percent',
    \ },
    \ 'component_function_visible_condition': {
        \ 'mode':         1,
        \ 'currenttag':   0,
        \ 'char_code':    0,
        \ 'fileformat':   0,
        \ 'filetype':     0,
        \ 'fileencoding': 0,
    \ },
    \ 'component_expand': {
        \ 'ale_error':   's:ale_string(0)',
        \ 'ale_warning': 's:ale_string(1)',
        \ 'ale_ok':      's:ale_string(2)',
    \ },
    \ 'component_type': {
        \ 'ale_error':   'error',
        \ 'ale_warning': 'warning',
        \ 'ale_ok':      'ok',
    \ },
    \ 'separator':    {'left': '', 'right': ''},
    \ 'subseparator': {'left': '|', 'right': '|'},
\ }
