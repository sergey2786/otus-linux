#!/bin/bash
echo
while [ -n "$1" ]
do
	case "$1" in 
		-a) echo "Found the -a option";;
		-b) echo "Found the -b option";;
		-c) echo "Found the -c option";;
		*) echo "Found the an option";;
	esac
	shift
done

