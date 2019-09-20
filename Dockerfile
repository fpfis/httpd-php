FROM httpd:2.4

ENV ENVIRONMENT=prd TIMEOUT=120 DOCUMENT_ROOT="/var/www/html" PORT=8080 APACHE_EXTRA_CONF_DIR="" APACHE_ERROR_LOG="/var/log/apache.err" APACHE_ACCESS_LOG="/var/log/access" ALLOWINDEXES="+Indexes" ALLOWOVERRIDE="none"
ENV SUPERVISOR_LOG_PATH="/var/log/" SUPERVISOR_CONF_DIR="/etc/supervisor/" DAEMON_USER="www-data" DAEMON_GROUP="www-data" SUPERVISORCTL_LISTEN_PORT="9001" SUPERVISORCTL_USER="admin" SUPERVISORCTL_PASS="password" DEBIAN_FRONTEND="noninteractive"

### Configure timezone / adding ssmtp / default dep / Install Apache / PHP/FPM (including modules) / cleanup cache
RUN apt-get update && apt-get install cronolog tzdata supervisor -y && sed -i 's@:www-data:@:EC FPIS DO NOT REPLY:@' /etc/passwd && ln -fs /usr/share/zoneinfo/Europe/Brussels /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata && apt-get clean all; rm -rf /var/lib/apt/lists/* /etc/apache2/mods-enabled/status.conf; > /var/www/html/index.html

### Revamp apache configuration
ADD conf/apache2/ /usr/local/apache2/conf/

### Cleanup php/apache configuration
RUN a2enmod proxy_fcgi rewrite headers; a2disconf other-vhosts-access-log; 

### Adding supervisor configuration
COPY conf/supervisor/ /etc/supervisor/
ADD run.sh /

EXPOSE ${PORT} ${SUPERVISORCTL_LISTEN_PORT}

ENTRYPOINT ["/run.sh"]
