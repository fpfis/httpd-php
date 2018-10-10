FROM ubuntu as httpd-php

ENV DEBIAN_FRONTEND=noninteractive
ARG php_version="5.6"
ARG php_modules="soap bz2 calendar exif mysql opcache zip xsl intl mcrypt yaml mbstring ldap sockets iconv gd redis memcached"
ARG run_deps="apache2 supervisor"

ENV php_version=${php_version} \
    FPM_MAX_CHILDREN=5 \
    FPM_MIN_CHILDREN=2 \
    DAEMON_USER=www-data \
    DOCUMENT_ROOT=/var/www/html

ADD scripts /scripts
RUN /scripts/install-base.sh
ADD supervisor.conf /etc/supervisor/conf.d/services.conf
ADD apache2_conf /etc/apache2
ADD php_conf /etc/php/${php_version}/mods-available
ADD phpfpm_conf /etc/php/${php_version}/fpm/pool.d
RUN phpenmod 90-common 95-prod
RUN phpenmod -s cli 95-cli
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
RUN /scripts/install-dev.sh
RUN phpdismod 95-prod
RUN phpenmod 95-dev