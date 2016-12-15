#!/bin/bash

# PhalconServer
#
# Bash file for help to setup Ubuntu (Debian) server with
# PHP 7.0, PostgreSQL or MySQL (MariaDB), Redis,
# Phalcon PHP, Composer
#
# Author: ZhukMax, <zhukmax@ya.ru>
# https://github.com/ZhukMax/PhalconServer
# License: Apache-2.0
#

# Import lib
import1=./src/lib.sh ; source "$import1"
if [ $? -ne 0 ] ; then echo "Error: can't import $import1" 1>&2 ; exit 1 ; fi

# Functions
composerInstall() {
	homeDir
	curl -sS https://getcomposer.org/installer | php
	mv composer.phar /usr/local/bin/composer
}

nodejsInstall() {
	curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
	sudo apt-get install -y nodejs
}

phalconInstall() {
	homeDir
	curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | sudo bash
	apt-get install php7.0-phalcon

	git clone git://github.com/phalcon/phalcon-devtools.git
	cd phalcon-devtools/
	. ./phalcon.sh
	ln -s ~/phalcon-devtools/phalcon.php /usr/bin/phalcon
	chmod ugo+x /usr/bin/phalcon
}

redisInstall() {
	homeDir
	wget http://download.redis.io/redis-stable.tar.gz
	tar xvzf redis-stable.tar.gz
	cd redis-stable
	make
	sudo mkdir /etc/redis
	sudo mkdir /var/redis
	sudo cp utils/redis_init_script /etc/init.d/redis_6379
	sudo cp redis.conf /etc/redis/6379.conf
	sudo mkdir /var/redis/6379
	sudo update-rc.d redis_6379 defaults
	sudo /etc/init.d/redis_6379 start

	cd /tmp
	wget https://github.com/phpredis/phpredis/archive/php7.zip -O phpredis.zip
	unzip -o /tmp/phpredis.zip && mv /tmp/phpredis-* /tmp/phpredis && cd /tmp/phpredis && phpize && ./configure && make && sudo make install
	touch /etc/php/7.0/mods-available/redis.ini && echo "extension=redis.so" > /etc/php/7.0/mods-available/redis.ini
	ln -s /etc/php/7.0/mods-available/redis.ini /etc/php/7.0/fpm/conf.d/redis.ini
	ln -s /etc/php/7.0/mods-available/redis.ini /etc/php/7.0/cli/conf.d/redis.ini
}

# Keys for script
while [ 1 ] ; do
   if [ "$1" = "--with-redis" ] ; then
      REDIS=y
   elif [ "$1" = "-r" ] ; then
      REDIS=y
   elif [ "$1" = "--memcached" ] ; then
      MEMCACHED=y
   elif [ "$1" = "--postgresql" ] ; then
      DBVERS=2
   elif [ "$1" = "-p" ] ; then
      DBVERS=2
   elif [ "$1" = "--mysql" ] ; then
      DBVERS=1
   elif [ "$1" = "-m" ] ; then
      DBVERS=1
   elif [ "$1" = "--without-db" ] ; then
      DBVERS=none
   elif [ "$1" = "--without-pma" ] ; then
      PMA=none
   elif [ "$1" = "--default" ] ; then
      DBVERS=1
      REDIS=n
      MEMCACHED=n
      PMA=y
   elif [ "$1" = "--help" ] ; then
      echoHelp "README.md"
   elif [ "$1" = "-h" ] ; then
      echoHelp "README.md"
   elif [ -z "$1" ] ; then
      break
   else
      echo "Error: unknown key" 1>&2
      exit 1
   fi
   shift
done

# If key with database type is empty
if [ -z "$DBVERS" ] ; then
	echo "MySQL[1] or PostgreSQL[2]"
	echo "(default 1):"
	read DBVERS
fi

# If MySQL then ask pass for root
if [[ "$DBVERS" = 1 ]] ; then
	read -s -p "Password for MySQL root: " ROOTPASS
fi

if [ -z "$REDIS" ] ; then
	read -n 1 -p "Are you need Redis? (y/[N]): " REDIS
fi

# Update system & install server's soft
add-apt-repository ppa:nginx/stable
apt-get update
apt-get upgrade -y
apt-get install mc ssh curl libpcre3-dev gcc make sendmail -y
apt-get install nginx -y
apt-get install php7.0-dev php7.0-fpm php7.0-gd php7.0-json php7.0-mbstring php7.0-curl -y

# Data Structures for PHP 7
# https://github.com/php-ds/extension
pecl install ds
echo "extension=ds.so" > /etc/php/7.0/fpm/conf.d/20-ds.ini

# Install NodeJS & NPM
nodejsInstall

# Install Composer
composerInstall

if [[ "$DBVERS" = 2 ]] ; then
	# Install Postgres
	apt-get install postgresql php7.0-pgsql -y
elif [[ "$DBVERS" = 1 ]] ; then
	# Install Mysql
	apt-get install mariadb-server php7.0-mysql -y

	mysqladmin -u root password ROOTPASS

	if [[ "$PMA" != none ]] ; then
		# PhpMyAdmin
		apt-get install phpmyadmin -y
		ln -s /usr/share/phpmyadmin /var/www/html/pma
		phpenmod mcrypt

		# Default host
		cat src/default > /etc/nginx/sites-available/default
	fi
fi

# Phalcon PHP & Phalcon Devtools
phalconInstall

# Install Memcached
if [[ "$MEMCACHED" = y ]] ; then
  apt-get install php7.0-memcached memcached -y
fi

# Install Redis
if [[ "$DBVERS" != none ]] && [[ "$REDIS" = y ]] ; then
	redisInstall
fi

# Restart nginx & php
restart
