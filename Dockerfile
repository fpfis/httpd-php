## Base PHP image :

FROM ubuntu as httpd-php

# Build arguments
ENV DEBIAN_FRONTEND=noninteractive
ARG php_version="5.6"
ARG php_modules="sqlite curl soap bz2 calendar exif mysql opcache zip xsl intl mcrypt yaml mbstring ldap sockets iconv gd redis memcached tidy"
ARG apache2_modules="proxy_fcgi setenvif rewrite"
ARG USER_ID=1000
ARG GROUP_ID=1000

# Default configuration and environment
ENV php_version=${php_version} \
    FPM_MAX_CHILDREN=5 \
    FPM_MIN_CHILDREN=2 \
    DAEMON_USER=www-data \
    DAEMON_GROUP=www-data \
    HTTP_PORT=8080 \
    APACHE_ERROR_LOG=/proc/self/fd/2 \
    APACHE_ACCESS_LOG=/proc/self/fd/1 \
    PHP_MAX_EXECUTION_TIME=30 \
    PHP_MAX_INPUT_TIME=30 \
    PHP_MEMORY_LIMIT=512M \
    SITE_PATH=/ \
    SMTP_PORT=25 \
    SMTP_FROM=www-data@localhost \
    DOCUMENT_ROOT=/var/www/html \
    APACHE_EXTRA_CONF="" \
    APACHE_EXTRA_CONF_DIR=""

# Add our setup scripts and run the base one
ADD scripts/run.sh scripts/install-base.sh /scripts/
RUN /scripts/install-base.sh

# Add our specific configuration
ADD supervisor_conf /etc/supervisor/conf.d
ADD apache2_conf /etc/apache2
ADD php_conf /etc/php/${php_version}/mods-available
ADD phpfpm_conf /etc/php/${php_version}/fpm/pool.d

# Enable our specific configuration
RUN phpenmod 90-common 95-prod && \
    phpenmod -s cli 95-cli && \
    a2enmod ${apache2_modules} && \
    a2enconf php${php_version}-fpm prod
ENTRYPOINT ["/scripts/run.sh"]

## Full PHP images
FROM httpd-php as httpd-php-full
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_CACHE_DIR=/cache/composer
ADD scripts/install-full.sh /scripts/
RUN /scripts/install-full.sh

## Based on the full image ( adds ci tools )
FROM httpd-php-full as httpd-php-ci
ARG ci_packages="gnupg wget curl nano unzip rsync make"
ENV PATH=${PATH}:/root/.composer/vendor/bin
ENV PHP_MEMORY_LIMIT=2G
ADD scripts/install-ci.sh /scripts/
ADD scripts/mail-wrapper.sh /scripts/
RUN /scripts/install-dev.sh && \
    a2disconf prod && \
    a2enconf dev

## Based on the ci image ( adds developement tools )
FROM httpd-php-ci as httpd-php-dev
ARG dev_packages="php${php_version}-xdebug"
ADD scripts/install-dev.sh /scripts/
RUN /scripts/install-dev.sh && \
    phpdismod 95-prod && \
    phpenmod 95-dev

## OCI run image
FROM httpd-php-full as httpd-php-oci
ARG oci8_version="2.0.12"
ENV oci8_version=${oci8_version}
ADD scripts/install-oci.sh /scripts/
RUN /scripts/install-oci.sh

#OCI Dev image
FROM httpd-php-dev as httpd-php-oci-dev
ARG oci8_version="2.0.12"
ENV oci8_version=${oci8_version}
ADD scripts/install-oci.sh /scripts/
RUN /scripts/install-oci.sh

