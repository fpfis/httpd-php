FROM php:7.2-fpm-alpine

ENV DOCUMENT_ROOT /var/www/html
ENV PORT 8080
ENV APACHE_EXTRA_CONF ""
ENV APACHE_EXTRA_CONF_DIR ""
ENV APACHE_ERROR_LOG /dev/fd/2
ENV APACHE_ACCESS_LOG /dev/fd/1
ENV FPM_MIN_CHILDREN 3
ENV FPM_MAX_CHILDREN 5
ENV PHP_ERROR_LOG /dev/fd/2
ENV DAEMON_USER "www-data"
ENV DAEMON_GROUP "www-data"

### Add ssmtp
RUN apk add --no-cache ssmtp

# Install PHP Modules
ADD install-ext-modules.sh /install-ext-modules.sh
RUN /install-ext-modules.sh && \
    ln -s /usr/local/etc/ /etc/php
ADD phpfpm_conf/www.conf /etc/php/php-fpm.d/
ADD php_conf/ /usr/local/etc/php/conf.d/

### Add httpd
RUN apk add --no-cache apache2 apache2-utils apache2-proxy 
ADD apache2_conf/ /etc/apache2/
RUN ln -s /usr/lib/apache2/ /etc/apache2/modules

### Clean upstream config
RUN rm /etc/apache2/conf.d/mpm.conf && \
    rm /usr/local/etc/php-fpm.d/zz-docker.conf

### Fix iconv
RUN apk add gnu-libiconv --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

### Add monit
RUN apk add --no-cache monit
ADD monitrc /etc/monitrc
RUN chmod 700 /etc/monitrc
ADD run.sh /

EXPOSE 8080
EXPOSE 2812

ENTRYPOINT ["/run.sh"]
