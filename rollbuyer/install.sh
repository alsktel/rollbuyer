#!/bin/bash

#
# Massa ROLLs autobuy installation script
# Copyright (C) 2022 Alexander Elunin <https://github.com/eastev>
#


if ! [[ -d $(pwd)/massa ]]
then
    echo "Please run this script from directory in which MASSA is installed"
    echo "E.g. if MASSA directory is /root/massa run this cript from /root"

    exit 1
fi

if ! [[ -d $(pwd)/rollbuyer ]]
then
    echo "Can't find Rollbuyer main directory from archive!"
    echo "If you have rollbuyer directory somewhere please copy it to $(pwd)"

    exit 2
fi

sudo chown -R $USER:$GROUP $(pwd)/rollbuyer

sudo chmod +x $(pwd)/rollbuyer/rollbuyerd.sh
sudo chmod +x $(pwd)/rollbuyer/rollbuyer.sh
sudo chmod +x $(pwd)/rollbuyer/install.sh
sudo chmod +x $(pwd)/rollbuyer/uninstall.sh

sudo ln -sf $(pwd)/rollbuyer/rollbuyerd.sh /bin/rollbuyerd

echo "" > $(pwd)/rollbuyer/rollbuyer.log
echo "RBDIR=$(pwd)/rollbuyer" >> $(pwd)/rollbuyer/rollbuyer.conf
echo "MCDIR=$(pwd)/massa/massa-client" >> $(pwd)/rollbuyer/rollbuyer.conf

if ! [[ -d /var/log/rollbuyer ]]
then
    sudo mkdir /var/log/rollbuyer
fi

sudo ln -sf $(pwd)/rollbuyer/rollbuyer.log /var/log/rollbuyer/

if ! [[ -d /etc/rollbuyer ]]
then
    sudo mkdir /etc/rollbuyer
fi

sudo ln -sf $(pwd)/rollbuyer/rollbuyer.conf /etc/rollbuyer/
sudo ln -sf $(pwd)/rollbuyer/rollbuyerd.service /etc/systemd/system

systemctl daemon-reload --quiet
systemctl enable --quiet rollbuyerd
systemctl start rollbuyerd

exit 0
