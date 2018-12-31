FROM ubuntu:18.04

ENV PHP_VERSION 7.2 
ENV DOCUMENT_ROOT /var/www/html
ENV PORT 8080
ENV APACHE_EXTRA_CONF ""
ENV APACHE_EXTRA_CONF_DIR ""
ENV APACHE_ERROR_LOG /dev/stderr
ENV APACHE_ACCESS_LOG /dev/stdout
ENV FPM_START_SERVERS 20
ENV FPM_MIN_CHILDREN 10
ENV FPM_MAX_CHILDREN 30
ENV FPM_MAX_REQUESTS 500
ENV PHP_ERROR_LOG /dev/stderr
ENV PHP_DISPLAY_ERRORS Off
ENV SUPERVISOR_CONF_DIR /etc/supervisor/
ENV DAEMON_USER "www-data"
ENV DAEMON_GROUP "www-data"
ENV DEBIAN_FRONTEND=noninteractive

### Configure timezone / adding 
RUN apt-get update && apt-get install -y tzdata ssmtp git curl && sed -ri 's@^mailhub=mail$@mailhub=127.0.0.1@' /etc/ssmtp/ssmtp.conf && ln -fs /usr/share/zoneinfo/Europe/Brussels /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

### Install Apache / PHP/FPM (including modules)
RUN apt-get install apache2 libapache2-mod-fcgid php${PHP_VERSION} php${PHP_VERSION}-common php${PHP_VERSION}-cli php${PHP_VERSION}-fpm php${PHP_VERSION}-soap php${PHP_VERSION}-bz2 php${PHP_VERSION}-opcache php${PHP_VERSION}-zip php${PHP_VERSION}-xsl php${PHP_VERSION}-intl php${PHP_VERSION}-mbstring php${PHP_VERSION}-ldap php${PHP_VERSION}-mysql php${PHP_VERSION}-gd php${PHP_VERSION}-memcached php${PHP_VERSION}-redis php${PHP_VERSION}-curl php${PHP_VERSION}-sqlite php${PHP_VERSION}-bcmath -y

### Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

### Configure php/php-fpm
ADD conf/phpfpm/ /etc/php/$PHP_VERSION/fpm/
ADD conf/php/ /etc/php/$PHP_VERSION/fpm/conf.d/

### Cleanup php/apache configuration
RUN rm -rf /etc/apache2/sites-* /etc/apache2/conf-* /etc/apache2/ports.conf /etc/apache2/mods-* /etc/php/$PHP_VERSION/fpm/conf.d/20-exif.ini /etc/php/$PHP_VERSION/fpm/conf.d/20-readline.ini /etc/php/$PHP_VERSION/fpm/conf.d/20-shmop.ini /etc/php/$PHP_VERSION/fpm/conf.d/20-sysv*.ini /etc/php/$PHP_VERSION/fpm/conf.d/20-wddx.ini /etc/php/$PHP_VERSION/fpm/conf.d/20-igbinary.ini

### Add httpd && clean upstream config
ADD conf/apache2/ /etc/apache2/

### Add supervisor
RUN apt-get install supervisor -y
COPY conf/supervisor/ /etc/supervisor/
ADD run.sh /

EXPOSE 8080
EXPOSE 9001

ENTRYPOINT ["/run.sh"]
