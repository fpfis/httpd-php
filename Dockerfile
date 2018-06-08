FROM php:5-fpm-alpine

ENV DOCUMENT_ROOT /var/www/html

ENV PORT 8080

ENV APACHE_EXTRA_CONF ""

ENV APACHE_EXTRA_CONF_DIR ""

# Install PHP Modules
RUN curl https://raw.githubusercontent.com/fpfis/httpd-php/release/5.6/install-ext-modules.sh | /bin/sh

RUN ln -s /usr/lib/etc/ /etc/php

### Add httpd
RUN apk add --no-cache apache2 apache2-utils apache2-proxy 

ADD apache2_conf/ /etc/apache2/

RUN ln -s /usr/lib/apache2/ /etc/apache2/modules

RUN rm /etc/apache2/conf.d/mpm.conf

### Add monit
RUN apk add --no-cache monit

ADD monitrc /etc/monitrc

RUN chmod 700 /etc/monitrc 

ADD run.sh /

EXPOSE 8080
EXPOSE 2812

ENTRYPOINT ["/run.sh"]

