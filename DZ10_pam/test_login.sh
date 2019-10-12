#!/bin/bash
Day=`date +%u`

if [[ `grep $PAM_USER  /etc/group | grep 'admin'` ]]; then 
 if [[ '67' == *"$Day"* ]]; then
    exit 0
   else
    exit 1
   fi
   else
    exit 1
 fi
