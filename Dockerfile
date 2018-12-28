FROM ubuntu:18.04

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

### Add ssmtp, bash, git
#RUN apk add --no-cache ssmtp bash git && sed -ri 's@^mailhub=mail$@mailhub=127.0.0.1@' /etc/ssmtp/ssmtp.conf

### Install PHP Modules
RUN apt-get install -y php7.2 php7.2-cli php7.2-fpm php7.2-soap php7.2-bz2 php7.2-opcache php7.2-zip php7.2-xsl php7.2-intl php7.2-mbstring php7.2-ldap php7.2-mysql php7.2-gd  

### Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

### Install php-fpm
ADD phpfpm_conf/www.conf /etc/php/php-fpm.d/
ADD php_conf/ /usr/local/etc/php/conf.d/

### Add httpd && clean upstream config
RUN apk add --no-cache apache2 apache2-utils apache2-proxy && ln -s /usr/lib/apache2/ /etc/apache2/modules && rm /etc/apache2/conf.d/mpm.conf /usr/local/etc/php-fpm.d/zz-docker.conf /etc/apache2/conf.d/proxy.conf
ADD apache2_conf/ /etc/apache2/

### Fix iconv
RUN apk add gnu-libiconv --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

### Add supervisord
COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/bin/supervisord
RUN mkdir /etc/supervisord
COPY supervisord_conf/ /etc/supervisord/
ADD run.sh /

# Fixing timezone
ADD localtime /etc/localtime

EXPOSE 8080
EXPOSE 9001

ENTRYPOINT ["/run.sh"]
