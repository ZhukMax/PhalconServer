# PhalconServer
Bash file for help to setup Ubuntu (Debian) server with PHP7, PostgreSQL or MySQL (MariaDB), Redis &amp; Phalcon PHP, Composer 

# Use
* `git clone https://github.com/ZhukMax/PhalconServer.git`
* `sudo chmod +x PhalconServer/phserver.sh`
* `sudo ./PhalconServer/phserver.sh`
* *answer the questions*

Also you can use keys with script:
* --postgresql *or* -p
* --mysql *or* -m
* --with-redis *or* -r

Example: `sudo ./PhalconServer/phserver.sh --mysql --with-redis`

---------------------------------------------------------------------------

Исполняемый файл (скрипт) для Убунту, с помощью которого можно быстро развернуть среду для Phalcon проектов.
Устанавливает PHP7, PostgreSQL или MySQL, Редис при желании, а так же сам фреймворк.

Для использования выполните в консоли три команды, написанные выше и ответьте на вопросы скрипта.
