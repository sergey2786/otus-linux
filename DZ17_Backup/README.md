##### Настраиваем бэкапы с помощью BorgBackup
   
   Стенд из двух машин server и backup.
   1. server ip 192.168.50.15
   2. backup ip 192.168.50.10

   На обоих машина уставлен BorgBackup, но на server уставлена тестовая версия, связанно с тем что в при монтирование (borg mount) возникла проблема с правами.
   Исправленна проблема в тестовой версии BorgBackup.

   Сам скрипт borgbackup выглядит так:

     #!/usr/bin/env bash

	BZIP2="$(which bzip2) -9 -c"
	NOW=$(date +"%Y-%m-%d_%H:%M:%S")

	LOG="/var/log/borg/backup.log"
	REPOSITORY=borg@192.168.50.10:MyBackup

	PGDUMP="sudo -upostgres pg_dumpall"
	DB_BACKUP_DIR=/home/vagrang/db_backup

	#Bail if borg is already running, maybe previous run didn't finish
	if pidof -x borg >/dev/null; then
    	echo "Backup already running"
    	exit
	fi

	if [ ! -d "$DB_BACKUP_DIR" ]; then
    	mkdir -p $DB_BACKUP_DIR
	fi

	FILE=$DB_BACKUP_DIR/pg-all-$NOW.bz2
	$PGDUMP | $BZIP2 > $FILE

	# Setting this, so you won't be asked for your repository passphrase:
	#export BORG_PASSPHRASE='thisisnotreallymypassphrase'
	# or this to ask an external program to supply the passphrase:
	#export BORG_PASSCOMMAND='pass show backup'

	# Backup all of /home and /var/www except a few
	# excluded directories
	borg create -v --stats --info                         \
    	$REPOSITORY::'{hostname}-{now:%Y-%m-%d_%H:%M:%S}'    \
    		/etc  
    		/home/vagrant/db_backup 2>> $LOG                                        


	# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
	# archives of THIS machine. The '{hostname}-' prefix is very important to
	# limit prune's operation to this machine's archives and not apply to
	# other machine's archives also.
	borg prune -v --list $REPOSITORY --prefix '{hostname}-' \
    		--keep-daily=1   \
    		--keep-within=30d \
    		--keep-monthly=2
	borg prune -v --list $REPOSITORY --prefix '{hostname}-' \
    		--keep-monthly=-1

Восстановление каталога /etc представлено в файле borg_mount.txt.

Скрипт запускается по cron.

#### Стенд находится в папке BorgBackup.

При работе использовалась официальная документация:
[Borg Documentation](https://borgbackup.readthedocs.io/en/stable/index.html)