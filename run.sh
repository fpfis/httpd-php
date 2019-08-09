#!/bin/bash
set -e

PHP_INI_SCAN_DIR=/etc/php/${PHP_VERSION}/fpm-${ENVIRONMENT}/conf.d 

# Get our command to run
export CMD="${@}"

if [ -z "${CMD}" ]; then
  # If no run command provided, run supervisor as root a:
  /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
else
  # Run the command as user web
  eval "${CMD}"
fi
