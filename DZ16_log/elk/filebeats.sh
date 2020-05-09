#!/bin/bash
# Install Filebeat

# Set provision folder
FOLDER="/vagrant"

echo "[$(DATE)] [Info] [Filebeat] Installing Filebeat..."
cp -R $FOLDER/filebeat/* /etc/filebeat/ &> /dev/null
sudo su
yum update -y && yum install epel-release -y 
cd /usr/src/ && curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.6.2-x86_64.rpm && rpm -vi filebeat-7.6.2-x86_64.rpm
yum install vim nginx -y
 


