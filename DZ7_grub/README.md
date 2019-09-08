### Получения root способ 1 init=/bin/sh.
####  При загрузке на выбранном ядре нажимает e(edit). Находим строку начинающеюся на linux16 добавляем single init=/bin/bash, после загружаемся в систему ctrl-x.
#### Дальше меняем пароль root:
	 1. mount -o remount,rw / - монтируем / в Read-Write
	 2. passwd root - меняем пароль root
	 3. Загружаемся в систему
#### Пример на скриншотах init.png и init_sh.png

### Получения root способ 2 rd.break.
####  При загрузке на выбранном ядре нажимает e(edit). Находим строку начинающеюся на linux16 добавляем rd.break, после загружаемся в систему ctrl-x.
##### Дальше меняем пароль root:
	 1. mount -o remount,rw /sysroot - монтируем /sysroot в Read-Write
	 2. chroot /sysroot - подключаемся к смотированной системе 
	 3. passwd root - меняем пароль root
	 4. touch  /.autorelabel - автоматический переразмечаем файловую систему при следующем запуске. 
	 5. Загружаемся в систему
##### Пример на скриншотах rd.break.png и rd.break1.png

### Получения root способ 3 init=/sysroot/bin/sh.
####  При загрузке на выбранном ядре нажимает e(edit). Находим строку начинающеюся на linux16 меняем монтирование файловой системы с ro на rw, так же добавляем в конце строки init=/sysroot/bin/sh после загружаемся в систему ctrl-x.
##### Дальше меняем пароль root:
	 1. chroot /sysroot - подключаемся к смотированной системе 
	 2. passwd root - меняем пароль root
	 3. touch  /.autorelabel - автоматический переразмечаем файловую систему при следующем запуске.
	 4. загружаемся в систему
##### Пример на скриншотe rw_sysroot 	 

##### При использование Способа 1 (init=/bin/sh) мы попадаем в консоль root. При втором способе rd.break мы попадаем в emergency recovery после нам нужно смонтировать root и chroot зайти в него и сменить пароль root.


### Установка системы с LVM и смена VG:
	1. vgs - Смотрим vgname (после установки оно centos)
	2. vgrename centos CentosOtus- меняем имя centos на CentosOtus
	3. В файлах /etc/fstab, /etc/default/grub и /boot/grub2/grub.cfg меняем имя VG на CentosOtus. Также в фаиле /etc/default/grub меняем время ожидания загрузки на 1 секунду (параметр GRUB_TIMEOUT).
##### Вывод команд находится в файле lvm_grub

### Добавление модуля в initrd
    1. mkdir /usr/lib/dracut/modules.d/01test - Создаем папку 01test
    2. создаем два файлы module-setup.sh и test.sh 
    3. mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r) && dracut -f -v - пересобираем initrd
    4. Добавлем параметры загрузки в grub.cfg
##### Результат на скриншоте tux.png

