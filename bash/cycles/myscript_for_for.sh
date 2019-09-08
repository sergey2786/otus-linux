#!/bin/bash
for (( a = 1; a <= 3; a++ ))
do
	echo "Staer $a:"
	for (( b = 1; b <= 3; b++ ))
	do
		echo " I loop: $b"
	done
done
