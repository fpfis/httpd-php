FROM ubuntu:18.04

ENV TIMEOUT=120 DOCUMENT_ROOT="/var/www/html" PORT=8080 APACHE_EXTRA_CONF="" APACHE_EXTRA_CONF_DIR="" APACHE_ERROR_LOG="/dev/stderr" APACHE_ACCESS_LOG="/var/log/apache2/access"
ENV PHP_VERSION="7.2" FPM_START_SERVERS=20 FPM_MIN_CHILDREN=10 FPM_MAX_CHILDREN=30 FPM_MAX_REQUESTS=500 PHP_ERROR_LOG="/dev/stderr" PHP_DISPLAY_ERRORS="Off" PHP_DEPENDENCIES="common cli fpm soap bz2 opcache zip xsl intl imap mbstring ldap mysql gd memcached redis curl sqlite bcmath"
ENV SUPERVISOR_CONF_DIR="/etc/supervisor/" DAEMON_USER="www-data" DAEMON_GROUP="www-data" DEBIAN_FRONTEND="noninteractive"

### Configure timezone / adding ssmtp / default dep
RUN apt-get update && apt-get install cronolog tzdata ssmtp git curl vim supervisor -y && sed -ri 's@^mailhub=mail$@mailhub=127.0.0.1@' /etc/ssmtp/ssmtp.conf && ln -fs /usr/share/zoneinfo/Europe/Brussels /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

### Install Apache / PHP/FPM (including modules)
RUN apt-cache madison php | grep -q "1:${PHP_VERSION}+" && apt-get install apache2 php${PHP_VERSION} -y && apt-get install `for PHP_DEPENDENCY in ${PHP_DEPENDENCIES}; do echo -n "php${PHP_VERSION}-${PHP_DEPENDENCY} "; done` -y

### Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

### Configure php/php-fpm
ADD conf/php-fpm/ /etc/php/$PHP_VERSION/fpm/
ADD conf/php/ /etc/php/$PHP_VERSION/fpm/conf.d/

### Revamp apache configuration
ADD conf/apache2/ /etc/apache2/

### Cleanup php/apache configuration
RUN phpdismod exif readline shmop sysvmsg sysvsem sysvshm wddx igbinary; a2enmod proxy_fcgi rewrite headers; a2disconf php7.2-fpm other-vhosts-access-log; a2dissite 000-default

### Adding supervisor configuration
COPY conf/supervisor/ /etc/supervisor/
ADD run.sh /

EXPOSE 8080
EXPOSE 9001

ENTRYPOINT ["/run.sh"]
