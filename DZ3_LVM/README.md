
###Готовим сенд###
####Клонируем поект 
####Запска
vagrant up

####Подлючение 
vagrant ssh

####Описание работы: 
####Все команды выполняются под root(sudo su)
####Уменьшение тома /
#####Подготовка
	1. pvcreate /dev/sdb - Создаем том 
	2. vgcreate vg_root /dev/sdb - Добавляем sdb в группу томов vg_root
	3. lvcreate -n lv_root -l +100%FREE /dev/vg_root - Создаем логический том /dev/vg_root
	4. mkfs.xfs /dev/vg_root/lv_root - Форматируем том в xfs
	5. mount /dev/vg_root/lv_root /mnt - Монтируем в mnt
	6. xfsdump -J - /dev/VolGroup00/LogVol00 | xfsrestore -J - /mnt - Переносим данные 
	7. mount --bind /proc /mnt/proc && mount --bind /dev /mnt/dev && mount --bind /sys /mnt/sys && mount --bind /run /mnt/run - Мотируем вреные фаловые системы в /mnt
	8. chroo /mnt - Переходим root 
	9. grub2-mkconfig -o /boot/grub2/grub.cfg - Устанавливаем загрузчик 
	10. mv /boot/initramfs-3.10.0-862.2.3.el7.x86_64.img /boot/initramfs-3.10.0-862.2.3.el7.x86_64.img.bak && dracut /boot/initramfs-$(uname -r).img $(uname -r) - Обновляем initrd
	11. vim /etc/default/grub - Меняем источник загрузки с rd.lvm.lv=VolGroup00/LogVol00 на rd.lvm.lv=vg_root/lv_root
	12. Перезагружаемся.
#####Изменение / и перенос данных с /lv_root обратно в VolGroup00
	 1. lvremove /dev/VolGroup00/LogVol00 - Удалем логический том LogVol00 (Это том который был с боксам)
	 2. lvcreate -n VolGroup00/LogVol00 -L 8G /dev/VolGroup00 - Создаем том 8GB для /
	 3. Повторяем пункты с 6 по 11 (в обратном порядке с lv_root в LogVol00 )которые описаны выше.
#####Выделяем /var
	 1. pvcreate /dev/sdc /dev/sdd - Создаем тома для зеркала var 
	 2. vgcreate vg_var /dev/sdc /dev/sdd - Добавляем sdd в группу томов для vg_var
	 3. lvcreate -L 950M -m1 -n lv_var vg_var - Размечаем vg_var размером 950m 
	 4. mkfs.ext4 /dev/vg_var/lv_var - Форматируем том в exf4
	 5. mount /dev/vg_var/lv_var /mnt - Монтируем раздел в /mnt 
	 6. rsync -avHPSAX /var/ /mnt/ - Переносим данные с var в /mnt
	 7. umount /mnt - Размонтируем /mnt	
	 8. mount /dev/vg_var/lv_var /var - Монтируем lv_var в var 
	 9. echo "`blkid | grep var: | awk '{print $2}'` /var ext4 defaults 0 0" >> /etc/fstab - Добавляем запись в fstab для авто монтирования при загрузке 	
#####Удаление временной Volume Group
	 1. yes | lvremove /dev/vg_root/lv_root && vgremove /dev/vg_root && pvremove /dev/sdb - Удаляем временную vg 
#####Результат подготовки в файлах: lsblk_8g_root и lsblk_mirror_var
#####Выделение раздела /home 
	 1. lvcreate -n LogVol_Home -L 2G /dev/VolGroup00 - Создаем VG размером 2G для home
	 2. mkfs.xfs /dev/VolGroup00/LogVol_Home - Форматируем в xfs.
	 3. mount /dev/VolGroup00/LogVol_Home /mnt/
     4. rsync -avHPSAX /home/ /mnt/ - Перенос данных с /home
     5. rm -rf /home/* && umount /mnt && mount /dev/VolGroup00/LogVol_Home /home/ - Чистим /home, размонтируем mnt, монтируем LogVol_Home в home 
     6. echo "`blkid | grep Home | awk '{print $2}'` /home xfs defaults 0 0" >> /etc/fstab - обновляем fstab
#####Работа с снапшотами
	 1. touch /home/file{1..34} - Заполняем /home
	 2. lvcreate -L 100MB -s -n home_snap /dev/VolGroup00/LogVol_Home - Снимаем снапшот
	 3. rm -f /home/file{11..20} - стираем файлы 
	 4. umount /home && lvconvert --merge /dev/VolGroup00/home_snap && mount /home - Размонтируем /home, восстановим снапшот, монтируем /home 
	 5. Проверяем восстановился или нет ls /home (lsblk)
#####Результат в файле home_snap набор команд так же есть в фаиле history

######Попытки работы с zfs отражены в файле zfs_install_centOS и mirror_zfs. 
	  1. zfs get all pool0/opt - проверка параметром файловой системы 
	  2. zfs get mountpoint pool0/opt - указываем точку монтирования. 