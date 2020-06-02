#!/bin/bash

   yum -y update && rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro && yum -y install epel-release && rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
   yum -y install vim knock-server iptables-services
   echo "root:root" | chpasswd 
   sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config 
   sudo bash -c 'echo "net.ipv4.conf.all.forwarding=1" >> /etc/sysctl.conf'; sudo sysctl -p
   systemctl restart sshd && systemctl enable iptables && systemctl start iptables && systemctl enable knockd && service knockd start

# Правила iptables
   iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
   iptables -A INPUT -p tcp --dport 22 -j REJECT 
   service iptables save
