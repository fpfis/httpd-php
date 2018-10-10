FROM ubuntu as httpd-php

ENV DEBIAN_FRONTEND=noninteractive
ARG php_version="5.6"
ARG php_modules="soap bz2 calendar exif mysql opcache zip xsl intl mcrypt yaml mbstring ldap sockets iconv gd redis memcached"

ENV php_version=${php_version} \
    FPM_MAX_CHILDREN=5 \
    FPM_MIN_CHILDREN=2 \
    DAEMON_USER=www-data \
    DAEMON_GROUP=www-data \
    HTTP_PORT=8080 \
    FPM_PORT=9000 \
    APACHE_ERROR_LOG=/dev/stderr \
    APACHE_ACCESS_LOG=/dev/stdout \
    PHP_ERROR_LOG=/dev/stderr \
    DOCUMENT_ROOT=/var/www/html

ADD scripts /scripts
RUN /scripts/install-base.sh
ADD supervisor_conf /etc/supervisor/conf.d
ADD apache2_conf /etc/apache2
ADD php_conf /etc/php/${php_version}/mods-available
ADD phpfpm_conf /etc/php/${php_version}/fpm/pool.d
RUN phpenmod 90-common 95-prod && \
    phpenmod -s cli 95-cli && \
    a2enmod proxy_fcgi && \
    a2enconf php prod
ENTRYPOINT ["/scripts/run.sh"]


FROM httpd-php as httpd-php-full
ARG oci8_version="2.0.12"
ENV oci8_version=${oci8_version}
RUN /scripts/install-full.sh

FROM httpd-php-full as httpd-php-dev
ARG composer_version="1.7.2"
ARG drush_version="8.1.17"
ENV PATH=${PATH}:/root/.composer/vendor/bin
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN /scripts/install-dev.sh && \
    phpdismod 95-prod && \
    phpenmod 95-dev && \
    a2disconf prod