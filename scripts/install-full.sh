#!bin/bash
set -e
set -x
apt-get update

# Fix java installation
mkdir -p /usr/share/man/man1
apt-get install --no-install-recommends  -y openjdk-8-jre-headless curl unzip

# OCI8 deps :
curl https://repo.ne-dev.eu/deb/instantclient-basic-linux.x64-12.2.0.1.0.zip > /tmp/instantclient-basic-linux.zip 
unzip /tmp/instantclient-basic-linux.zip -d /usr/local/ 
curl https://repo.ne-dev.eu/deb/instantclient-sdk-linux.x64-12.2.0.1.0.zip > /tmp/instantclient-sdk-linux.zip 
unzip /tmp/instantclient-sdk-linux.zip -d /usr/local/
ln -s /usr/local/instantclient_12_2/libclntsh.so.12.1 /usr/local/instantclient_12_2/libclntsh.so
echo /usr/local/instantclient_12_2 > /etc/ld.so.conf.d/oracle-instantclient.conf && ldconfig

# OCI8 build :
docker-php-source extract
docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/instantclient_12_2
docker-php-ext-install -j$(nproc) oci8
docker-php-source delete

# Clean :

apt-get autoremove curl unzip --purge
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*