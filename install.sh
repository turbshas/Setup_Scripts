#!/bin/bash

set -exuo pipefail

#check what distro we are on
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "This distro is too old. Exiting..."
    exit
fi

#set package manager based on OS
if [ "$OS" = "arch" ]; then
    PKGMGR="pacman -S"
else
    PKGMGR="apt install -y"
fi

sudo $PKGMGR git

if [ ! -e ~/.settings ]; then
    echo "=============== Cloning the repo ================="
    git clone https://github.com/turbshas/Setup_Scripts.git ~/.settings
    cd ~/.settings
fi

source ~/.settings/install_scripts/common.sh

source ~/.settings/install_scripts/packages.sh

source ~/.settings/install_scripts/oh_my_zsh.sh

source ~/.settings/insall_scripts/vim.sh

source ~/.settings/install_scripts/themes.sh

# Usually don't have a GUI linux
# source ~/.settings/insall_scripts/gnome_terminal.sh
# 
# output "=============== Setting up Terminator ==============="
# ~/.settings/terminator/terminator.sh

output "=============== vimrc and zshrc files are now in your home folder ================="
output "=============== Add custom vim settings to .myvimrc and zsh settings to .myzshrc files ============"
output "=============== Setup successful =================="
