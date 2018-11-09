# emacs keybinds
bindkey -e

bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
bindkey '^U' backward-kill-line

# smart insert
autoload smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
bindkey '^]' insert-last-word

#
# functions
#

# Ctrl-d
_delete-char-or-list-expand() {
    if [ -z "$RBUFFER" ]; then
        zle list-expand
    else
        zle delete-char
    fi
}
zle -N _delete-char-or-list-expand
bindkey '^D' _delete-char-or-list-expand

# Ctrl-f
function fzf-cdr() {
    local SELECTED_DIR=$(__enhancd::history::list | __enhancd::utils::grep -vx "$HOME" | head -n "$ENHANCD_HYPHEN_NUM" | __enhancd::filter::interactive)
    if [ -d "$SELECTED_DIR" ]; then
        BUFFER="cd $SELECTED_DIR"
        zle accept-line
    fi

    zle reset-prompt
}
zle -N fzf-cdr
bindkey '^s' fzf-cdr

# Ctrl-o
function fzf-find-file() {
    if git rev-parse 2> /dev/null; then
        source_files=$(git ls-files)
    else
        source_files=$(find . -type f)
    fi

    SELECTED_FILES=$(echo "$source_files" | fzf --multi --prompt="[FILES] " | tr '\n' ' ')

    if [ "$SELECTED_FILES" != "" ]; then
        BUFFER=$LBUFFER$SELECTED_FILES
        CURSOR=$#BUFFER
    fi

    zle reset-prompt
}
zle -N fzf-find-file
bindkey '^O' fzf-find-file

# Ctrl-r
function history-fzf() {
    BUFFER=$(history -n -r 1 | fzf --no-sort --query="$LBUFFER" --prompt="[HISTORY] ")
    if [ "$BUFFER" != "" ]; then
        zle accept-line
    fi

    zle reset-prompt
}
zle -N history-fzf
bindkey '^R' history-fzf

# Ctrl-z
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# expand global aliases by space
# http://blog.patshead.com/2012/11/automatically-expaning-zsh-global-aliases---simplified.html
globalias() {
   if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
     zle _expand_alias
   fi
   zle self-insert
}
zle -N globalias
bindkey " " globalias
