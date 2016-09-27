#!/bin/bash

DATA_FILE=${1:?no data path given}
DATA_COUNT=${DATA_COUNT:=512}

IPV4_TRACKER=`cat ./data/builder/metadata/ipv4.address`
IPV6_TRACKER=`cat ./data/builder/metadata/ipv6.address`

dd bs=1m count=${DATA_COUNT} if=/dev/urandom of=${DATA_FILE}

mktorrent -v -a http://${IPV4_TRACKER}:6969 ${DATA_FILE}
