#!/bin/bash

echo "MySQL[1] or PostgreSQL[2]"
echo "(default 1):"
read DBVERS

echo "Are you need Redis? [y/N]"
read REDIS

add-apt-repository ppa:nginx/stable
apt update
apt upgrade -y
apt install mc ssh curl libpcre3-dev gcc make -y
apt install nginx -y
apt install php7.0-dev php7.0-fpm php7.0-gd php7.0-json php7.0-mbstring -y

if [[ $DBVERS = 2 ]]
then
  apt install postgresql php7.0-pgsql -y
else
  apt install mariadb-server php7.0-mysql -y
fi

curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | sudo bash
apt install php7.0-phalcon

if [[ $REDIS = 'y' ]]
then
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
  touch /etc/php/mods-available/redis.ini && echo "extension=redis.so" > /etc/php/mods-available/redis.ini
  ln -s /etc/php/mods-available/redis.ini /etc/php/7.0/fpm/conf.d/redis.ini
  ln -s /etc/php/mods-available/redis.ini /etc/php/7.0/cli/conf.d/redis.ini
fi

service php7.0-fpm restart
echo "php7.0-fpm restart"
service nginx restart
echo "nginx restart"
