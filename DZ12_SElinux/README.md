### SELinux 

#### Запустить nginx на нестандартном порту 3-мя разными способами:

1. Переключатели setsebool; 
	
	  Запускаем nginx (перед этим сменив его порт в файле /etc/nginx/nginx.conf) получаем ошибку.
	  Решение:
	  Смотрим в audit.log (grep "AVC" /var/log/audit/audit.log). В логе видим что, так как порт не стандартный то на запуск нет разрешения. Из лога берем вот это значение msg=audit(1587925794.610:1940).
	  Дальше с помощью утилиты audit2why (grep 1587925794.610:1940 /var/log/audit/audit.log | audit2why) смотрим какой переключатель отключить (setsebool -P nis_enabled 1) 

2. Добавление нестандартного порта в имеющийся тип;  
	   
	   Решение представлено на стенде который можно с клонировать из репозитория (Стенда расположен в папке SElinux_nginx). 
	   В стенде используется парамет "public_network" который позволяет бридж интерфесом основной машины. При запуске нужно указать сетевой интерфес с которым будет мост. 
	   Так же в этой папке представлен файл с выводом и самим командами которые помогли в решении этой задачи.

3. Формирование и установка модуля SELinux.

	   Описание:

	     1. Меняем порт с 80 на 8089 (sed -i 's/80/8089/' /etc/nginx/nginx.conf)
	     2. Пробуем запустить nginx. Не стартует.
	     3. Ищем ошибку в audit.log (grep "AVC" /var/log/audit/audit.log либо так audit2why < /var/log/audit/audit.log)
	     4. Формируем модуль (audit2allow -M nginx --debug < /var/log/audit/audit.log)
	     5. Загружаем модуль (semodule -i nginx.pp)
	     6. Запускаем nginx и проверяем (http://ip:8089) 

 
### Вторая часть задания.

#### Обеспечить работоспособность приложения при включенном selinux.
	  - Развернуть приложенный стенд
	  https://github.com/mbfx/otus-linux-adm/blob/master/selinux_dns_problems/
	  - Выяснить причину неработоспособности механизма обновления зоны (см. README);
	  - Предложить решение (или решения) для данной проблемы;
	  - Выбрать одно из решений для реализации, предварительно обосновав выбор;
	  - Реализовать выбранное решение и продемонстрировать его работоспособность.

#### Для решения мы будем смотреть логи audit (/var/log/audit/audit.log) и messages (/var/log/messages).	
#### Решение 
     
      1. Запускаем стенд заходим на client. Пытаемся обновить dns c client получаем "update failed: SERVFAIL". 
      2. Подключаемся к ns01 проверяем работает ли демон named (systemctl status named).
      	 Видим что демон запущен но у него нет доступа к открытию файла:
   <code>[root@ns01 vagrant]# systemctl status named
● named.service - Berkeley Internet Name Domain (DNS)
   Loaded: loaded (/usr/lib/systemd/system/named.service; enabled; vendor preset: disabled)
   Active: active (running) since Sat 2020-05-02 09:10:34 UTC; 13min ago
  Process: 31310 ExecStop=/bin/sh -c /usr/sbin/rndc stop > /dev/null 2>&1 || /bin/kill -TERM $MAINPID (code=exited, status=0/SUCCESS)
  Process: 31323 ExecStart=/usr/sbin/named -u named -c ${NAMEDCONF} $OPTIONS (code=exited, status=0/SUCCESS)
  Process: 31321 ExecStartPre=/bin/bash -c if [ ! "$DISABLE_ZONE_CHECKING" == "yes" ]; then /usr/sbin/named-checkconf -z "$NAMEDCONF"; else echo "Checking of zone files is disabled"; fi (code=exited, status=0/SUCCESS)
 Main PID: 31325 (named)
   CGroup: /system.slice/named.service
           └─31325 /usr/sbin/named -u named -c /etc/named.conf

May 02 09:18:53 ns01 named[31325]: client @0x7fd1c003c3e0 192.168.50.15#27621/key zonetransfer.key: view view1: updating zone 'ddns.lab/IN': addin....168.50.15
May 02 09:18:53 ns01 named[31325]: /etc/named/dynamic/named.ddns.lab.view1.jnl: create: permission denied
May 02 09:18:53 ns01 named[31325]: client @0x7fd1c003c3e0 192.168.50.15#27621/key zonetransfer.key: view view1: updating zone 'ddns.lab/IN': error...cted error
May 02 09:19:51 ns01 named[31325]: client @0x7fd1c003c3e0 192.168.50.15#27621/key zonetransfer.key: view view1: signer "zonetransfer.key" approved
May 02 09:19:51 ns01 named[31325]: client @0x7fd1c003c3e0 192.168.50.15#27621/key zonetransfer.key: view view1: updating zone 'ddns.lab/IN': addin....168.50.15
May 02 09:19:51 ns01 named[31325]: /etc/named/dynamic/named.ddns.lab.view1.jnl: open: permission denied
May 02 09:19:51 ns01 named[31325]: client @0x7fd1c003c3e0 192.168.50.15#27621/key zonetransfer.key: view view1: updating zone 'ddns.lab/IN': error...cted error
May 02 09:22:52 ns01 named[31325]: client @0x7fd1c003c3e0 192.168.50.15#27621/key zonetransfer.key: view view1: signer "zonetransfer.key" approved
May 02 09:22:52 ns01 named[31325]: client @0x7fd1c003c3e0 192.168.50.15#27621/key zonetransfer.key: view view1: updating zone 'ddns.lab/IN': addin....168.50.15
May 02 09:22:52 ns01 named[31325]: client @0x7fd1c003c3e0 192.168.50.15#27621/key zonetransfer.key: view view1: updating zone 'ddns.lab/IN': error...d: no more
Hint: Some lines were ellipsized, use -l to show in full.</code>

