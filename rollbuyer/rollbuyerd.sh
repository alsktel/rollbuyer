#!/bin/bash

#
# Massa ROLLs autobuy daemon
# Copyright (C) 2022 Alexander Elunin <https://github.com/eastev>
#


if [[ $# == 0 ]] || [[ "$1" == "help" ]]
then
    echo ""
    echo -e "\033[1mMASSA ROLLs autobuy daemon\033[0m"
    echo "    Created by eastev"
    echo "<https://github.com/eastev>"
    echo ""
    echo -e "\033[1mUsage:\033[0m rollbuyerd [COMMAND]"
    echo ""
    echo -e "\033[1mCommands  Description\033[0m"
    echo "log       See rollbuyer log"
    echo "start     Start autobuy script"
    echo "stop      Stop autobuy script"
    echo "restart   Restart autobuy script"
    echo "uninstall Uninstall rollbuyer"
    echo ""

    exit 0
fi


RBDIR="$(cat /etc/rollbuyer/rollbuyer.conf | grep "RBDIR" | cut -d "=" -f2)"


if [[ "$1" == "log" ]]
then
    cat $RBDIR/rollbuyer.log | less

    exit 0
elif [[ "$1" == "start" ]]
then
    if ! [[ -f $RBDIR/rollbuyer.int ]] && ! [[ -f $RBDIR/rollbuyer.pid ]]
    then
        echo "" > $RBDIR/rollbuyer.int

        $RBDIR/rollbuyer.sh &

        echo $! > $RBDIR/rollbuyer.pid

        exit 0
    fi
elif [[ "$1" == "stop" ]]
then
    if [[ -f $RBDIR/rollbuyer.int ]] && [[ -f $RBDIR/rollbuyer.pid ]]
    then
        echo "S" > $RBDIR/rollbuyer.int

        pkill -P $(< $RBDIR/rollbuyer.pid) sleep

        sleep 1

        rm $RBDIR/rollbuyer.pid
    fi

    exit 0
elif [[ "$1" == "restart" ]]
then
    rollbuyerd stop
    rollbuyerd start

    exit 0
elif [[ "$1" == "uninstall" ]]
then
    rollbuyerd stop

    $RBDIR/uninstall.sh

    exit 0
else
    exit 1
fi
