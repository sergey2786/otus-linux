#### Домашнее задание Настраиваем центральный сервер для сбора логов.

##### В качестве сборщика лог файлов будем использовать стек elk.
   
   Для демонстрации работы имеем две виртуальные машины elk и web.

##### На первой машине установлен сам стек:

     - Elasticsearch - сбор и анализ логов.
     - Logstash - сбор логов.
     - Kibana - визуализация.

   Конфигурация:

  - для приема логов с клиента используем Logstash.
       Содержание файла конфигурации input.conf:
        
        input {
  		      beats {
    		port => 5044  # Порт с которого принимаем логи 
  		    	}
	    	}

	    output {         #Отправка логов в elasticsearch для аналеза 
  		      elasticsearch {
    		hosts => ["http://localhost:9200"]     
    		index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
  	    	}
    	  }
       
##### На второй машине установлен nginx и клиент filebeat для elk:
      
   Файлы конфигурации filebeat содержат:

      
     Блок подключения к Logstash:
		output.logstash:
  		hosts: ["192.168.50.10:5044"]
     
   Правила для отправки логов будем брать с папки inputs.d:

         - type: log
  		    name: nginx_access
  		    paths:
                 - /var/log/nginx/access.log
            scan_frequency: 10s

         - type: log
            name: nginx_error
            paths:
                - /var/log/nginx/error.log
            scan_frequency: 5s
    
   Audit.log будем отправлять подключив готовый модуль filebeat:  
           
           filebeat modules enable auditd
   Для проверки работы filebeat можно воспользоваться командой:

           filebeat -e -c filebeat.yml
           После запуска выведет лог работы filebeat. Вывод вод команды представлен в файле filebeat.txt.

   Скориншоты панели Kibana: 
    
<div align="center">
    <hr><img src="../kibana.png" width="800px"</img><hr/>
    <hr><img src="../auditd.png" width="800px"</img><hr/>
    <hr><img src="../nginx_kibana.png" width="800px"</img><hr/>
    <hr><img src="../syslog_kibana.png" width="800px"</img><hr/>
</div>





