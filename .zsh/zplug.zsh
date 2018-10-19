ZPLUG_SUDO_PASSWORD=
ZPLUG_PROTOCOL=ssh

zplug "zplug/zplug", hook-build:'zplug --self-manage'

zplug "~/.zsh", from:local, use:"<->_*.zsh"

zplug "b4b4r07/enhancd", use:init.sh
if zplug check "b4b4r07/enhancd"; then
	export ENHANCD_FILTER="fzf --height 40% --reverse --ansi"
	export ENHANCD_DOT_SHOW_FULLPATH=1
fi

zplug "junegunn/fzf-bin", \
    as:command, \
    from:gh-r, \
    rename-to:"fzf", \
    frozen:1

zplug "junegunn/fzf", \
    as:command, \
    use:bin/fzf-tmux

zplug "peco/peco", \
    as:command, \
    from:gh-r, \
    frozen:1

# zplug "jhawthorn/fzy", \
#     as:command, \
#     rename-to:fzy, \
#     hook-build:"make && sudo make install"

# # Additional completion definitions for Zsh
# zplug "zsh-users/zsh-completions"

# Syntax highlighting bundle. zsh-syntax-highlighting must be loaded after
# excuting compinit command and sourcing other plugins.
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# ZSH port of Fish shell's history search feature
zplug "zsh-users/zsh-history-substring-search"

# This plugin adds many useful aliases and functions.
zplug "plugins/git", from:oh-my-zsh

# zplugなどでzをインストールしとく
zplug "rupa/z", use:z.sh
