##### Домашнее задание cценарии iptables
1) реализовать knocking port - centralRouter может попасть на ssh inetrRouter через knock скрипт
Решить эту задачу может двум способавми:
    Первый способ пастроить правила iptables. Этот сопособ представлен в статье:
       
    [Настройка Port Knocking](https://otus.ru/nest/post/267/)
        
     В стенде используется утилита knockd. Конфигурация выглядит так:
          
          
          [options]
               UseSyslog
               logfile = /var/log/knockd.log
               interface = eth1
               
          [SSHopen]
               sequence        = 4444,3333,2222
               seq_timeout     = 5
               tcpflags        = syn
               start_command   = iptables -I INPUT 1 -s %IP% -p tcp --dport 22 -j ACCEPT
               cmd_timeout     = 3600
               stop_command    = iptables -D INPUT -s %IP% -p tcp --dport 22 -j ACCEPT
          [SSHclose]
               sequence        = 2222,3333,4444
               seq_timeout     = 5
               tcpflags        = syn
               command         = /sbin/iptables -D INPUT -s %IP% -p tcp --dport ssh -j ACCEPT
      
      Утилита позволяет автоматически добавлять нужные правила в iptables. 
      
      Стук на сервер будет проверить nmap, в папке files есть скрипт (knock.sh), которму нужно передать в качистве аргуметов порты 4444 3333 2222 для открытия и 2222 3333 4444 для закрытия соедения. Так же можно постучатся сомой утилитой (knock -v).
      
      Для закрытия порта 22 используем правило iptables:
        
        iptables -A INPUT -p tcp --dport 22 -j REJECT
         
      Информация оп knock может посмотреть по ссылке:
      
      [Защита сервера при помощи Port Knocking](https://putty.org.ru/articles/port-knocking.html)
      
      Установка knock-server из репозитория nux-dextop:
      
      [Port Knocking Server and Securing SSH connection for CentOS 7](https://netslovers.com/2018/02/28/port-knocking-server-securing-ssh-connection-centos-7/)
      
2) добавить inetRouter2, который виден(маршрутизируется (host-only тип сети для виртуалки)) с хоста или форвардится порт через локалхост

       Cпомощью директивы config.vm.network "forwarded_port" перенапровлем порт 1111 на 8080.
       
3) запустить nginx на centralServer
       Устанавливаем nginx (sudo yum install -y epel-release && yum -y install nginx)

4) пробросить 80й порт на inetRouter2 8080
       Когда мы переходим по адресу 127.0.0.1 порт 1111 то мы попадаем на порт 8080 гостевой машины inetRouter2. Пренапровление трафика осуществляем с помощью правил iptables:
              
        sudo iptables -t nat -A PREROUTING -i eth0 -p tcp -m tcp --dport 8080 -j DNAT --to-destination 192.168.2.2:80
        sudo iptables -t nat -A POSTROUTING --destination 192.168.2.2/32 -j SNAT --to-source 192.168.255.2

##### Работа представлена на стенде можно с клонировать и запустить.
