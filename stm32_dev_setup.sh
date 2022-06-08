#!/bin/bash
if [ ! -e ~/qemu_pebble ]; then
    sudo apt install -y libsdl1.2debian libfdt-dev libpixman-1-dev git gcc-arm-none-eabi npm perl gdb-multiarch libnewlib-arm-none-eabi libgtk2.0-dev

    git clone https://github.com/pebble/qemu.git ~/qemu_pebble
    cd ~/qemu_pebble
    git submodule update --init dtc

    # NOTE: before running make, need to #define out the memfd_create declared by
    # qemu/osdep.h in util/memfd.c
    ./configure --prefix="$HOME/qemu/pebble" --enable-tcg-interpreter --extra-ldflags=-g \
    --with-coroutine=gthread --enable-debug-tcg --enable-gtk \
    --enable-debug --disable-werror --target-list="arm-softmmu" \
    --extra-cflags=-DDEBUG_CLKTREE --extra-cflags=-DDEBUG_STM32_RCC \
    --extra-cflags=-DDEBUG_STM32_UART --extra-cflags=-DSTM32_UART_NO_BAUD_DELAY \
    --extra-cflags=-DDEBUG_GIC
    make -j4
    make install
    echo "Add the following directory to your path:"
    echo "~/qemu/pebble/bin"
fi

if [ ! -e ~/OS_Project ]; then
    cd ~
    git clone https://github.com/turbshas/OS_Project.git
fi

