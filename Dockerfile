FROM php:5-fpm-alpine

# Install PHP Modules

RUN curl https://raw.githubusercontent.com/fpfis/httpd-php/release/5.6/install-ext-modules.sh | /bin/sh

### Add httpd
RUN apk add --no-cache apache2 apache2-utils 

### Add monit
RUN apk add --no-cache monit

### Build PHP... No redis available on the repos :(
#RUN apk add --no-cache php5 php5-mysqli php5-xml php5-gd php5-openssl php5-json php5-curl php5-pdo php5-pdo_mysql php5-opcache php5-mcrypt php5-dom php5-apache2 php5-iconv php5-suhosin; \
#	ln -s /usr/bin/php5 /usr/bin/php

#ADD build-php.sh /tmp

#RUN /bin/sh /tmp/build-php.sh





#COPY httpd-foreground /usr/local/bin/
## Adding supervisor. Based on https://github.com/rawmind0/alpine-monit
#ENV MONIT_VERSION=5.25.1
#ENV MONIT_HOME=/usr/local
#ENV MONIT_URL=https://mmonit.com/monit/dist
#
#RUN apk add --no-cache --virtual .build-deps gcc musl-dev make libressl-dev file zlib-dev \
#    mkdir -p /opt/src; cd /opt/src && \
#    curl -sS \${MONIT_URL}/monit-\${MONIT_VERSION}.tar.gz | gunzip -c - | tar -xf - && \
#    cd /opt/src/monit-\${MONIT_VERSION} && \
#    ./configure  --prefix=\${MONIT_HOME} --without-pam && \
#    make && make install && \
#    mkdir -p \${MONIT_HOME}/etc/conf.d \${MONIT_HOME}/log && \
#    apk del gcc musl-dev make libressl-dev file zlib-dev &&\
#    rm -rf /var/cache/apk/* /opt/src


EXPOSE 80
CMD ["/bin/sh"]
