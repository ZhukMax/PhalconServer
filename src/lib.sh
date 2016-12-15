# lib

# Go to home directory
homeDir() {
	cd ~
}

# Output help information
# and exit from script
echoHelp() {
	cat $1
	exit 1
}

# Restart web server
restart() {
   service php7.0-fpm restart
   echo "php7.0-fpm restart"
   service nginx restart
   echo "nginx restart"
}