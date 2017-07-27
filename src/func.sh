# Bash functions library for PhalconServer
#
# Work only like additional library for bash scripts
# Use: func=./src/func.sh ; source "$func"
#
# Author: ZhukMax, <zhukmax@ya.ru>
# https://github.com/ZhukMax/PhalconServer
# Apache License v.2
#

function composerInstall() {
	homeDir
	curl -sS https://getcomposer.org/installer | php
	mv composer.phar /usr/local/bin/composer
}

function getHostMakers() {
	git clone https://github.com/ZhukMax/phost.git
	sudo chmod +x ./phost/phost.sh
	
	git clone https://github.com/ZhukMax/mhost.git
	sudo chmod +x ./mhost/mhost.sh
	
	git clone https://github.com/ZhukMax/yiihost.git
	sudo chmod +x ./yiihost/yiihost.sh
}

function mysqlInstall() {
	apt-get install mariadb-server php7.1-mysql -y

	mysqladmin -u root password ROOTPASS

	if [[ "$1" != "none" ]] ; then
		# PhpMyAdmin
		apt-get install phpmyadmin -y
		ln -s /usr/share/phpmyadmin /var/www/html/pma
		phpenmod mcrypt

		# Default host
		cat $BASEDIR/src/default > /etc/nginx/sites-available/default
	fi
}

function nodejsInstall() {
	homeDir
	curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
	sudo apt-get install nodejs -y
}

function phalconInstall() {
	homeDir
	curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | sudo bash
	apt-get install php7.1-phalcon

	git clone git://github.com/phalcon/phalcon-devtools.git
	cd phalcon-devtools/
	. ./phalcon.sh
	ln -s ~/phalcon-devtools/phalcon.php /usr/bin/phalcon
	chmod ugo+x /usr/bin/phalcon
}

function redisInstall() {
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
	
	apt-get install redis-server
}

function yarnInstall() {
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	
	sudo apt-get update && sudo apt-get install yarn
}
