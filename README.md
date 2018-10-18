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

`php_version` Version of php to build
`php_modules` List of PHP extensions to install ( see PPA content )
`apache2_modules` List of Apache modules to enable after install
`USER_ID` User ID to use for Apache and PHP
`GROUP_ID` Group ID to use for Apache and PHP

## Runtime docker configuration

`APACHE_ACCESS_LOG=/proc/self/fd/1` Location of apache's access log
`APACHE_ERROR_LOG=/proc/self/fd/2` Location of apache's error log
`DAEMON_GROUP=www-data` Usernameto run the daemons with
`DAEMON_USER=www-data` Username to run the daemons with
`DOCUMENT_ROOT=/var/www/html` Document root
`FPM_MAX_CHILDREN=5` Max number of PHP processes
`FPM_MIN_CHILDREN=2` Min number of PHP processes 
`HTTP_PORT=8080` Port to listen on
`PHP_MAX_EXECUTION_TIME=30` PHP max execution time
`PHP_MAX_INPUT_TIME=30` PHP max input time
`PHP_MEMORY_LIMIT=512M` PHP memory limit