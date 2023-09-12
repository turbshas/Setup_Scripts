#!/bin/bash

source ~/.settings/install_scripts/common.sh

if ! which terminator ; then
    output "=============== Install terminator ==============="
	sudo $PKGMGR terminator
fi

#create config directory if it does not exist 
if [ ! -d ~/.config/terminator ]; then
	mkdir -p ~/.config/terminator
fi

if [ ! -e ~/.config/terminator/config ]; then
	#create soft link to config file
	ln -s ~/.settings/terminator/config ~/.config/terminator/config
fi

