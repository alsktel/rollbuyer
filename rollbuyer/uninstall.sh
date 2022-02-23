#!/bin/bash

#
# Massa ROLLs autobuy uninstallation script
# Copyright (C) 2022 Alexander Elunin <https://github.com/eastev>
#


systemctl disable --quiet rollbuyerd
systemctl stop --quiet rollbuyerd

echo "Please make sure that Rollbuyer service is not running by this log line"
tail -n 1 /var/log/rollbuyer/rollbuyer.log
echo "If all is OK press any key to continue uninstalling..."

read -n 1 -s

RBDIR="$(cat /etc/rollbuyer/rollbuyer.conf | grep "RBDIR" | cut -d "=" -f2)"

rm -rf /var/log/rollbuyer
rm -rf /etc/rollbuyer
rm -rf /bin/rollbuyerd
rm -rf /etc/systemd/system/rollbuyerd.service
rm -rf $RBDIR

exit 0
