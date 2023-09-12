#!/bin/bash

source ~/.settings/install_scripts/common.sh

if ! which zsh ; then
    output "============== Installing ZSH =========================="
    sudo $PKGMGR zsh
fi

if [ ! -e ~/.oh-my-zsh ]; then
    #Install Oh my Zsh
    output "=============== Installing OH MY ZSH ================="
    curl -Lo oh.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
    sed -i 's/! chsh -s "$zsh"/false/g' oh.sh
    chmod +x oh.sh
    ./oh.sh
    rm -f ./oh.sh
fi

#Add additional plugins for ZSH not found in oh-my-zsh
ZSH_CUSTOMS_DIR=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
ZSH_CUSTOM_PLUGINS=${ZSH_CUSTOMS_DIR}/plugins

if [ ! -e ${ZSH_CUSTOM_PLUGINS}/alias-tips ]; then
    git clone https://github.com/djui/alias-tips.git ${ZSH_CUSTOM_PLUGINS}/alias-tips
fi

if [ ! -e ${ZSH_CUSTOM_PLUGINS}/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM_PLUGINS}/zsh-autosuggestions
fi

if [ ! -e ${ZSH_CUSTOM_PLUGINS}/notify ]; then
    git clone https://github.com/marzocchi/zsh-notify.git ${ZSH_CUSTOM_PLUGINS}/notify
fi

ZSH_CUSTOM_THEMES_DIR=${ZSH_CUSTOMS_DIR}/themes

if [ ! -e ${ZSH_CUSTOM_THEMES_DIR}/spaceship-prompt ]; then
    output "=============== Install custom zsh theme ==============="
    git clone https://github.com/denysdovhan/spaceship-prompt.git ${ZSH_CUSTOM_THEMES_DIR}/spaceship-prompt
    ln -s ${ZSH_CUSTOM_THEMES_DIR}/spaceship-prompt/spaceship.zsh-theme "${HOME}/.oh-my-zsh/themes/spaceship.zsh-theme"
fi

if [ ! -e ~/.zshrc.orig.ohmyzsh ]; then
    mv ~/.zshrc ~/.zshrc.orig.ohmyzsh
fi

if [ ! -e ~/.zshrc ]; then
    ln -s ~/.settings/zshrc ~/.zshrc
    echo "#Add your custom zsh settings to this file" > ~/.myzshrc
fi

output "=============== Setup Go directories ==============="
mkdir -p ~/.go-dirs
