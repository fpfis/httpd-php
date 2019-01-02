# httpd-php/7.2-wt
[![build status](https://drone.fpfis.eu/api/badges/fpfis/httpd-php/status.svg?branch=release/7.2-wt)](https://drone.fpfis.eu/fpfis/httpd-php) [![last commit](https://img.shields.io/github/last-commit/fpfis/httpd-php/release/7.2-wt.svg)](https://github.com/fpfis/httpd-php/tree/release/7.2-wt) [![image size](https://img.shields.io/microbadger/image-size/fpfis/httpd-php/7.2-wt.svg)](https://cloud.docker.com/u/fpfis/repository/docker/fpfis/httpd-php/tags) [![layer](https://img.shields.io/microbadger/layers/fpfis/httpd-php/7.2-wt.svg)](https://cloud.docker.com/u/fpfis/repository/docker/fpfis/httpd-php/tags)

## Description
* Ubuntu 18.04
* Apache + PHP 7.2 + Composer
* Supervisord

## Variables
### Apache
| Variable              | Description                                                 |  Default
|-----------------------|-------------------------------------------------------------|---------------------
|`TIMEOUT`              |Timeout (seconds)                                            |`120`
|`DOCUMENT_ROOT`        |Document Root                                                |`/var/www/html`
|`PORT`                 |Listen Port                                                  |`8080`
|`APACHE_EXTRA_CONF`    |Extra configuration                                          |empty
|`APACHE_EXTRA_CONF_DIR`|Extra configuration directory                                |empty
|`APACHE_ACCESS_LOG`    |Access log path (need to be file output/ piped with cronolog)|`/var/log/access`
|`APACHE_ERRORS_LOG`    |Error log path                                               |`/var/log/apache.err`
### PHP
| Variable           | Description                                                          |  Default
|--------------------|----------------------------------------------------------------------|---------------------
|`PHP_VERSION`       |Version to install                                                    |`7.2`
|`FPM_START_SERVERS` |Number of child processes created on startup                          |`20`
|`FPM_MIN_CHILDREN`  |Minimum number of idle server processes                               |`10`
|`FPM_MAX_CHILDREN`  |Maximum number of child processes to be created                       |`30`
|`FPM_MAX_REQUESTS`  |Number of requests each child process should execute before respawning|`500`
|`PHP_ERROR_LOG`     |Error log path                                                        |`/var/log/php.err`
|`PHP_DISPLAY_ERRORS`|display_errors                                                        |`Off`
|`PHP_DEPENDENCIES`  |Modules to install                                                    |`Available on bottom`
### Supervisor
| Variable                  | Description                     |  Default
|---------------------------|---------------------------------|------------------
|`SUPERVISOR_LOG_PATH`      |log path                         |`/var/log/`
|`SUPERVISOR_CONF_DIR`      |conf path                        |`/etc/supervisor/`
|`DAEMON_USER`              |User that will run Apache and PHP|`www-data`
|`DAEMON_GROUP`             |Daemon group                     |`www-data`
|`SUPERVISORCTL_LISTEN_PORT`|Listen Port                |`9002`
|`SUPERVISORCTL_USER`       |GUI user                         |`admin`
|`SUPERVISORCTL_PASS`       |GUI password                     |`password`

## PHP modules
* common
* cli
* fpm
* soap
* bz2
* opcache
* zip
* xsl
* intl
* imap
* mbstring
* ldap
* mysql
* gd
* memcached
* redis
* curl
* sqlite
* bcmath
