#!/bin/bash
set -e

# Get our command to run
export CMD="${@}"

if [ -z "${CMD}" ]; then
  # If no run command provided, run supervisor as root a:
  /usr/bin/supervisord -cn /etc/supervisor/supervisord.conf
else
  # Run the command as user web
  eval "${CMD}"
fi
