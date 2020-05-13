#!/bin/bash
            
   yum update &> /dev/null
   yum install epel-release -y  &> /dev/null
   yum install vim sshpass postgresql postgresql-server -y  &> /dev/null
   yum --enablerepo=epel-testing install borgbackup -y  &> /dev/null
   printf '\n' | ssh-keygen -N ''  &> /dev/null
   sshpass -p "borg" ssh-copy-id -o StrictHostKeyChecking=no borg@192.168.50.10  &> /dev/null
   borg init -e none borg@192.168.50.10:MyBackup  &> /dev/null
   mkdir /var/log/borg/  &> /dev/null
   echo "* * * * * /bin/bash /home/vagrant/borgbackup.sh >/dev/null 2>&1" | tee -a /var/spool/cron/root  &> /dev/null
   
