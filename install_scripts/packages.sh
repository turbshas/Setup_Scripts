#!/bin/bash

source ~/.settings/install_scripts/common.sh

if ! which curl ; then
    output "============== Installing curl =========================="
    sudo $PKGMGR curl
fi

if ! which ag ; then
    output "============== Installing Ag =========================="

    if [ "$OS" = "arch" ]; then
        sudo $PKGMGR the_silver_searcher
    else
        sudo $PKGMGR silversearcher-ag
    fi
fi

# Don't generally need this
# if ! which acpi; then
#     output "============== Installing ACPI utility =========================="
#     sudo $PKGMGR acpi
# fi
