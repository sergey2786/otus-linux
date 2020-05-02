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
#### Решение: 
     
      1. Запускаем стенд заходим на client. Пытаемся обновить dns c client получаем "update failed: SERVFAIL". 
      2. Подключаемся к ns01 проверяем работает ли демон named (systemctl status named).
      	 Видим что демон запущен но у него нет доступа к файлу:
      	 /etc/named/dynamic/named.ddns.lab.view1.jnl: create: permission denied
	  3. Парсим audit.log при помощи утилиты audit2why (audit2why < /var/log/audit/audit.log):
	  	 
			Was caused by:
					Мissing type enforcement (TE) allow rule.

						You can use audit2allow to generate a loadable module to allow this access.

		

			Was caused by:
					 Missing type enforcement (TE) allow rule.

						You can use audit2allow to generate a loadable module to allow this access.

          После формируем модуль audit2allow -M name_selinux --debug < /var/log/audit/audit.log и устовливаем его semodule -i name_selinux.pp. Проверяем снова обновление зоны подучает так же "update failed: SERVFAIL"
       
       4. Дальше будем  смотреть в лог messages на ns01 (Для удобства используем grep "SELinux is preventing" /var/log/messages). После каждой попытки обновления зоны ошибка отображается в messages так же комодны для решения данное проблемы (ausearch -c 'isc-worker0000' --raw | audit2allow -M my-iscworker0000#012 # semodule -i my-iscworker0000.pp). При помощи этих команд можно сформировать модули с соответствующими разрешения и установить. Запрашиваем обновление dns до тех пор пока, в messages не перестанут появляться ошибки. 

       5. Дальше проверем статус systemctl status named:
       
       ● named.service - Berkeley Internet Name Domain (DNS)
       Loaded: loaded (/usr/lib/systemd/system/named.service; enabled; vendor preset: disabled)
       Active: active (running) since Sat 2020-05-02 09:37:39 UTC; 1s ago
      Process: 21433 ExecStop=/bin/sh -c /usr/sbin/rndc stop > /dev/null 2>&1 || /bin/kill -TERM $MAINPID (code=exited, status=0/SUCCESS)
      Process: 21446 ExecStart=/usr/sbin/named -u named -c ${NAMEDCONF} $OPTIONS (code=exited, status=0/S UCCESS)
      Process: 21444 ExecStartPre=/bin/bash -c if [ ! "$DISABLE_ZONE_CHECKING" == "yes" ]; then /usr/sbin/named-checkconf -z "$NAMEDCONF"; else echo "Checking of zone files is disabled"; fi (code=exited, status=0/SUCCESS)
      Main PID: 21448 (named)
      CGroup: /system.slice/named.service
              └─21448 /usr/sbin/named -u named -c /etc/named.conf

      May 02 09:37:39 ns01 named[21448]: automatic empty zone: view default: 126.100.IN-ADDR.ARPA
      May 02 09:37:39 ns01 named[21448]: automatic empty zone: view default: 127.100.IN-ADDR.ARPA
      May 02 09:37:39 ns01 named[21448]: automatic empty zone: view default: 127.IN-ADDR.ARPA 
      May 02 09:37:39 ns01 named[21448]: automatic empty zone: view default: 254.169.IN-ADDR.ARPA 
      May 02 09:37:39 ns01 named[21448]: automatic empty zone: view default: 2.0.192.IN-ADDR.ARPA
      May 02 09:37:39 ns01 named[21448]: automatic empty zone: view default: 100.51.198.IN-ADDR.ARPA
      May 02 09:37:39 ns01 named[21448]: automatic empty zone: view default: 113.0.203.IN-ADDR.ARPA
      May 02 09:37:39 ns01 named[21448]: zone ddns.lab/IN/view1: journal rollforward failed: no more
      May 02 09:37:39 ns01 named[21448]: zone ddns.lab/IN/view1: not loaded due to errors.

      * Удаляем /etc/named/dynamic/named.ddns.lab.view1.jnl, перезапускаем systemctl restart named. Получаем работающий сервис с обновленными зонами DNS:
      ![dns_named](DNS/named.png)







