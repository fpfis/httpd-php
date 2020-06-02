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
apt-get install -y blackfire-php sudo

# Install NodeJS:
curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
curl -sL https://deb.nodesource.com/setup_10.x | bash -

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

apt update 
apt install -y nodejs yarn build-essential

cd /opt

yarn add --cache-folder /tmp wetty.js

#Install webshell
#wget -O /tmp/webconsole.zip https://github.com/nickola/web-console/releases/download/v0.9.7/webconsole-0.9.7.zip
#unzip /tmp/webconsole.zip webconsole/webconsole.php -d /var/www
#mv /var/www/webconsole/webconsole.php /var/www/webconsole/index.php
#sed -i '0,/false/{s/false/true/}' /var/www/webconsole/index.php
#rm -f /tmp/webconsole.zip

apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
rm -Rf /root/.composer/cache
