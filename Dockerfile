FROM ubuntu as httpd-php

ARG php_version="5.6"

ARG php_modules="soap bz2 calendar exif mysql opcache zip xsl intl mcrypt mbstring ldap sockets iconv gd"

ARG run_deps="apache2 supervisor"
ADD scripts /scripts
RUN /scripts/install-base.sh


