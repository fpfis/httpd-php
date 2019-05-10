#!bin/bash
set -e
set -x
apt-get update

# Install ci packages :
apt-get install -y ${ci_packages}

adduser www-data root

apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
rm -Rf /root/.composer/cache
