#!/bin/bash
set -e

# Get uid for the current docroot
[ -z "${DOCUMENT_ROOT}" ] && export DOCUMENT_ROOT=/var/www/html

# Check if docroot or parent exists :
[ -d "${DOCUMENT_ROOT}" ] && export REF_DIR=${DOCUMENT_ROOT}
# Else use its parent
[ -z "${REF_DIR}" ] && export REF_DIR=$(dirname ${DOCUMENT_ROOT})

# Get our command to run
export CMD=$@

[ ! -d /run/php ] && mkdir /run/php
[ ! -d /run/apache2 ] && mkdir /run/apache2

[ ! -d /var/log/apache2 ] && mkdir /var/log/apache2
[ ! -d /var/log/supervisor ] && mkdir /var/log/supervisor
[ ! -d /var/log/php ] && mkdir /var/log/php

[ -f /run/apache2.pid ] && if ! ps -p $(cat /run/apache2.pid) | grep 'apache2' > /dev/null; then rm -f /run/apache2.pid; fi

if [ -z "${CMD}" ]; then
  # As root, let daemon handle the rest
  exec supervisord -c /etc/supervisor/supervisord.conf
else
  # TODO : us ref_dir's permissions to use it's UID
  eval ${CMD}
fi
