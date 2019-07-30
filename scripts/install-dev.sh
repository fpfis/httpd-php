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

#Install webshell
wget -O /tmp/webconsole.zip https://github.com/nickola/web-console/releases/download/v0.9.7/webconsole-0.9.7.zip
unzip /tmp/webconsole.zip webconsole/webconsole.php -d /var/www
mv /var/www/webconsole/webconsole.php /var/www/webconsole/index.php
sed -i '0,/false/{s/false/true/}' /var/www/webconsole/index.php
rm -f /tmp/webconsole.zip



apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
rm -Rf /root/.composer/cache
