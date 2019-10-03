### Homework Systemd 
#### Клонируем репозиторий 
#### Запускаем vagrant up
#### Действия:
	 1. Создаем папку files
	 2. Разархивируем туда содержимое архива (tar -xvf files.tar.xz -C files)
	 3. Заходим в files
	 3. запускаем скрипты  copy_httpd.sh и copy_watchlog.sh
	 4. Запускаем systemctl start httpd@first && systemctl start httpd@second
##### Что бы запустить httpd с использование нескольких конфигов в фаиле httpd@.service добавляем -%I
		EnvironmentFile=/etc/sysconfig/httpd-%I

#### Можно проверить 
	 1. tail -f /var/log/messages
	 2. ss -tnulp | grep httpd
#### Установка и запуск Jira Assistant
	 1. Установка ./atlassian-jira-software-8.4.1-x64.bin
	 2. cp jira.service && chmod 664 /lib/systemd/system/jira.service
	 	1. systemctl daemon-reload
	 	2. systemctl enable jira.service
	 	3. systemctl start jira.service
