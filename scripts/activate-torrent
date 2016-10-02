#!/bin/bash

SEED_NODE=${2:-node1}

DATA_FILENAME=${1:?no filename provided}
DATA_VM_PATH="/data/shared/torrents/${DATA_FILENAME}"
DATA_VM_TORRENTS="/data/torrents/"
DATA_HOST_PATH="./data/shared/torrents/${DATA_FILENAME}"
DATA_HOST_WATCH="./data/shared/watch/"

# TODO: Check that filename and torrent exists.

vagrant ssh ${SEED_NODE} -c "cp -r '${DATA_VM_PATH}' '${DATA_VM_TORRENTS}'"
ln ${DATA_HOST_PATH}.torrent ${DATA_HOST_WATCH}
