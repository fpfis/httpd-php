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
	"

apk add --no-cache --virtual .build-deps $makedepends $PHPIZE_DEPS

docker-php-source extract

pecl install igbinary

docker-php-ext-enable igbinary



docker-php-ext-install $modules



