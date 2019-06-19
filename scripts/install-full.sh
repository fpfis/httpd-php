#!bin/bash
set -e
set -x
apt-get update
apt-get install -y wget unzip mysql-client git patch

# Install composer
wget https://getcomposer.org/installer -O /tmp/composer-install

php /tmp/composer-install --install-dir=/usr/bin --filename=composer

# Touch up
ln -s /usr/bin/composer /usr/local/bin/composer
chmod +x /usr/bin/composer

# Install drush & security-checker
composer global require drush/drush:^8 sensiolabs/security-checker

apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
rm -Rf /root/.composer/cache
