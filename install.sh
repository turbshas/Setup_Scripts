#!/bin/bash

set -ex

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

pwd=`pwd`
git_prog=`command -v git`
zsh_prog=`command -v zsh`
curl_prog=`command -v curl`

# Use colors, but only if connected to a terminal, and that terminal supports them.
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  NORMAL=""
fi

output()
{
	echo ""
	printf "${GREEN}"
	echo $1
	printf "${NORMAL}"
}

if [ -z "${curl_prog}" ]; then
    output "============== Installing Curl =========================="
	sudo $PKGMGR curl
fi

if [ -z "${git_prog}" ]; then
    output "============== Installing Git =========================="
	sudo $PKGMGR git
fi

if which vim; then
    output "============== Installing VIM =========================="
    sudo $PKGMGR vim
fi

if [ "$OS" = "arch" ]; then
    output "============== Installing Ag =========================="
    sudo $PKGMGR the_silver_searcher
else
    output "============== Installing Ag =========================="
    sudo $PKGMGR silversearcher-ag
fi

# Stuff for themes
if [ "$OS" = "arch" ]; then
    sudo $PKGMGR gtk-engine-murrine gtk-engines
else
    sudo $PKGMGR gtk2-engines-murrine gtk2-engines-pixbuf
fi

if which acpi; then
    output "============== Installing ACPI utility =========================="
    sudo $PKGMGR acpi
fi

if [ ! -e ~/.settings ]; then
    output "=============== Cloning the repo ================="
    git clone https://github.com/turbshas/Setup_Scripts.git ~/.settings
    cd ~/.settings
fi

if [ ! -e ~/.themes ]; then
    ln -s ~/.settings/themes ~/.themes
fi

#install zsh if not installed
if [ -z "${zsh_prog}" ]; then
	output "=============== Installing ZSH ================="
	sudo $PKGMGR zsh
fi

#Install Oh my Zsh
output "=============== Installing OH MY ZSH ================="
curl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh > oh.sh
sed -i '/env zsh/d' oh.sh
sed -i '/chsh -s/d' oh.sh
chmod +x oh.sh
./oh.sh
rm -f ./oh.sh

if [ -e ~/.oh-my-zsh ]; then
    rm -rf ~/.oh-my-zsh
fi
#Add additional plugins for ZSH not found in oh-my-zsh
git clone https://github.com/djui/alias-tips.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/alias-tips
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/marzocchi/zsh-notify.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/notify

#setup softlinks
if [ ! -e ~/.vimrc ]; then
    output "=============== Setting up Soft Links ================="
    ln -s ~/.settings/vimrc ~/.vimrc
fi
if [ ! -e ~/.zshrc.orig.ohmyzsh ]; then
    mv ~/.zshrc ~/.zshrc.orig.ohmyzsh
fi
echo "\"Add your custom vim settings to this file" > ~/.myvimrc
echo "#Add your custom zsh settings to this file" > ~/.myzshrc
if [ ~ -e ~/.zshrc ]; then
    ln -s ~/.settings/zshrc ~/.zshrc
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

if [ "$OS" = "ubuntu" ]; then
    output "=============== Installing vim-gtk to get global clipboard support ==============="
    sudo $PKGMGR vim-gtk
fi

output "=============== Setup Go directories ==============="
mkdir -p ~/.go-dirs

#open vim once to install Plug
vim +qall
#open vim now to install all plugins
vim "+PlugInstall --sync" +qall

output "=============== Install custom font ==============="
mkdir -p /tmp/powerline
cd /tmp/powerline
if [ ! -e fonts ]; then
    git clone https://github.com/powerline/fonts.git
fi
cd fonts
#install all fonts
./install.sh

output "=============== Setting up gnome-terminal ==============="
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


output "=============== Setting up Terminator ==============="
~/.settings/terminator/terminator.sh

if [ ! -e ~/.oh-my-zsh/custom/themes/spaceship-prompt ]; then
output "=============== Install custom zsh theme ==============="
    git clone https://github.com/denysdovhan/spaceship-prompt.git "${HOME}/.oh-my-zsh/custom/themes/spaceship-prompt"
    ln -s "${HOME}/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme" "${HOME}/.oh-my-zsh/themes/spaceship.zsh-theme"
fi

output "=============== vimrc and zshrc files are now in your home folder ================="
output "=============== Add custom vim settings to .myvimrc and zsh settings to .myzshrc files ============"
output "=============== Setup successful =================="
