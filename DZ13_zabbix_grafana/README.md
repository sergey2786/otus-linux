##### Мониторинг и алертинг
     #### Разворачивал все в контейнерах docker
     zbbix мониторит lxc контейнеры ubuntu и centos7
     Доступ к web итерфейсам 
     [zabbix] http://164.68.119.130
     [prometheus - grafana] http://164.68.119.130:3000
     #### Логин admin пароль Otus2019

##### Вот весь список контейнеров которые понадобились; 
	  	CONTAINER ID        IMAGE                                  COMMAND                  CREATED             STATUS                   PORTS                                                                              NAMES
      	
		8b5b8e0468f6        prom/prometheus:v2.13.1                "/bin/prometheus --c…"   3 minutes ago       Up 2 minutes             9090/tcp                                                                           prometheus
		3b29dcf3bab1        prom/node-exporter:v0.18.1             "/bin/node_exporter …"   3 minutes ago       Up 2 minutes             9100/tcp                                                                           nodeexporter
		b0a9c77eef39        prom/pushgateway:v1.0.0                "/bin/pushgateway"       3 minutes ago       Up 2 minutes             9091/tcp                                                                           pushgateway
		70de86e8ba67        prom/alertmanager:v0.19.0              "/bin/alertmanager -…"   3 minutes ago       Up 2 minutes             9093/tcp                                                                           alertmanager
		c08743fb1dba        grafana/grafana:6.3.6                  "/setup.sh"              3 minutes ago       Up 2 minutes             3000/tcp                                                                           grafana
		2ca56cdfad8f        stefanprodan/caddy                     "/sbin/tini -- caddy…"   3 minutes ago       Up 2 minutes             0.0.0.0:3000->3000/tcp, 0.0.0.0:9090-9091->9090-9091/tcp, 0.0.0.0:9093->9093/tcp   caddy
		390f80b8ecb1        zabbix/zabbix-web-nginx-pgsql:latest   "docker-entrypoint.sh"   2 hours ago         Up 2 hours               80/tcp, 0.0.0.0:443->443/tcp                                                       zabbix-web-nginx-pgsql
		fe6200f13562        zabbix/zabbix-server-pgsql:latest      "/sbin/tini -- /usr/…"   2 hours ago         Up 2 hours               0.0.0.0:10051->10051/tcp                                                           zabbix-server-pgsql
		a733db747a54        zabbix/zabbix-snmptraps:latest         "/usr/bin/supervisor…"   2 hours ago         Up 2 hours               0.0.0.0:162->162/udp                                                               zabbix-snmptraps
		e19e2a9b60b2        postgres:latest                        "docker-entrypoint.s…"   2 hours ago         Up 2 hours               5432/tcp                                                                           postgres-server

##### Скриншоты zabbix.png и grafana.png
##### Zabbix ставил по официальной документации https://www.zabbix.com/documentation/4.0/ru/manual/installation/containers
##### prometheus - grafana ставил по этой инструкции https://github.com/stefanprodan/dockprom
##### Lxc уже были на хостинге (ставил раньше)