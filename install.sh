#!/bin/bash

FILES=(.zsh .zshrc .vim .vimrc .gitconfig .gitignore_global .screenrc)

git submodule init
git submodule update

for file in ${FILES[@]}
do
    ln -s $(pwd)/$file ~/$file
done

if [ $(uname -a) = Darwin ]; then
    if [ ! -e ~/.screen ]; then
        mkdir -p ~/.screen
    fi
fi
