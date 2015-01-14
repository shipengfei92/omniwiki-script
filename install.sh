#!/bin/bash

sed -i 's/archive.ubuntu.com/ftp.sjtu.edu.cn/g'   /etc/apt/sources.list

apt-get update
apt-get install -y mysql-server
service mysql restart

apt-get install -y apache2 php5 phpmyadmin
apt-get install -y wget git
apt-get install -y gcc g++ make
apt-get install -y php-pear php5-dev
apt-get install -y php-apc


dir=$(pwd)

wget http://releases.wikimedia.org/mediawiki/1.24/mediawiki-1.24.1.tar.gz
tar xvzf mediawiki-1.24.1.tar.gz

sed -i  '/DocumentRoot /c     DocumentRoot   '$dir'/mediawiki-1.24.1  '   /etc/apache2/sites-available/000-default.conf

echo "
<Directory $dir/mediawiki-1.24.1/>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>" >> /etc/apache2/apache2.conf

wget http://download.icu-project.org/files/icu4c/52.1/icu4c-52_1-src.tgz
tar xf icu4c-52_1-src.tgz
cd icu/source
mkdir -p /usr/local/icu
./configure --prefix=/usr/local/icu

pecl install intl-3.0.0

sed -i '/\[PHP\]/a extension=intl.so' /etc/php5/apache2/php.ini

service apache2 restart
