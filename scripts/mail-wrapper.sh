#!/bin/bash
## If no server is set , we're done
[ -z "${SMTP_SERVER}" ] && exit 0

## Else go for msmtp

ARGS="--host=${SMTP_SERVER}"

[ ! -z "${SMTP_FROM}" ] && ARGS="${ARGS} -f ${SMTP_FROM}"
[ ! -z "${SMTP_PORT}" ] && ARGS="${ARGS} --port ${SMTP_PORT}"
[ ! -z "${SMTP_USERNAME}" ] && ARGS="${ARGS} --username=${SMTP_USERNAME}"
[ ! -z "${SMTP_PASSWORD}" ] && ARGS="${ARGS} --passwordeval='echo ${SMTP_PASSWORD}'"

msmtp ${ARGS} $@