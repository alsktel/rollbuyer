#!/bin/bash

#
# Massa ROLLs autobuy script
# Copyright (C) 2022 Alexander Elunin <https://github.com/eastev>
#


RBDIR="$(cat /etc/rollbuyer/rollbuyer.conf | grep "RBDIR" | cut -d "=" -f2)"
MCDIR="$(cat /etc/rollbuyer/rollbuyer.conf | grep "MCDIR" | cut -d "=" -f2)"
LOGFILE=$RBDIR/rollbuyer.log

WAITROLL=0


echo "[$(date)]: Roollbuyer started" > $LOGFILE

cd $MCDIR

while [ 1 == 1 ]
do
    if [[ "$(cat $RBDIR/rollbuyer.int | grep "S")" != "" ]]
    then
        echo "[$(date)]: Roollbuyer stopped" >> $LOGFILE

        rm $RBDIR/rollbuyer.int

        exit 0
    fi

    systemctl is-active --quiet massad

    if [[ $? != 0 ]]
    then
        echo "[$(date)]: Node is not working!" >> $LOGFILE

        sleep 5m

        continue
    fi

    INFO="./massa-client wallet_info"
    ADDRESS=`$INFO | grep "Address" | sed 's/^.*: //' | sed 's/\s.*$//'`
    ROLLS=`$INFO | grep "Candidate r" | sed 's/^.*: //' | sed 's/\s.*$//'`
    BALANCE=`$INFO | grep "Final b" | sed 's/^.*: //' | sed 's/\s.*$//' | sed 's/\..*$//'`

    if [[ $BALANCE < 100 ]] && [[ $WAITROLL == 0 ]]
    then
        if [[ $ROLLS == 0 ]]
        then
            echo "[$(date)]: Not enought tokens!" >> $LOGFILE
        fi
    else
        if [[ $ROLLS == 0 ]] && [[ $WAITROLL == 0 ]]
        then
            echo "[$(date)]: Trying to buy 1 roll..." >> $LOGFILE
            echo -n "[$(date)]: Operation ID:" >> $LOGFILE

            ./massa-client buy_rolls $ADDRESS 1 0 | tr '\n' ' ' | cut -d ":" -f2- >> $LOGFILE

            WAITROLL=1
        else
            if [[ $ROLLS != 0 ]] && [[ $WAITROLL != 0 ]]
            then
                echo "[$(date)]: Successfully bought 1 roll!" >> $LOGFILE

                WAITROLL=0
            fi
        fi
    fi

    sleep 5m
done
