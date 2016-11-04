# PhalconServer
Bash file for help to setup Ubuntu (Debian) server with PHP7, PostgreSQL or MySQL (MariaDB), Redis &amp; Phalcon PHP, Composer 

# Use
* `git clone https://github.com/ZhukMax/PhalconServer.git`
* `sudo chmod +x PhalconServer/phserver.sh`
* `sudo ./PhalconServer/phserver.sh`
* *answer the questions*

Also you can use keys with script:
* --default (*Install with defaut settings: Mysql, without Redis, with phpMyAdmin*)
* --help *or* -h
* --postgresql *or* -p
* --mysql *or* -m
* --with-redis *or* -r
* --without-pma (don't install phpMyAdmin)
* --without-db (don't install DataBase)

Example: `sudo ./PhalconServer/phserver.sh --mysql --with-redis`
