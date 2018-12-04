#!/bin/bash

toolsArray=(iperf fio)

echo "Look for testing software and install if not available" 

for var in ${toolsArray[*]}
	do
	dpkg-query -s $var &> /dev/null
	if [ $? -eq 0 ]
	   then 
		echo "$var is available"
	   else
		echo -e "\n$var not available"
		echo "installing..."
		exec $(apt install $var &> /dev/null);
		echo "$var installed"
	fi
	done

