#!/bin/bash

source ~/.settings/install_scripts/common.sh

output "============== Installing VIM =========================="
if ! which vim ; then
    sudo $PKGMGR vim

    if [ "$OS" = "ubuntu" ]; then
        output "=============== Installing vim-gtk to get global clipboard support ==============="
        sudo $PKGMGR vim-gtk
    fi
fi

if [ ! -e ~/.vimrc ]; then
    output "=============== Setting up Soft Links ================="
    ln -s ~/.settings/vimrc ~/.vimrc
    echo "\"Add your custom vim settings to this file" > ~/.myvimrc
fi

if [ ! -e ~/.vim/plugin/cscope_maps.vim ]; then
    output "=============== Setting up cscope maps ====================="
	mkdir -p ~/.vim/plugin
    cd ~/.vim/plugin
    curl -O http://cscope.sourceforge.net/cscope_maps.vim
    cd - # go back to the previous directory
fi

if [ ! -e ~/.vim/colors/badwolf.vim ]; then
    output "=============== Downloading badwolf theme ====================="
    mkdir -p ${HOME}/.vim/colors
    cd ${HOME}/.vim/colors
    curl -O https://raw.githubusercontent.com/sjl/badwolf/master/colors/badwolf.vim
    cd -
fi

if [ ! -e ~/.vim/ftplugin/make.vim ]; then
    output "=============== Setting up Makefile ftplugin ==============="
	mkdir -p ~/.vim/ftplugin
    cd ~/.vim/ftplugin
    #do not expand tabs in a makefile
    echo "setlocal noexpandtab" > make.vim
    cd -
fi

#open vim once to install Plug
vim +qall
#open vim now to install all plugins
vim "+PlugInstall --sync" +qall
