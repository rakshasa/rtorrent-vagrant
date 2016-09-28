#!/bin/bash

CONF_FILE="/etc/opentracker.conf"
BIN="/usr/local/bin/opentracker"

LOG_FILE="/data/local/logs/tracker/opentracker.log"

if [ -f ${LOG_FILE} ]; then
  mv ${LOG_FILE} ${LOG_FILE}.`date +%F_%R`
fi

nohup ${BIN} -f ${CONF_FILE} > ${LOG_FILE} &

sleep 3
