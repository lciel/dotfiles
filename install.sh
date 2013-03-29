#!/bin/bash

FILES=(.zsh .zshrc .vim .vimrc .gitconfig .gitignore_global .screenrc)

for file in ${FILES[@]}
do
    ln -s $(pwd)/$file ~/$file
done

if [ $(uname -a) = Darwin ]; then
    if [ ! -e ~/.screen ]; then
        mkdir -p ~/.screen
    fi
fi
