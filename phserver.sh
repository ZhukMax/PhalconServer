#!/bin/bash

# PhalconServer
#
# Bash file for help to setup Ubuntu (Debian) server with
# PHP7, PostgreSQL or MySQL (MariaDB), Redis,
# Phalcon PHP, Composer, NodeJS
#
# Author: ZhukMax, <zhukmax@ya.ru>
# https://github.com/ZhukMax/PhalconServer
# Apache License v.2
#

BASEDIR=`dirname $0`

# Import bash library
cd $BASEDIR
git clone https://github.com/ZhukMax/shlib.git lib
lib=$BASEDIR/lib/index.sh ; source "$lib"
if [ $? -ne 0 ] ; then echo "Error: can't import $lib" 1>&2 ; exit 1 ; fi

# Functions
func=$BASEDIR/src/func.sh ; source "$func"
if [ $? -ne 0 ] ; then echo "Error: can't import $func" 1>&2 ; exit 1 ; fi

# Keys for script
while [ 1 ] ; do
	if [ "$1" = "--with-redis" ] ; then
		REDIS="y"
	elif [ "$1" = "-r" ] ; then
		REDIS="y"
	elif [ "$1" = "--memcached" ] ; then
		MEMCACHED="y"
	elif [ "$1" = "--postgresql" ] ; then
		DBVERS=2
	elif [ "$1" = "-p" ] ; then
		DBVERS=2
	elif [ "$1" = "--mysql" ] ; then
		DBVERS=1
	elif [ "$1" = "-m" ] ; then
		DBVERS=1
	elif [ "$1" = "--without-db" ] ; then
		DBVERS="none"
		REDIS="n"
	elif [ "$1" = "--without-pma" ] ; then
		PMA="none"
	elif [ "$1" = "--default" ] ; then
		DBVERS=1
		REDIS="n"
		MEMCACHED="n"
		PMA="y"
	elif [ "$1" = "--help" ] ; then
		echoHelp $BASEDIR/docs/help.txt
	elif [ "$1" = "-h" ] ; then
		echoHelp $BASEDIR/docs/help.txt
	elif [ -z "$1" ] ; then
		break
	else
		echo "Error: unknown key" 1>&2
		exit 1
	fi
	shift
done

# Default DataBase is MySQL
if [ -z "$DBVERS" ] ; then
	DBVERS=1
fi

# If MySQL then ask pass for PhpMyAdmin
if [[ "$DBVERS" = 1 ]] ; then
	read -s -p "Password for MySQL root: " ROOTPASS
	echo ""
fi

if [ -z "$REDIS" ] ; then
	read -n 1 -p "Are you need Redis? (y/[N]): " REDIS
	echo ""
fi

# Update system & install server's soft
add-apt-repository ppa:nginx/stable
apt-get update
apt-get upgrade -y
apt-get install mc ssh curl libpcre3-dev gcc make sendmail -y
apt-get install nginx -y
apt-get install php7.0-dev php7.0-fpm php7.0-gd php7.0-json php7.0-mbstring php7.0-curl php7.0-zip -y

# Data Structures for PHP 7
# https://github.com/php-ds/extension
#dsInstall

# Install NodeJS & NPM
nodejsInstall

#Install Yarn
yarnInstall

# Install Composer
composerInstall

if [[ "$DBVERS" = 2 ]] ; then
	# Install Postgres
	apt-get install postgresql php7.0-pgsql -y
elif [[ "$DBVERS" = 1 ]] ; then
	# Install Mysql
	mysqlInstall $PMA
fi

# Phalcon PHP & Phalcon Devtools
phalconInstall

# Install Redis
if [[ "$REDIS" = "y" ]] ; then
	redisInstall
fi

if [[ "$MEMCACHED" = "y" ]] ; then
	apt-get install php7.0-memcached memcached -y
fi

restartPhp

getHostMakers

# Test installation of applications
tests --install nginx php curl mysql redis phalcon composer nodejs ds
