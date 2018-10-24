#!/bin/bash
## If no server is set , we're done
[ -z "${SMTP_SERVER}" ] && exit 0

## Else go for ssmtp

conf_file=$(mktemp)

envsubst < /scripts/ssmtp.tpl > ${conf_file}

ssmtp -C${conf_file} $@
if [ $? -gt 0 ]; then
  rm ${conf_file}
  exit 1
fi
rm ${conf_file}