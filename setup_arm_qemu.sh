#!/bin/bash

set -exuo pipefail

XPACK_VERSION="2.8.0-12"
XPACK_DIRECTORY="xpack-qemu-arm-$XPACK_VERSION"
XPACK_TAR="$XPACK_DIRECTORY-linux-x64.tar.gz"
XPACK_GITHUB="https://github.com/xpack-dev-tools/qemu-arm-xpack/releases/download"

cd ~

if [ ! -e "$HOME/$XPACK_DIRECTORY" ]; then
    wget "$XPACK_GITHUB/v$XPACK_VERSION/$XPACK_TAR"
    tar -xzf $XPACK_TAR
fi

NEW_PATH_STRING="\$PATH:$HOME/$XPACK_DIRECTORY/bin"
ADD_TO_PATH_STRING="export PATH=\"$NEW_PATH_STRING\""
set +x
echo "Run the following line to add the xpack directory to the PATH:"
echo "echo '$ADD_TO_PATH_STRING' >> ~/.myzshrc"

