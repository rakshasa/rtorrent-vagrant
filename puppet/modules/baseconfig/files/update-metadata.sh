#!/bin/bash

METADATA="/data/local/metadata"
PRIVATE_DEV="eth1"

ip addr show dev $PRIVATE_DEV permanent primary | sed -n 's_^.*inet \([0-9.]*\)/\([0-9]*\).*$_\1_p' > $METADATA/ipv4.address
ip addr show dev $PRIVATE_DEV permanent primary | sed -n 's_^.*inet \([0-9.]*\)/\([0-9]*\).*$_\2_p' > $METADATA/ipv4.prefix
ip addr show dev $PRIVATE_DEV permanent primary | sed -n 's_^.*inet6 \([0-9a-f:]*\)/\([0-9]*\).*$_\1_p' > $METADATA/ipv6.address
ip addr show dev $PRIVATE_DEV permanent primary | sed -n 's_^.*inet6 \([0-9a-f:]*\)/\([0-9]*\).*$_\2_p' > $METADATA/ipv6.prefix
