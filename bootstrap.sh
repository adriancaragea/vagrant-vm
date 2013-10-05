#!/usr/bin/env bash

apt-get update
apt-get -q -y --force-yes install subversion git-core apache2 memcached exim4 \
php-codesniffer php-doc php5-imagick php5-memcache libapache2-mod-php5 \
php-pear php5-cli php5-common php5-curl php5-dbg php5-dev php5-gd php5-gmp \
php5-imap php5-mcrypt php5-mhash php5-mysql php5-sqlite php5-tidy php5-xmlrpc \
php5-xsl php5-xdebug php-apc php5-memcached vim \
munin-node munin-plugins-extra mon tripwire pwgen

rm -rf /var/www
ln -fs /vagrant /var/www

INSTALLER_LOG=/var/log/non-interactive-installer.log
 
installnoninteractive(){
  sudo bash -c "DEBIAN_FRONTEND=noninteractive aptitude install -q -y $* >> $INSTALLER_LOG"
}
 
installnoninteractive mysql-server

mysql -uroot -e "UPDATE mysql.user SET password=PASSWORD('pass') WHERE user='root'; FLUSH PRIVILEGES;";
echo "MySQL Password set to 'pass'!"

cp /var/www/apache-sites-available/zend.example /etc/apache2/sites-available/zend.example
cp /var/www/apache-sites-available/symfony.example /etc/apache2/sites-available/symofny.example
a2ensite zend.example
a2ensite symfony.example
a2dissite default
a2dissite default-ssl
service apache2 reload