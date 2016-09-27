#!/bin/bash

DATA_FILE=${1:?no data path given}

dd bs=1m count=512 if=/dev/urandom of=$DATA_FILE
