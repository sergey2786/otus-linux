### Получения root способ 1 init=/bin/sh.
####  При загрузке на выбранном ядре нажимает e(edit). Находим строку начинающеюся на linux16 добавляем single init=/bin/bash, после загружаемся в систему ctrl-x.
#### Дальше меняем пароль root:
	 1. mount -o remount,rw / - монтируем / в Read-Write
	 2. passwd root - меняем пароль root
	 3. Загружаемся в систему
#### Пример на скриншотах init.png и init_sh.png

### Получения root способ 2 rd.break.
####  При загрузке на выбранном ядре нажимает e(edit). Находим строку начинающеюся на linux16 добавляем rd.break, после загружаемся в систему ctrl-x.
#### Дальше меняем пароль root:
	 1. mount -o remount,rw /sysroot - монтируем /sysroot в Read-Write
	 2. chroot /sysroot - подключаемся к смотированной системе 
	 3. passwd root - меняем пароль root
	 4. touch  /.autorelabel - автоматический переразмечаем файловую систему при следующем запуске. 
	 5. Загружаемся в систему
#### Пример на скриншотах rd.break.png и rd.break1.png

### Получения root способ 3 init=/sysroot/bin/sh.
####  При загрузке на выбранном ядре нажимает e(edit). Находим строку начинающеюся на linux16 меняем монтирование файловой системы с ro на rw, так же добавляем в конце строки init=/sysroot/bin/sh после загружаемся в систему ctrl-x.
#### Дальше меняем пароль root:
	 1. chroot /sysroot - подключаемся к смотированной системе 
	 2. passwd root - меняем пароль root
	 3. touch  /.autorelabel - автоматический переразмечаем файловую систему при следующем запуске.
	 4. загружаемся в систему
#### Пример на скриншотe rw_sysroot 	 