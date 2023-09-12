#!/bin/bash

source ~/.settings/install_scripts/common.sh

if [ "$OS" = "arch" ]; then
    sudo $PKGMGR gtk-engine-murrine gtk-engines
else
    sudo $PKGMGR gtk2-engines-murrine gtk2-engines-pixbuf
fi

if [ ! -e ~/.themes ]; then
    ln -s ~/.settings/themes ~/.themes
fi

if [ ! -e /tmp/powerline/fonts ]; then
    output "=============== Install custom font ==============="
    mkdir -p /tmp/powerline
    cd /tmp/powerline
    if [ ! -e fonts ]; then
        git clone https://github.com/powerline/fonts.git
    fi
    cd fonts
    #install all fonts
    ./install.sh
fi
