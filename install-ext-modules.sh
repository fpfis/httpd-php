#/bin/sh

set -xue

modules="bz2 calendar exif gd pdo_mysql opcache zip xsl intl mcrypt ldap "


#Dumb list of dev dependencies...
makedepends="
	autoconf
	apache2-dev
	aspell-dev
	bison
	bzip2-dev
	curl-dev
	db-dev
	enchant-dev
	freetds-dev
	freetype-dev
	gdbm-dev
	gettext-dev
	gmp-dev
	icu-dev
	imap-dev
	krb5-dev
	libedit-dev
	libical-dev
	libjpeg-turbo-dev
	libmcrypt-dev
	libpng-dev
	libressl-dev
	libwebp-dev
	libxml2-dev
	libxpm-dev
	libxslt-dev
	libzip-dev
	net-snmp-dev
	openldap-dev
	pcre-dev
	postgresql-dev
	re2c
	recode-dev
	sqlite-dev
	tidyhtml-dev
	unixodbc-dev
	zlib-dev
	libmemcached-dev
	"

apk add --no-cache --virtual .build-deps $makedepends $PHPIZE_DEPS;

docker-php-source extract;

pecl install igbinary;

docker-php-ext-enable igbinary;

echo '' | pecl install memcached-2.2.0;

cd /tmp;

pecl bundle redis;

cd redis;

phpize;

./configure --enable-redis-igbinary --enable-redis-lzf && make -j && make install;

cd /;

rm /tmp/*;

docker-php-source delete;

docker-php-ext-enable redis;

docker-php-ext-install $modules;

apk add --no-cache $( scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' );

apk del .build-deps