#!/bin/bash

echo "MySQL[1] or PostgreSQL[2]"
echo "(default 1):"
read DBVERS

if [[ $DBVERS = 2 ]]
then

else
  echo "Password for MySQL root:"
  read -s ROOTPASS
fi

echo "Are you need Redis? [y/N]"
read REDIS

add-apt-repository ppa:nginx/stable
apt-get update
apt-get upgrade -y
apt-get install mc ssh curl libpcre3-dev gcc make sendmail -y
apt-get install nginx -y
apt-get install php7.0-dev php7.0-fpm php7.0-gd php7.0-json php7.0-mbstring php7.0-curl -y

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

if [[ $DBVERS = 2 ]]
then
  apt-get install postgresql php7.0-pgsql -y
else
  apt-get install mariadb-server php7.0-mysql -y

  mysqladmin -u root password ROOTPASS
  
  apt-get install phpmyadmin -y
  ln -s /usr/share/phpmyadmin /var/www/html/pma
  phpenmod mcrypt
  echo "
  server {
    listen 80 default_server;
    root /var/www/html;
    index index.html index.php index.nginx-debian.html;
    
    sever_name _;
    location / {
      try_files \$uri \$uri/ =404;
    }
    location ~ \.php$ {
      include snippets/fastcgi-php.conf;
      fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
    }
  }
  " > /etc/nginx/sites-available/default
fi

curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | sudo bash
apt-get install php7.0-phalcon

git clone git://github.com/phalcon/phalcon-devtools.git
cd phalcon-devtools/
. ./phalcon.sh
ln -s ~/phalcon-devtools/phalcon.php /usr/bin/phalcon
chmod ugo+x /usr/bin/phalcon

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
  touch /etc/php/7.0/mods-available/redis.ini && echo "extension=redis.so" > /etc/php/7.0/mods-available/redis.ini
  ln -s /etc/php/7.0/mods-available/redis.ini /etc/php/7.0/fpm/conf.d/redis.ini
  ln -s /etc/php/7.0/mods-available/redis.ini /etc/php/7.0/cli/conf.d/redis.ini
fi

service php7.0-fpm restart
echo "php7.0-fpm restart"
service nginx restart
echo "nginx restart"
