#!/bin/bash
set -eu
OS="$(uname -s)"

has() {
    type "$1" > /dev/null 2>&1
}

case $OS in
    Darwin) # MacOS
        if !(has "brew"); then
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi
        brew install tmux
        brew install python
        brew install vim
        ;;
    Linux) # Ubuntu
	sudo add-apt-repository ppa:neovim-ppa/stable        
        sudo apt install -y zsh git tmux neovim python3-pip
        ;;
    *)
        echo "Working only OSX / Ubuntu"
        exit 1
        ;;
esac

# Install zinit
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
