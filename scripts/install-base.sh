#!bin/bash
set -e
set -x

# Fix www-data uid/gid :
#usermod -u ${USER_ID} www-data
#groupmod -g ${GROUP_ID} www-data

# Force usage of local repos
sed -i -e 's/http:\/\/archive/mirror:\/\/mirrors/' -e 's/http:\/\/security/mirror:\/\/mirrors/' -e 's/\/ubuntu\//\/mirrors.txt/' /etc/apt/sources.list

apt-get update
apt-get dist-upgrade -y
apt-get install -y software-properties-common
add-apt-repository -y ppa:ondrej/php

if [ "${php_version}" == "7.2" ] || [ "${php_version}" -gt "7.3" ]
then
	php_modules=$(echo ${php_modules} | sed 's/mcrypt//')
fi

modules=$(printf "php${php_version}-%s " ${php_modules})

apt-get install -y supervisor apache2 php${php_version}-fpm ${modules} msmtp

apt-get autoremove software-properties-common -y --purge
apt-get clean
rm -rf /var/lib/apt/lists/*

ln -s /bin/true /usr/sbin/sendmail
