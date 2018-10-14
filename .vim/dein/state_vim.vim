if g:dein#_cache_version !=# 100 || g:dein#_init_runtimepath !=# '/Users/k-mituys/.vim/dein/repos/github.com/Shougo/dein.vim/,/Users/k-mituys/.vim,/usr/local/share/vim/vimfiles,/usr/local/share/vim/vim81,/usr/local/share/vim/vimfiles/after,/Users/k-mituys/.vim/after' | throw 'Cache loading error' | endif
let [plugins, ftplugin] = dein#load_cache_raw(['/Users/k-mituys/.vimrc', '/Users/k-mituys/.vim/rc/dein.toml', '/Users/k-mituys/.vim/rc/dein_lazy.toml'])
if empty(plugins) | throw 'Cache loading error' | endif
let g:dein#_plugins = plugins
let g:dein#_ftplugin = ftplugin
let g:dein#_base_path = '/Users/k-mituys/.vim/dein'
let g:dein#_runtime_path = '/Users/k-mituys/.vim/dein/.cache/.vimrc/.dein'
let g:dein#_cache_path = '/Users/k-mituys/.vim/dein/.cache/.vimrc'
let &runtimepath = '/Users/k-mituys/.vim/dein/repos/github.com/Shougo/dein.vim/,/Users/k-mituys/.vim,/usr/local/share/vim/vimfiles,/Users/k-mituys/.vim/dein/repos/github.com/Shougo/dein.vim,/Users/k-mituys/.vim/dein/.cache/.vimrc/.dein,/usr/local/share/vim/vim81,/Users/k-mituys/.vim/dein/.cache/.vimrc/.dein/after,/usr/local/share/vim/vimfiles/after,/Users/k-mituys/.vim/after'
  set background=dark
  au MyAutoCmd VimEnter * nested colorscheme solarized
