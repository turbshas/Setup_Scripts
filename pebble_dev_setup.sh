#!/bin/bash

set -ex

# Prerequisites
sudo apt install -y python-pip python2.7-dev python-gevent libsdl1.2debian libfdt1 libpixman-1-0 git gcc-arm-none-eabi npm perl gdb-multiarch virtualenv

# Setup pebble-dev directory, whatever that's supposed to do
PEBBLE_DEV_NAME="pebble-sdk-4.5-linux64"
PEBBLE_DEV_TAR_NAME="$PEBBLE_DEV_NAME.tar.gz"
if [ ! -e ~/pebble-dev ]; then
    mkdir ~/pebble-dev
    cd ~/pebble-dev
    ~/.settings/gdown.pl https://drive.google.com/file/d/1fPYGkQJUKWAiXof1CCbCMWGZwIAELgEv/view\?usp\=sharing $PEBBLE_DEV_NAME
    # The name suggests it is a tar.gz file (which is actually the way I created it), but after downloading
    # from google drive, it appears to be a tar.bz2 file. idk how tf this happened, but w/e I'm too lazy to
    # change the name
    tar -jxf $PEBBLE_DEV_NAME
    echo "export PATH=~/pebble-dev/$PEBBLE_DEV_NAME/bin:\$PATH" >> ~/.myzshrc
    . ~/.myzshrc
    cd $PEBBLE_DEV_NAME
else
    cd ~/pebble-dev/$PEBBLE_DEV_NAME
fi
virtualenv --no-site-packages .env
source .env/bin/activate
pip install -r requirements.txt
deactivate

# Setup actual pebble sdk
SDK_FOLDER_NAME="pebble-sdk"
PEBBLE_SDK="$SDK_FOLDER_NAME.tar.gz"
if [ ! -e ~/.pebble-sdk ]; then
    cd ~
    ~/.settings/gdown.pl https://drive.google.com/file/d/1GRXH_phqa2CNQ7BqKlLrH_cog57imJEF/view?usp=sharing $PEBBLE_SDK
    # The name suggests it is a tar.gz file (which is actually the way I created it), but after downloading
    # from google drive, it appears to be a tar.bz2 file. idk how tf this happened, but w/e I'm too lazy to
    # change the name
    tar -jxf $PEBBLE_SDK
fi

if [ ! -e ~/Pebble_Startup ]; then
    # Clone my repo
    cd ~
    git clone https://github.com/turbshas/Pebble_Startup.git
fi

if [ ! -e ~/FreeRTOS-Pebble ]; then
    # Clone and setup FreeRTOS-Pebble (RebbleOS)
    git clone https://github.com/ginge/FreeRTOS-Pebble.git
    cd FreeRTOS-Pebble
    git submodule update --init --recursive
fi

if [ ! -e ~/FreeRTOS-Pebble/Resources/snowy_fpga.bin ]; then
    cd ~/FreeRTOS-Pebble
    mkdir -p Resources
    cd Resources
    wget http://emarhavil.com/~joshua/snowy_fpga.bin
    wget http://emarhavil.com/~joshua/chalk_fpga.bin
fi

# Make sure stuff works
pebble ping --emulator aplite
cd ~/FreeRTOS-Pebble
make

