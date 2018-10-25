# emacs keybinds
bindkey -e

bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
bindkey '^u' backward-kill-line

# smart insert
autoload smart-insert-last-word
zle -N insert-last-word smart-insert-last-word
bindkey '^]' insert-last-word

#
# functions
#
_delete-char-or-list-expand() {
    if [ -z "$RBUFFER" ]; then
        zle list-expand
    else
        zle delete-char
    fi
}
zle -N _delete-char-or-list-expand
bindkey '^D' _delete-char-or-list-expand

# Ctrl-o
function tree-fzf() {
  # local SELECTED_FILE=$(tree --noreport -af -I '.git'| fzf --query "" | tr -d '│|─|├|└' )
  local SELECTED_FILE=$(ls -1A | fzf --multi --query "")

  if [ "$SELECTED_FILE" != "" ]; then
      BUFFER=$LBUFFER$SELECTED_FILE
      CURSOR=$#BUFFER
  fi

  zle reset-prompt
}
zle -N tree-fzf
bindkey '^o' tree-fzf

# Ctrl-r
function history-fzf() {
    BUFFER=$(history -n -r 1 | fzf --no-sort --query "$LBUFFER" )
    if [ "$BUFFER" != "" ]; then
        zle accept-line
    fi

    zle reset-prompt
}
zle -N history-fzf
bindkey '^r' history-fzf

# # Ctrl-f
function fzf-cdr() {
    local SELECTED_DIR=$(__enhancd::history::list | __enhancd::utils::grep -vx "$HOME" | head -n "$ENHANCD_HYPHEN_NUM" | __enhancd::filter::interactive)
    if [ -d "$SELECTED_DIR" ]; then
        BUFFER="cd $SELECTED_DIR"
        zle accept-line
    fi

    zle reset-prompt
}
zle -N fzf-cdr
bindkey '^f' fzf-cdr

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
