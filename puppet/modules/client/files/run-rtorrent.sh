#!/bin/bash

export RTORRENT="rtorrent -n -o try_import=/etc/rtorrent.rc,system.daemon.set=true"
export SCREEN_NAME="rtorrent"

#sudo -u rtorrent bash -c "script -qc 'screen -DmUS $SCREEN_NAME $RTORRENT' /dev/null"
#sudo -u rtorrent bash -c "nohup $RTORRENT > /data/local/logs/rtorrent/daemon.log &"
nohup $RTORRENT > /data/local/logs/rtorrent/daemon.log &

#disown -a
sleep 3
