FROM ubuntu:18.04

ENV PHP_VERSION 7.2
ENV DOCUMENT_ROOT /var/www/html
ENV PORT 8080
ENV APACHE_EXTRA_CONF ""
ENV APACHE_EXTRA_CONF_DIR ""
ENV APACHE_ERROR_LOG /dev/fd/2
ENV APACHE_ACCESS_LOG /dev/fd/1
ENV FPM_START_SERVERS 20
ENV FPM_MIN_CHILDREN 10
ENV FPM_MAX_CHILDREN 30
ENV FPM_MAX_REQUESTS 500
ENV PHP_ERROR_LOG /dev/fd/2
ENV PHP_DISPLAY_ERRORS Off
ENV SUPERVISORD_CONF_DIR /etc/supervisord/
ENV DAEMON_USER "www-data"
ENV DAEMON_GROUP "www-data"
ENV DEBIAN_FRONTEND=noninteractive

### Add ssmtp, bash, git
RUN apt-get install ssmtp git curl && sed -ri 's@^mailhub=mail$@mailhub=127.0.0.1@' /etc/ssmtp/ssmtp.conf

### Configure timezone
RUN apt-get update && apt-get install -y tzdata && ln -fs /usr/share/zoneinfo/Europe/Brussels /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

### Install Apache / PHP/FPM (including modules)
RUN apt-get install apache2 libapache2-mod-fcgid php${PHP_VERSION} php${PHP_VERSION}-common php${PHP_VERSION}-cli php${PHP_VERSION}-fpm php${PHP_VERSION}-soap php${PHP_VERSION}-bz2 php${PHP_VERSION}-opcache php${PHP_VERSION}-zip php${PHP_VERSION}-xsl php${PHP_VERSION}-intl php${PHP_VERSION}-mbstring php${PHP_VERSION}-ldap php${PHP_VERSION}-mysql php${PHP_VERSION}-gd php${PHP_VERSION}-memcached php${PHP_VERSION}-redis php${PHP_VERSION}-curl php${PHP_VERSION}-sqlite php${PHP_VERSION}-bcmath -y

### Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

### Configure php/php-fpm
ADD phpfpm_conf/ /etc/php/${PHP_VERSION}/fpm/
ADD php_conf/ /etc/php/${PHP_VERSION}/conf.d/

### Cleanup php/apache configuration
RUN rm -rf /etc/apache2/sites-* /etc/apache2/conf-* /etc/apache2/ports.conf /etc/apache2/mods-* /etc/php/$PHP_VERSION/fpm/conf.d/20-exif.ini /etc/php/$PHP_VERSION/fpm/conf.d/20-msgpack.ini /etc/php/$PHP_VERSION/fpm/conf.d/20-readline.ini /etc/php/$PHP_VERSION/fpm/conf.d/20-shmop.ini /etc/php/$PHP_VERSION/fpm/conf.d/20-sysv*.ini /etc/php/$PHP_VERSION/fpm/conf.d/20-wddx.ini

### Add httpd && clean upstream config
ADD apache2_conf/ /etc/apache2/

### Add supervisord
RUN apt-get install supervisor -y
COPY supervisord_conf/ /etc/supervisord/
ADD run.sh /

EXPOSE 8080
EXPOSE 9001

ENTRYPOINT ["/run.sh"]
