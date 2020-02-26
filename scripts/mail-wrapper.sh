#!/bin/bash
## If no server is set , we're done
[ -z "${SMTP_SERVER}" ] && exit 0

## Else go for msmtp

ARGS="--host=${SMTP_SERVER}"

[ ! -z "${SMTP_FROM}" ] && ARGS="${ARGS} -f ${SMTP_FROM}"
[ ! -z "${SMTP_PORT}" ] && ARGS="${ARGS} --port=${SMTP_PORT}"
[ ! -z "${SMTP_TLS}" ] && ARGS="${ARGS} --tls=${SMTP_TLS}"
[ ! -z "${SMTP_TLS_TRUST_FILE}" ] && ARGS="${ARGS} --tls-trust-file=${SMTP_TLS_TRUST_FILE}"
[ ! -z "${SMTP_STARTTLS}" ] && ARGS="${ARGS} --tls-starttls=${SMTP_STARTTLS}"
[ ! -z "${SMTP_USERNAME}" ] && ARGS="${ARGS} --auth=on --user=${SMTP_USERNAME}"
[ ! -z "${SMTP_PASSWORD}" ] && ARGS="${ARGS} --passwordeval=\"echo ${SMTP_PASSWORD}\""

eval "msmtp ${ARGS} -t"
