#### DZ15_docker 
   1. Создайте свой кастомный образ nginx на базе alpine. После запуска nginx должен отдавать кастомную страницу (достаточно изменить дефолтную страницу nginx):
      1.1 Контейнер можно собрать из папки nginx_alpine (docker build -t). 
      1.2 Так же готовый образ можно загрузить так docker push sergey2786/nginx_alpine:tagname. Запустить можно будет docker run -d -p 1234:80 sergey2786/nginx_alpine:tagname. Проверить можно в браузере по адресу localhost:1234
   2. Определите разницу между контейнером и образом
      ..*Образ это один процесс например nginx (docker images).
      ..*Контейнер складывается из образов (docker ps). 
   3. Можно ли в контейнере собрать ядро?
      ..*Судя по docker hub https://hub.docker.com/r/moul/kernel-builder/ видимо можно. Но вот загрузится с него думаю нельзя будет.
   4. Создайте кастомные образы nginx и php, объедините их в docker-compose.
      ..*Заходим в папку где находится docker-compose.yml запускаем:
         
         docker-compose up -d
         curl localhost:8080