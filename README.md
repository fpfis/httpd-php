# httpd-php/no-php
[![build status](https://drone.fpfis.eu/api/badges/fpfis/httpd-php/status.svg?branch=release/no-php)](https://drone.fpfis.eu/fpfis/httpd-php) [![last commit](https://img.shields.io/github/last-commit/fpfis/httpd-php/release/no-php.svg)](https://github.com/fpfis/httpd-php/tree/release/no-php) [![image size](https://img.shields.io/microbadger/image-size/fpfis/httpd-php/no-php.svg)](https://cloud.docker.com/u/fpfis/repository/docker/fpfis/httpd-php/tags) [![layer](https://img.shields.io/microbadger/layers/fpfis/httpd-php/no-php.svg)](https://cloud.docker.com/u/fpfis/repository/docker/fpfis/httpd-php/tags)

## Description
* Apache 2.4
* Supervisord

## Variables
### Apache
| Variable              | Description                                                 |  Default
|-----------------------|-------------------------------------------------------------|---------------------
|`TIMEOUT`              |Timeout (seconds)                                            |`120`
|`DOCUMENT_ROOT`        |Document Root                                                |`/var/www/html`
|`PORT`                 |Listen Port                                                  |`8080`
|`APACHE_EXTRA_CONF_DIR`|Extra configuration directory                                |empty
|`APACHE_ACCESS_LOG`    |Access log path (need to be file output/ piped with cronolog)|`/var/log/access`
|`APACHE_ERRORS_LOG`    |Error log path                                               |`/var/log/apache.err`
|`ALLOWINDEXES`         |Allow directory index                                        |`-Indexes`
|`ALLOWOVERRIDE`        |Allow Overide value                                          |`None`
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
