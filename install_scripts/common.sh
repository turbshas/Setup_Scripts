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

source ~/.settings/instal_scripts/ask.sh

source ~/.settings/instal_scripts/output.sh
