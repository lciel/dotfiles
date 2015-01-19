#!/bin/bash

git submodule init
git submodule update

if uname -a | grep Darwin -q; then
    SERVICE_DIR=/Library/StartupItems/ClipboardTextListener
    echo "Install ClipboardTextListener to OSX..."
    if [ ! -e $SERVICE_DIR ]; then
        sudo mkdir -p $SERVICE_DIR
    fi
    sudo ln -s $(PWD)/ClipboardTextListener $SERVICE_DIR/scripts
    sudo cp startup_script $SERVICE_DIR/ClipboardTextListener
    sudo cp StartupParameters.plist $SERVICE_DIR/ClipboardTextListener
    sudo chmod 755 $SERVICE_DIR/ClipboardTextListener
    sudo chown -R root:wheel $SERVICE_DIR
fi
