FROM php:5-fpm-stretch

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

### Add ssmtp & bash
#RUN apk add --no-cache ssmtp bash

# Install PHP Modules
RUN apt-get update &&\
	apt-get -y install $run_deps &&\
	apt-get -y install $dev_deps &&\
	docker-php-source extract &&\
	docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ &&\
	docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ &&\
	docker-php-ext-install -j$(nproc) $php_modules &&\
    pecl install igbinary &&\
    docker-php-ext-enable igbinary &&\
    echo '' | pecl install memcached-2.2.0 &&\
    docker-php-ext-enable memcached &&\
    cd /tmp &&\
	pecl bundle redis &&\
	cd redis &&\
	phpize &&\
	./configure --enable-redis-igbinary --enable-redis-lzf && make -j && make install &&\
	cd / &&\
	rm -rf /tmp/* &&\
	docker-php-source delete &&\
	docker-php-ext-enable redis &&\
	apt-get -y autoremove --purge $dev_deps &&\
	apt-get -y clean

RUN ln -s /usr/local/etc/ /etc/php

ADD phpfpm_conf/www.conf /etc/php/php-fpm.d/
ADD php_conf/ /usr/local/etc/php/conf.d/

ADD phpfpm_conf/www.conf /etc/php/php-fpm.d/

### Add httpd
RUN apt update &&\
	apt -y install apache2 &&\
	apt clean


ADD apache2_conf/ /etc/apache2/

### Clean upstream config
#RUN rm /etc/apache2/conf.d/mpm.conf && \
#    rm /usr/local/etc/php-fpm.d/zz-docker.conf

### Fix iconv
#RUN apk add gnu-libiconv --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
#ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

### Add monit
RUN apt update &&\
	apt -y install monit &&\
	apt clean

ADD monitrc /etc/monitrc

RUN chmod 600 /etc/monitrc 

ADD run.sh /

EXPOSE 8080
EXPOSE 2812

ENTRYPOINT ["/run.sh"]
