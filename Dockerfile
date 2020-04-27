FROM ubuntu:20.04

ENV ENVIRONMENT=prd TIMEOUT=120 DOCUMENT_ROOT="/var/www/html" PORT=8080 APACHE_EXTRA_CONF_DIR="" APACHE_ERROR_LOG="/var/log/apache.err" APACHE_ACCESS_LOG="/var/log/access" ALLOWINDEXES="+Indexes" ALLOWOVERRIDE="none"
ENV PHP_VERSION="7.4" FPM_MAX_CHILDREN=100 FPM_START_SERVERS=20 FPM_MIN_SPARE_SERVER=10 FPM_MAX_SPARE_SERVER=30 FPM_MAX_REQUESTS=500 PHP_UPLOAD_MAX_FILESIZE="200M" PHP_POST_MAX_SIZE="220M" PHP_SESSION_PATH="/tmp" PHP_ERROR_LOG="/var/log/php.err" PHP_DISPLAY_ERRORS="Off" PHP_OPCACHE="On" PHP_XDEBUG_REMOTE_HOST="172.17.0.1" PHP_DEPENDENCIES="common cli fpm soap bz2 opcache zip xsl intl imap mbstring ldap mysql gd memcached redis curl sqlite bcmath xdebug"
ENV SUPERVISOR_LOG_PATH="/var/log/" SUPERVISOR_CONF_DIR="/etc/supervisor/" DAEMON_USER="www-data" DAEMON_GROUP="www-data" SUPERVISORCTL_LISTEN_PORT="9001" SUPERVISORCTL_USER="admin" SUPERVISORCTL_PASS="password" DEBIAN_FRONTEND="noninteractive"

### Configure timezone / adding ssmtp / default dep / Install Apache / PHP/FPM (including modules) / cleanup cache
RUN apt-get update && apt-get install unzip cronolog tzdata ssmtp git curl wget supervisor rsync mysql-client -y && sed -ri -e 's@^mailhub=mail$@mailhub=127.0.0.1@' -e 's@^#FromLineOverride@FromLineOverride@' /etc/ssmtp/ssmtp.conf && sed -i 's@:www-data:@:EC FPIS DO NOT REPLY:@' /etc/passwd && ln -fs /usr/share/zoneinfo/Europe/Brussels /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata && apt-cache madison php | grep -q "1:${PHP_VERSION}+" && apt-get install apache2 php${PHP_VERSION} -y && apt-get install `for PHP_DEPENDENCY in ${PHP_DEPENDENCIES}; do echo -n "php${PHP_VERSION}-${PHP_DEPENDENCY} "; done` -y; phpdismod exif readline shmop sysvmsg sysvsem sysvshm wddx; ln -s /etc/php/$PHP_VERSION/fpm /etc/php/$PHP_VERSION/fpm-prd && rsync -av /etc/php/$PHP_VERSION/fpm/ /etc/php/$PHP_VERSION/fpm-dev && phpdismod -s fpm xdebug && rm -v /etc/php/$PHP_VERSION/fpm-dev/conf.d/10-opcache.ini && echo -e "xdebug.remote_connect_back=0\nxdebug.remote_host=\${PHP_XDEBUG_REMOTE_HOST}\nxdebug.remote_enable=1\nxdebug.remote_autostart=1" >> /etc/php/$PHP_VERSION/fpm-dev/conf.d/20-xdebug.ini && apt-get clean all; rm -rf /var/lib/apt/lists/* /etc/apache2/mods-enabled/status.conf; chmod o+rx /etc/ssmtp; chmod o+r /etc/ssmtp/*; > /var/www/html/index.html

### Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer; composer config -g cache-dir /cache/composer

### Configure php/php-fpm
ADD conf/php-fpm/ /etc/php/$PHP_VERSION/fpm/
ADD conf/php-fpm/ /etc/php/$PHP_VERSION/fpm-dev/
ADD conf/php/ /etc/php/$PHP_VERSION/fpm/conf.d/

### Revamp apache configuration
ADD conf/apache2/ /etc/apache2/

### Cleanup php/apache configuration
RUN a2enmod proxy_fcgi rewrite headers proxy_http; a2disconf php7.4-fpm other-vhosts-access-log; a2dissite 000-default; echo -n "<?php\n  opcache_reset();\n?>" > /var/www/flush_opcache.php; echo -n "<?php\n  echo json_encode(opcache_get_status());\n?>" > /var/www/opcache_json.php; curl https://raw.githubusercontent.com/anthosz/opcache-status/master/opcache.php > /var/www/opcache_status.php

### Adding supervisor configuration
COPY conf/supervisor/ /etc/supervisor/
ADD run.sh /

EXPOSE ${PORT} ${SUPERVISORCTL_LISTEN_PORT}

ENTRYPOINT ["/run.sh"]
