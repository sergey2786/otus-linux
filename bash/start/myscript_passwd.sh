#!/bin/bash
user=sergey
if grep $user /etc/passwd
then
	echo "The user $user Exists"
fi
