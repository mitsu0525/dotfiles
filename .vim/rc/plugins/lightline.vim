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

function! lightline#delphinus#components#ale_error() abort
    return
endfunction

function! lightline#delphinus#components#ale_warning() abort
    return s:ale_string(1)
endfunction

function! lightline#delphinus#components#ale_ok() abort
    return s:ale_string(2)
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
let s:cuicolors = {
    \ 'base03':  [ '8',  '234', 'DarkGray'     ],
    \ 'base02':  [ '0',  '235', 'Black'        ],
    \ 'base01':  [ '10', '239', 'LightGreen'   ],
    \ 'base00':  [ '11', '240', 'LightYellow'  ],
    \ 'base0':   [ '12', '244', 'LightBlue'    ],
    \ 'base1':   [ '14', '245', 'LightCyan'    ],
    \ 'base2':   [ '7',  '187', 'LightGray'    ],
    \ 'base3':   [ '15', '230', 'White'        ],
    \ 'yellow':  [ '3',  '136', 'DarkYellow'   ],
    \ 'orange':  [ '9',  '166', 'LightRed'     ],
    \ 'red':     [ '1',  '124', 'DarkRed'      ],
    \ 'magenta': [ '5',  '125', 'DarkMagenta'  ],
    \ 'violet':  [ '13', '61',  'LightMagenta' ],
    \ 'blue':    [ '4',  '33',  'DarkBlue'     ],
    \ 'cyan':    [ '6',  '37',  'DarkCyan'     ],
    \ 'green':   [ '2',  '64',  'DarkGreen'    ]
\ }

" The following condition only applies for the console and is the same
" condition vim-colors-solarized uses to determine which set of colors
" to use.
let s:solarized_termcolors = get(g:, 'solarized_termcolors', 256)
if s:solarized_termcolors != 256 && &t_Co >= 16
    let s:cuiindex = 0
elseif s:solarized_termcolors == 256
    let s:cuiindex = 1
else
    let s:cuiindex = 2
endif

let s:base03  = [ '#002b36', s:cuicolors.base03[s:cuiindex]  ]
let s:base02  = [ '#073642', s:cuicolors.base02[s:cuiindex]  ]
let s:base01  = [ '#586e75', s:cuicolors.base01[s:cuiindex]  ]
let s:base00  = [ '#657b83', s:cuicolors.base00[s:cuiindex]  ]
let s:base0   = [ '#839496', s:cuicolors.base0[s:cuiindex]   ]
let s:base1   = [ '#93a1a1', s:cuicolors.base1[s:cuiindex]   ]
let s:base2   = [ '#eee8d5', s:cuicolors.base2[s:cuiindex]   ]
let s:base3   = [ '#fdf6e3', s:cuicolors.base3[s:cuiindex]   ]
let s:yellow  = [ '#b58900', s:cuicolors.yellow[s:cuiindex]  ]
let s:orange  = [ '#cb4b16', s:cuicolors.orange[s:cuiindex]  ]
let s:red     = [ '#dc322f', s:cuicolors.red[s:cuiindex]     ]
let s:magenta = [ '#d33682', s:cuicolors.magenta[s:cuiindex] ]
let s:violet  = [ '#6c71c4', s:cuicolors.violet[s:cuiindex]  ]
let s:blue    = [ '#268bd2', s:cuicolors.blue[s:cuiindex]    ]
let s:cyan    = [ '#2aa198', s:cuicolors.cyan[s:cuiindex]    ]
let s:green   = [ '#859900', s:cuicolors.green[s:cuiindex]   ]

let s:bold = 'bold'

if &background ==# 'light'
    let [ s:base03, s:base3 ] = [ s:base3, s:base03 ]
    let [ s:base02, s:base2 ] = [ s:base2, s:base02 ]
    let [ s:base01, s:base1 ] = [ s:base1, s:base01 ]
    let [ s:base00, s:base0 ] = [ s:base0, s:base00 ]

    " http://paletton.com/#uid=13C0u0knVYVc7ZQi-ZntrXrH4Ty
    let s:insert = [
        \ [ s:base02, s:blue, s:bold     ],
        \ [ s:base3,  [ '#a4ccfc', 153 ] ],
        \ [ s:base3,  [ '#75b2fb', 111 ] ],
        \ [ s:base2,  [ '#4e9cf9', 75  ] ],
        \ [ s:base03, [ '#4e9cf9', 75  ] ],
        \ [ s:base2,  [ '#2684f5', 33  ] ],
        \ [ s:base2,  [ '#4e9cf9', 75  ] ]
    ]
    " http://paletton.com/#uid=1090u0kkh++7z+WeL+ZpN+WvYZG
    let s:replace = [
        \ [ s:base02, s:red, s:bold      ],
        \ [ s:base3,  [ '#ffcec3', 224 ] ],
        \ [ s:base3,  [ '#ffa089', 216 ] ],
        \ [ s:base2,  [ '#ff7c5d', 209 ] ],
        \ [ s:base03, [ '#ff7c5d', 209 ] ],
        \ [ s:base2,  [ '#ff5931', 203 ] ],
        \ [ s:base2,  [ '#ff7c5d', 209 ] ]
    ]
    " http://paletton.com/#uid=14Q0u0kcNYG00++6C+qhYVrmpPi
    let s:visual = [
        \ [ s:base02, s:magenta, s:bold ],
        \ [ s:base3,  [ '#ffffff', 231 ] ],
        \ [ s:base3,  [ '#f5cafd', 225 ] ],
        \ [ s:base2,  [ '#e898f9', 177 ] ],
        \ [ s:base03, [ '#e898f9', 177 ] ],
        \ [ s:base2,  [ '#d96df0', 171 ] ],
        \ [ s:base2,  [ '#e898f9', 177 ] ]
    ]
else
    " http://paletton.com/#uid=13C0u0kw0w0jyC+oRxVy4oIDfjr
    let s:insert = [
        \ [ s:blue,   s:base2, s:bold   ],
        \ [ s:base03, [ '#5383bd', 67 ] ],
        \ [ s:base03, [ '#3169ac', 61 ] ],
        \ [ s:base2,  [ '#0e53a7', 25 ] ],
        \ [ s:base03, [ '#0e53a7', 25 ] ],
        \ [ s:base2,  [ '#0a4081', 24 ] ],
        \ [ s:base2,  [ '#0e53a7', 25 ] ]
    ]
    " http://paletton.com/#uid=1090u0kw0w0jyC+oRxVy4oIDfjr
    let s:replace = [
        \ [ s:red,    s:base2, s:bold    ],
        \ [ s:base03, [ '#ff8e63', 209 ] ],
        \ [ s:base03, [ '#ff5f39', 203 ] ],
        \ [ s:base2,  [ '#ff3100', 202 ] ],
        \ [ s:base03, [ '#ff5f39', 203 ] ],
        \ [ s:base2,  [ '#c52600', 160 ] ],
        \ [ s:base2,  [ '#ff5f39', 203 ] ]
    ]
    " http://paletton.com/#uid=14Q0u0kw0w0jyC+oRxVy4oIDfjr
    let s:visual = [
        \ [ s:magenta, s:base2, s:bold    ],
        \ [ s:base03,  [ '#aa4dbe', 133 ] ],
        \ [ s:base03,  [ '#962aad', 92 ]  ],
        \ [ s:base2,   [ '#8c04a8', 91 ]  ],
        \ [ s:base03,  [ '#962aad', 92 ]  ],
        \ [ s:base2,   [ '#6c0382', 54 ]  ],
        \ [ s:base2,   [ '#962aad', 92 ]  ]
    ]
endif

let s:normal = [
    \ [ s:base03, s:green, s:bold ],
    \ [ s:base03, s:base1, s:bold ],
    \ [ s:base03, s:base0  ],
    \ [ s:base3,  s:base02 ],
    \ [ s:base2,  s:red    ],
    \ [ s:base2,  s:yellow ],
    \ [ s:green,  s:base02 ]
]

if &background ==# 'light'
    let s:normal[4][0] = s:base02
    let s:normal[5][0] = s:base02
endif

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left     = s:normal[0:3]
let s:p.inactive.left   = [ [ s:base0, s:base02 ], [ s:base0, s:base02 ] ]
let s:p.insert.left     = s:insert[0:3]
let s:p.replace.left    = s:replace[0:3]
let s:p.visual.left     = s:visual[0:3]

let s:p.normal.right    = [ [ s:base03, s:base1 ], [ s:base03, s:base00 ] ]
let s:p.inactive.right  = [ [ s:base03, s:base00 ], [ s:base0, s:base02 ] ]
let s:p.insert.right    = s:insert[1:2] + s:insert[4:4]
let s:p.replace.right   = s:replace[1:2] + s:replace[4:4]
let s:p.visual.right    = s:visual[1:2] + s:visual[4:4]

let s:p.normal.middle   = [ [ s:base1, s:base02 ] ]
let s:p.inactive.middle = [ [ s:base01, s:base02 ] ]
let s:p.insert.middle   = s:insert[5:5]
let s:p.replace.middle  = s:replace[5:5]
let s:p.visual.middle   = s:visual[5:5]

let s:p.tabline.left    = [ [ s:base03, s:base00 ] ]
let s:p.tabline.tabsel  = [ [ s:base03, s:base1 ] ]
let s:p.tabline.middle  = [ [ s:base0, s:base02 ] ]
let s:p.tabline.right   = copy(s:p.normal.right)

let s:p.normal.error    = s:normal[4:4]
let s:p.insert.error    = s:insert[6:6]
let s:p.replace.error   = s:replace[6:6]
let s:p.visual.error    = s:visual[6:6]
let s:p.normal.warning  = s:normal[5:5]
let s:p.insert.warning  = s:insert[6:6]
let s:p.replace.warning = s:replace[6:6]
let s:p.visual.warning  = s:visual[6:6]
let s:p.normal.ok       = s:normal[6:6]
let s:p.insert.ok       = s:insert[6:6]
let s:p.replace.ok      = s:replace[6:6]
let s:p.visual.ok       = s:visual[6:6]

let g:lightline#colorscheme#solarized_improved#palette = lightline#colorscheme#flatten(s:p)
