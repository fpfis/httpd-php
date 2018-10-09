FROM ubuntu as httpd-php

ENV DEBIAN_FRONTEND=noninteractive
ARG php_version="5.6"
ARG php_modules="soap bz2 calendar exif mysql opcache zip xsl intl mcrypt mbstring ldap sockets iconv gd redis memcached"
ARG run_deps="apache2 supervisor"

ENV php_version=${php_version}

ADD scripts /scripts
RUN /scripts/install-base.sh


FROM httpd-php as httpd-php-full
ARG oci8_version="2.0.12"
ENV oci8_version=${oci8_version}
RUN /scripts/install-full.sh

FROM httpd-php-full as httpd-php-dev
RUN /scripts/install-dev.sh