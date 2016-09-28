#!/bin/bash

SEED_NODE=${2:-node1}

DATA_FILENAME=${1:?no filename provided}
DATA_PATH="./data/torrents/${DATA_FILENAME}"

# TODO: Check that filename and torrent exists.

# TODO: Change this so that we move the torrent data to a non-NFS
# filesystem belonging to the vm.

ln ${DATA_PATH} ./data/${SEED_NODE}/torrents/${DATA_FILENAME}
ln ${DATA_PATH}.torrent ./data/shared/watch/
