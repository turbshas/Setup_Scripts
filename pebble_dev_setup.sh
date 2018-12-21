#!/usr/bin/bash

# Prerequisites
sudo apt install -y python-pip python2.7-dev python-gevent libsdl1.2debian libfdt1 libpixman-1-0 git gcc-arm-none-eabi npm perl
pip install virtualenv

# Setup pebble-dev directory, whatever that's supposed to do
PEBBLE_DEV_NAME="pebble-sdk-4.5-linux64.tar.gz"
mkdir ~/pebble-dev
cd ~/pebble-dev
~/.settings/gdown.pl https://drive.google.com/file/d/1fPYGkQJUKWAiXof1CCbCMWGZwIAELgEv/view\?usp\=sharing $PEBBLE_DEV_NAME
# The name suggests it is a tar.gz file (which is actually the way I created it), but after downloading
# from google drive, it appears to be a tar.bz2 file. idk how tf this happened, but w/e I'm too lazy to
# change the name
tar -jxf $PEBBLE_DEV_NAME || exit
echo "export PATH=~/pebble-dev/$PEBBLE_DEV_NAME/bin:\$PATH" >> ~/.myzshrc
. ~/.myzshrc
cd $PEBBLE_DEV_NAME
virtualenv --no-site-packages .env
source .env/bin/activate
pip install -r requirements.txt
deactivate

# Setup actual pebble sdk
SDK_FOLDER_NAME="pebble-sdk"
PEBBLE_SDK="$SDK_FOLDER_NAME.tar.gz"
~/.settings/gdown.pl https://drive.google.com/file/d/1GRXH_phqa2CNQ7BqKlLrH_cog57imJEF/view?usp=sharing $PEBBLE_SDK
cd ~
# The name suggests it is a tar.gz file (which is actually the way I created it), but after downloading
# from google drive, it appears to be a tar.bz2 file. idk how tf this happened, but w/e I'm too lazy to
# change the name
tar -jxf $PEBBLE_SDK || exit

# Clone repositories
cd ~
git clone https://github.com/ginge/FreeRTOS-Pebble.git
git clone https://github.com/turbshas/Pebble_Startup.git

# Make sure stuff works
pebble ping --emulator aplite
cd FreeRTOS-Pebble
git submodule update --init --recursive
make

