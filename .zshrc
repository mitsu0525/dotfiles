umask 022
limit coredumpsize 0
bindkey -d

# Return if zsh is called from Vim
# if [[ -n $VIMRUNTIME ]]; then
#     return 0
# fi

# tmux_automatically_attach attachs tmux session
# automatically when your are in zsh
# if [[ ! -n $TMUX && $- == *l* ]]; then
#   # get the IDs
#   ID="`tmux list-sessions`"
#   if [[ -z "$ID" ]]; then
#     tmux new-session
#   fi
#   create_new_session="Create New Session"
#   ID="$ID\n${create_new_session}:"
#   ID="`echo $ID | fzf | cut -d: -f1`"
#   if [[ "$ID" = "${create_new_session}" ]]; then
#     tmux new-session
#   elif [[ -n "$ID" ]]; then
#     tmux attach-session -t "$ID"
#   else
#     : # Start terminal normally
#   fi
# fi

# anyenv がコマンドとして実行可能であれば anyenv を初期化します。
(( ${+commands[anyenv]} )) && eval "$(anyenv init - zsh)"

# zinit
source $HOME/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of zinit's installer chunk
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
# コマンドをサジェストするプラグインを遅延ロードします。
zinit ice wait"1" atload"_zsh_highlight"
zinit light zdharma/fast-syntax-highlighting
zinit ice wait"1" atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice svn pick"init.sh"; zinit light b4b4r07/enhancd
# if zplug check "b4b4r07/enhancd"; then
    export ENHANCD_FILTER="fzf --height 40% --reverse --ansi"
    export ENHANCD_DOT_SHOW_FULLPATH=1
    export ENHANCD_DISABLE_DOT=1
    export ENHANCD_DISABLE_HYPHEN=1
# fi
zinit ice from"gh-r" as"command" mv"fzf_* -> fzf"; zinit light junegunn/fzf-bin
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit snippet $HOME/.zsh/10_utils.zsh
zinit snippet $HOME/.zsh/20_keybinds.zsh
zinit snippet $HOME/.zsh/30_aliases.zsh
zinit snippet $HOME/.zsh/50_setopt.zsh
zinit snippet $HOME/.zsh/70_misc.zsh
