# Ctrl-t
function tree-fzf() {
  local SELECTED_FILE=$(tree --charset=o -f | fzf --query "$LBUFFER" | tr -d '\||`|-' | xargs echo)

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
bindkey "^t" tree-fzf

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

  zle reset-prompt
}

# Ctrl-f
zle -N history-fzf
bindkey '^r' history-fzf
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
