# emacs keybinds
bindkey -e

bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
bindkey "^u" backward-kill-line

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
  local SELECTED_FILE=$(tree --noreport -af | fzf --query "$LBUFFER" | sed -e 's/-- //g' | tr -d '\||`' | xargs echo)

  if [ "$SELECTED_FILE" != "" ]; then
	if [ -f "$SELECTED_FILE" ]; then
	  BUFFER="$EDITOR $SELECTED_FILE"
    elif [ -d "$SELECTED_FILE" ]; then
      BUFFER="cd $SELECTED_FILE"
    fi
    zle accept-line
  fi

  zle reset-prompt
}
zle -N tree-fzf
bindkey "^o" tree-fzf

# Ctrl-r
function history-fzf() {
  local tac

  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi

  BUFFER=$(history -n 1 | eval $tac | fzf --query "$LBUFFER")
  CURSOR=$#BUFFER

  zle accept-line
  zle reset-prompt
}
zle -N history-fzf
bindkey '^r' history-fzf

# Ctrl-f
fzf-z-search() {
    local res=$(z | sort -rn | cut -c 12- | fzf)
    if [ -n "$res" ]; then
        BUFFER+="cd $res"
        zle accept-line
    else
        return 1
    fi
}
zle -N fzf-z-search
bindkey '^f' fzf-z-search

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
