#!bin/bash
set -e
set -x
apt-get update

# Install dev packages :
apt-get install -y php${php_version}-xdebug wget unzip patch git

# Install PHP dev packages :
wget https://github.com/composer/composer/releases/download/${composer_version}/composer.phar -O /usr/bin/composer
wget https://github.com/drush-ops/drush/releases/download/${drush_version}/drush.phar -O /usr/bin/drush
ln -s /usr/bin/composer /usr/local/bin/composer
chmod +x /usr/bin/composer /usr/bin/drush

apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
rm -Rf /root/.composer/cache
