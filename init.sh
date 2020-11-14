#!/bin/bash
set -eu
OS="$(uname -s)"

has() {
    type "$1" > /dev/null 2>&1
}

# Install zplug
[ ! -d $HOME/.zplug ] && curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

case $OS in
    Darwin) # MacOS
        if !(has "brew"); then
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi
        brew install tmux
        brew install python
        brew install vim
        ;;
    linux-gnu) # Ubuntu
        ;;
    *)
        echo "Working only OSX / Ubuntu"
        exit 1
        ;;
esac
