#!/bin/bash

set -u
DOT_DIRECTORY="${HOME}/dotfiles"
DOT_CONFIG_DIRECTORY=".config"

echo "link home directory dotfiles"
cd ${DOT_DIRECTORY}
for f in .??*
do
    #無視したいファイルやディレクトリ
    [ "$f" = ".git" ] && continue
    [ "$f" = ".config" ] && continue
    [ "$f" = ".DS_STORE" ] && continue
    ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/${f}
done
echo "linked dotfiles complete!"
