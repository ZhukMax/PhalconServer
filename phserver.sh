#!/bin/bash

echo "Enter username for git:"
read USERNAME

echo "Enter email for git:"
read EMAIL

echo "MySQL[1] or PostgreSQL[2]"
echo "(default 2):"
read DBVERS

add-apt-repository ppa:nginx/stable
apt update
apt upgrade -y
apt install mc ssh -y
apt install nginx -y
apt install php7.0-dev libpcre3-dev gcc make php7.0-fpm php7.0-gd php7.0-json php7.0-mbstring -y

if [[ DBVERS = 1 ]]
then
  apt install php7.0-mysql -y
else
  apt install postgresql php7.0-pgsql -y
fi

git config --global user.name "$USERNAME"
git config --global user.email $EMAIL

git clone --depth=1 git://github.com/phalcon/cphalcon.git
cd cphalcon/build
sudo ./install
echo "extension=phalcon.so" > /etc/php/7.0/fpm/conf.d/30-phalcon.ini

apt install g++ -y
mkdir -p /tmp/redis
cd /tmp/redis
wget http://download.redis.io/releases/redis-stable.tar.gz
tar xzf redis-stable.tar.gz
cd redis-stable
make
sudo make install clean
useradd -s /bin/false -d /var/lib/redis -M redis
mkdir /var/run/redis/ -p && sudo chown redis:redis /var/run/redis

service php7.0-fpm restart
service nginx restart
