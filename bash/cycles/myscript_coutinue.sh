#!/bin/bash
for (( var1 = 1; var1 < 15; var1++ )); do
	if [ $var1 -gt 5 ] && [ $var1 -lt 10 ]; then
		continue
		#statements
	fi
	echo "Iteration number: $var1"
	#statements
done
