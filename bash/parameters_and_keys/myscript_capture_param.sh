#!/bin/bash

echo "Using the \$* method: $*"
echo "-----------"
echo "Using the \$@ method: $@"

#Проход по переменным в цикле 
count=1
for param in "$*"
do
	echo "\$* Parameter #$count = $param"
	count=$(( $count + 1 ))
done
for param in "$@"
do
	echo "\$@ Parameter #$count = $param "
	count=$(( $count + 1))
done
