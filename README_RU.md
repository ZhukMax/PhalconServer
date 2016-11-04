# PhalconServer

Исполняемый файл (скрипт) для Убунту, с помощью которого можно быстро развернуть среду для Phalcon проектов.
Устанавливает PHP7, PostgreSQL или MySQL, Редис при желании, Композер, а так же сам фреймворк.

# Использование
* `git clone https://github.com/ZhukMax/PhalconServer.git`
* `sudo chmod +x PhalconServer/phserver.sh`
* `sudo ./PhalconServer/phserver.sh`
* *ответьте на вопросы скрипта*

Так же можно использовать ключи:
* --default (*Уставока по умолчанию: Mysql, без Redis, с установкой phpMyAdmin*)
* --help *or* -h (Вывод подсказки в консоль)
* --postgresql *или* -p (Установить Постгрес БД)
* --mysql *или* -m (Установить MySQL БД)
* --with-redis *или* -r (Установка Редис БД)
* --without-pma (без phpMyAdmin)
* --without-db (без Баз Данных)

Пример: `sudo ./PhalconServer/phserver.sh --mysql --with-redis`
