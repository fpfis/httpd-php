#/bin/sh

set -xue

apk add --no-cache --virtual .persistent-deps ca-certificates curl tar xz libressl 