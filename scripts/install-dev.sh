#!bin/bash
set -e
set -x
apt-get update

# Install dev packages :
apt-get install -y gnupg wget ${dev_packages}

# Install blackfire :
wget -q -O - https://packages.blackfire.io/gpg.key | apt-key add -
echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list
apt-get update
apt-get install -y blackfire-php

apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
rm -Rf /root/.composer/cache
