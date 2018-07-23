#!/bin/bash
set -e

# Get uid for the current docroot
[ -z "${DOCUMENT_ROOT}" ] && export DOCUMENT_ROOT=/var/www/html

# Check if docroot or parent exists :
[ -d "${DOCUMENT_ROOT}" ] && export REF_DIR=${DOCUMENT_ROOT}
# Else use its parent
[ -z "${REF_DIR}" ] && export REF_DIR=$(dirname ${DOCUMENT_ROOT})

# Get our command to run
export CMD="${@}"

# If APACHE_EXTRA_CONF isn't being set outside, set it to an empty value.
if [ -z ${APACHE_EXTRA_CONF} ]; then export APACHE_EXTRA_CONF=""; fi

if [ -z "${CMD}" ]; then
  # If no run command provided, run supervisor as root a:
  /usr/bin/supervisord -c /etc/supervisord/supervisord.conf
else
  # Run the command as user web
  if ! `grep -q www-data /etc/passwd`
  then
    eval "${CMD}"
  else
    HOME=/tmp su -s /bin/bash -c "${CMD}" www-data
  fi
fi
