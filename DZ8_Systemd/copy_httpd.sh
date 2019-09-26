#!/bin/bash
sudo su -l
cp /usr/lib/systemd/system/httpd.service /usr/lib/systemd/system/httpd@.service
cd /home/vagrant/files/2
cp second.conf /etc/httpd/conf/ && cp first /etc/httpd/conf/
cp httpd-first /etc/sysconfig/ && cp httpd-second /etc/sysconfig/
