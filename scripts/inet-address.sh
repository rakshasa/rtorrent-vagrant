#!/bin/bash

vagrant ssh ${1:?node not provided} -c "ip addr show dev eth1 permanent primary | grep 'inet ' | sed -n 's/^.*inet \([0-9.]*\).*$/\1/p'"
