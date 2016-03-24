#!/bin/bash

FILES=(.zsh .zshrc .zshenv .vim .vimrc .gitconfig .gitignore_global .screenrc .xvimrc .ctags .editrc .iterm2, .exchangekey .zplug .zshrc.zplug .tmux.conf .tmux .peco)

git submodule init
git submodule update

for file in ${FILES[@]}
do
    if [ ! -e ~/$file ]; then
        echo "create symlink ~/${file}"
        ln -s $(pwd)/$file ~/$file
    fi
done

if [ $(uname -s) = Darwin ]; then
    if [ ! -e ~/.screen ]; then
        echo "create dir ~/.screen"
        mkdir -p ~/.screen
    fi

    if [ ! -e /usr/local/Library/Brewfile ]; then
        echo "copy Brewfile"
        ln -s $(pwd)/osx/Brewfile /usr/local/Library/Brewfile
        echo "do exec bellow commands"
        echo ">> brew tap rcmdnk/brewall"
        echo ">> brew install brewall"
        echo ">> brewall"
    fi

    ln -s $(pwd)/.screenrc.local ~/.screenrc.local
fi
