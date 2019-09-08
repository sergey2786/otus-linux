#!/bin/bash
user="sergey"
val1=text
val2="another text"
if [ $user=$USER ]
then 
	echo "The user $user is the current logged is user"
fi

if [ $val1 \> "$val2" ]
then
	echo "$val1 is greater than $val2"
else 
	echo "$val1 is less then $val2"
fi
