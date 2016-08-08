#!/bin/bash

add-apt-repository ppa:nginx/stable
apt update
apt upgrade -y
apt install mc ssh -y
apt install nginx -y
apt install php7.0-dev libpcre3-dev gcc make php7.0-fpm php7.0-gd php7.0-json -y
apt install postgresql php7.0-pgsql -y

echo "Enter username for git:"
read USERNAME

echo "Enter email for git:"
read EMAIL

git config --global user.name "$USERNAME"
git config --global user.email $EMAIL

git clone --depth=1 git://github.com/phalcon/cphalcon.git
cd cphalcon/build
sudo ./install
echo "extension=phalcon.so" > /etc/php/7.0/fpm/conf.d/30-phalcon.ini

service php7.0-fpm restart
service nginx restart
