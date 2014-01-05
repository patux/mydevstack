#!/bin/bash
if [ ! -e /etc/apt/sources.list-bk ]; then
    echo "Set a mx local mirror to the sources"
    mv /etc/apt/sources.list /etc/apt/sources.list-bk
    cat /etc/apt/sources.list-bk | sed s/us.archive/mx.archive/g > /etc/apt/sources.list 
    apt-get update -y
fi
#--------------------------------------------------------------------
# NO TUNABLES BELOW THIS POINT
#--------------------------------------------------------------------
if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi
# Micro minimal recipe that must be applied in the heart of the bootstrap
# Setting root pwd from the very beggining
if [ ! -z "$ADMIN_PWD" ]; then
    echo root:$ADMIN_PWD | chpasswd 
fi
