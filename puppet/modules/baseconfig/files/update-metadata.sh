#!/bin/bash

METADATA="/data/local/metadata"
PRIVATE_DEV="eth1"

ip addr show dev $PRIVATE_DEV permanent primary | sed -n 's/^.*inet \([0-9.]*\).*$/\1/p' > $METADATA/ipv4.address
ip addr show dev $PRIVATE_DEV permanent primary | sed -n 's/^.*inet6 \([0-9a-f:]*\).*$/\1/p' > $METADATA/ipv6.address
