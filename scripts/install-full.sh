#!bin/bash
set -e
set -x
apt-get update

# Fix java installation
mkdir -p /usr/share/man/man1
apt-get install --no-install-recommends  -y libaio1 openjdk-8-jre-headless curl unzip

# OCI8 deps :
curl https://repo.ne-dev.eu/deb/instantclient-basic-linux.x64-12.2.0.1.0.zip > /tmp/instantclient-basic-linux.zip 
unzip /tmp/instantclient-basic-linux.zip -d /usr/local/ 
curl https://repo.ne-dev.eu/deb/instantclient-sdk-linux.x64-12.2.0.1.0.zip > /tmp/instantclient-sdk-linux.zip 
unzip /tmp/instantclient-sdk-linux.zip -d /usr/local/
ln -s /usr/local/instantclient_12_2/libclntsh.so.12.1 /usr/local/instantclient_12_2/libclntsh.so
echo /usr/local/instantclient_12_2 > /etc/ld.so.conf.d/oracle-instantclient.conf && ldconfig

# OCI8 build :
apt-get install -y  php${php_version}-dev
pecl download oci8-${oci8_version}
tar -xzvf oci8-${oci8_version}.tgz
pushd oci8-${oci8_version}
phpize
./configure --with-oci8=instantclient,/usr/local/instantclient_12_2
make -j$(nproc)
make install
popd
rm -Rf oci8-${oci8_version} oci8-${oci8_version}.tar.gz
echo "extension=oci8.so" > /etc/php/${php_version}/mods-available/oci8.ini
phpenmod oci8

# Clean :
apt-get autoremove -y curl unzip php${php_version}-dev --purge
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*