#!/bin/bash

DATA_FILENAME=${1:?no filename provided}
DATA_PATH="./data/shared/torrents/${DATA_FILENAME}"

DATA_COUNT=${DATA_COUNT:=64}

dd bs=1m count=${DATA_COUNT} if=/dev/urandom of=${DATA_PATH}

IPV4_TRACKER=`cat ./data/builder/metadata/ipv4.address`
IPV6_TRACKER=`cat ./data/builder/metadata/ipv6.address`

ANNOUNCE_URLS="http://${IPV4_TRACKER}:6969/announce"

mktorrent -v -a ${ANNOUNCE_URLS} -o ${DATA_PATH}.torrent ${DATA_PATH}
