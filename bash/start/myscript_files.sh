#!/bin/bash
mydir=/home/sergey
if [ -d $mydir ]
then
	echo "The $mydir directory exists"
	cd $mydir
	ls
else
	echo "The $mydir directory does not exist"
fi
