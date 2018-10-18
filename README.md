# httpd-php

This is the base repository used to build the various PHP images used in FPFIS's
environments.

They are based on the latest Ubuntu LTS with the PHP packages from [Ondrej's PPA](https://launchpad.net/~ondrej/+archive/ubuntu/php).

## Contribute

PR goes to the develop branch.

Merging to the develop branch will release the image for testing.
Merging the develop branch to master will release the image for production.
Tagging the master branch will release a new php version in testing and production.

## Build

```bash
docker build --build-arg php_version=5.6 --target httpd-php -t fpfis/httpd-php:5.6 .
```

## Build targets

The [Dockerfile](Dockerfile) is a multistage file containing multiple targets to build :

### httpd-php

Base image with prod settings.

### httpd-php-full

From the base image, adds OCI and Java runtime.

### httpd-php-dev

From the full image, adds developer tools and settings.

## Build arguments
| arg              | Description                                    | Default  
|------------------|------------------------------------------------|----------
|`php_version`     | Version of php to build                        | `5.6`
|`php_modules`     | List of PHP extensions to install              | `curl soap bz2 calendar exif mysql opcache zip xsl intl mcrypt yaml mbstring ldap sockets iconv gd redis memcached tidy`
|`oci8_version`    | Version of oci8 library to install (full)      | `2.0.12`
|`apache2_modules` | List of Apache modules to enable after install | `proxy_fcgi setenvif rewrite`
|`USER_ID`         | User ID to use for Apache and PHP              | `1000`
|`GROUP_ID`        | Group ID to use for Apache and PHP             | `1000`

## Runtime docker configuration

| env                        | Description                        |  Default          |
|----------------------------|------------------------------------|-------------------|
|`APACHE_ACCESS_LOG`         | Location of apache's access log    | `/proc/self/fd/1` |
|`APACHE_ERROR_LOG`          | Location of apache's error log     | `/proc/self/fd/2` |
|`DAEMON_GROUP`              | Group name to run the daemons with | `www-data`        |
|`DAEMON_USER`               | Username to run the daemons with   | `www-data`        |
|`DOCUMENT_ROOT`             | Document root                      | `/var/www/html`   |
|`FPM_MAX_CHILDREN`          | Max number of PHP processes        | `5`               |
|`FPM_MIN_CHILDREN`          | Min number of PHP processes        | `2`               |
|`HTTP_PORT`                 | Port to listen on                  | `8080`            |
|`PHP_MAX_EXECUTION_TIME`    | PHP max execution time             | `30`              |
|`PHP_MAX_INPUT_TIME`        | PHP max input time                 | `30`              |
|`PHP_MEMORY_LIMIT`          | PHP memory limit                   | `512M`            |