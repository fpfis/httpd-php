#!bin/bash
set -e
set -x
apt-get update
apt-get install -y software-properties-common
add-apt-repository -y ppa:ondrej/php


for module in ${php_modules}; do
  modules="php${php_version}-${module} ${modules}"
done

apt-get install -y apache2 php${php_version}-fpm ${modules}

apt-get autoremove software-properties-common -y --purge
apt-get clean
rm -rf /var/lib/apt/lists/*
