#!/bin/bash
set -eu
DOTPATH="$HOME/dotfiles"
TARBALL="https://github.com/mitsu0525/dotfiles/tarball/master"
REMOTE_URL="git@github.com:mitsu0525/dotfiles.git"

has() {
    type "$1" > /dev/null 2>&1
}

if [ -d "$DOTPATH" ]; then
    echo "$DOTPATH: already exists"
    exit 1
fi

# Download dotfiles
echo "Downloading dotfiles..."

if has "git"; then
    git clone --recursive "$REMOTE_URL" "$DOTPATH"

elif has "curl" || has "wget"; then
    if has "curl"; then
        curl -L "$TARBALL"

    elif has "wget"; then
        wget -O - "$TARBALL"

    fi | tar xvz

else
    echo "curl or wget required"
    exit 1
fi

# Deploy dotfiles
cd "$DOTPATH"
make deploy
