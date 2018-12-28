#!/bin/bash
set -e

# Get our command to run
export CMD="${@}"

if [ -z "${CMD}" ]; then
  # If no run command provided, run supervisor as root a:
  /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
else
  # Run the command as user web
  if ! `grep -q www-data /etc/passwd`
  then
    eval "${CMD}"
  else
    HOME=/tmp su -s /bin/bash -c "${CMD}" www-data
  fi
fi
