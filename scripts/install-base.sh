#!bin/bash
set -e
set -x

# Fix www-data uid/gid :
usermod -u ${USER_ID} www-data
groupmod -g ${GROUP_ID} www-data

# Force usage of local repos
sed -i -e 's/http:\/\/archive/mirror:\/\/mirrors/' -e 's/http:\/\/security/mirror:\/\/mirrors/' -e 's/\/ubuntu\//\/mirrors.txt/' /etc/apt/sources.list

apt-get update
apt-get dist-upgrade -y
apt-get install -y software-properties-common
add-apt-repository -y ppa:ondrej/php

for module in ${php_modules}; do
  if [ "${php_version}" == "7.2" ] && [ "${module}" == "mcrypt" ]; then
    echo "WARNING: ${module} not supported on 7.2"
    continue
  fi
  modules="php${php_version}-${module} ${modules}"
done

apt-get install -y supervisor apache2 php${php_version}-fpm ${modules} msmtp

apt-get autoremove software-properties-common -y --purge
apt-get clean
rm -rf /var/lib/apt/lists/*

ln -s /bin/true /usr/sbin/sendmail
