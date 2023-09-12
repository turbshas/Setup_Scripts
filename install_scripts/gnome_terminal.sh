#!/bin/bash

source ~/.settings/install_scripts/common.sh

output "=============== Setting up gnome-terminal ==============="
sudo $PKGMGR libgconf2-dev
# uncheck use system font in gnome-terminal
gconftool-2 --set /apps/gnome-terminal/profiles/Default/use_system_font --type=boolean false
# set gnome-terminal to use powerline font
gconftool-2 --set /apps/gnome-terminal/profiles/Default/font --type string "Meslo LG S DZ for Powerline Regular 12"

# find Terminal UUID to settings can be edited
UUID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')

# enable custom command
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${UUID}/ use-custom-command true

# specify zsh as the custom command to run
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${UUID}/ custom-command /usr/bin/zsh

# uncheck use system theme colour gnome-terminal setting
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${UUID}/ use-theme-colors false
