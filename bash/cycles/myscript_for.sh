#!/bin/bash
for var in first second third fourth fifth
do
	echo The $var item
done

for var1 in first "the second" "the third" "I'll do it"
do
	echo "The is: $var1"
done
