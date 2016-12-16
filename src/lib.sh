# Bash library
#
# Work only like additional library for bash scripts
# Use: lib=./src/lib.sh ; source "$lib"
#
# Author: ZhukMax, <zhukmax@ya.ru>
# https://github.com/ZhukMax
# Apache License v.2
#

# Colors & font styles
BOLD='\033[1m' ; DBOLD='\033[2m' ; NBOLD='\033[22m'
UNDERLINE='\033[4m' ; NUNDERLINE='\033[4m'
INVERSE='\033[7m' ; NINVERSE='\033[7m'
NORMAL='\033[0m'

BLACK='\033[0;30m' ; RED='\033[0;31m' ; GREEN='\033[0;32m'
YELLOW='\033[0;33m' ; BLUE='\033[0;34m' ; MAGENTA='\033[0;35m'
CYAN='\033[0;36m' ; GRAY='\033[0;37m'

# Bold and colors
DEF='\033[0;39m' ; DGRAY='\033[1;30m'
LRED='\033[1;31m' ; LGREEN='\033[1;32m'
LBLUE='\033[1;34m' ; LMAGENTA='\033[1;35m'
LCYAN='\033[1;36m' ; WHITE='\033[1;37m'
LYELLOW='\033[1;33m'

# Background colors
BGBLACK='\033[40m' ; BGRED='\033[41m'
BGGREEN='\033[42m' ; BGBROWN='\033[43m'
BGBLUE='\033[44m' ; BGMAGENTA='\033[45m'
BGCYAN='\033[46m' ; BGGRAY='\033[47m'
BGDEF='\033[49m'

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
restartPhp() {
   service php7.0-fpm restart
   echo "php7.0-fpm restart"
   service nginx restart
   echo "nginx restart"
}

function tests() {
	if [ "$1" = "--install" ] ; then
		while [ 1 ] ; do
			if [ "$1" = "--install" ] ; then
				echo "Test installation of applications:\n"
			elif hash "$1" 2>/dev/null; then
				echo -en "${GREEN}OK${NORMAL}: $1\n"
			elif [ -z "$1" ] ; then
				break
			else
				echo -en "${LRED}Error${NORMAL}: $1\n"
			fi
		done
		tput sgr0
	fi
}