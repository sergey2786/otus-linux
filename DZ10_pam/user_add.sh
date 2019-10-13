#!/bin/bash 
sudo useradd day &&  sudo useradd night && sudo useradd friday
echo "Otus2019"|sudo passwd --stdin day && echo "Otus2019" | sudo passwd --stdin night  && echo "Otus2019" | sudo passwd --stdin friday
sudo groupadd admin && sudo gpasswd -M friday,night,day admin #Создаем группу и включаем туда наших пользователей 
sudo sudo setenforce 0 #Выключаем SELinux (на время сесси)
echo -e "day        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/day #Даем sudo пользователю day (Без проверки пароля)
# Добавлем строку с путем скрипту проверки гуппы юзеров 
sed -i "2i auth  required  pam_exec.so /usr/local/bin/test_login.sh"  /etc/pam.d/sshd # Добавлем путь к скрипту. Скрипт должен быть исполняемым 
cp ~/test_login.sh /usr/local/bin/ #Копируем скрипт проверки группы admin