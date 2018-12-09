#!/bin/bash

toolsArray=(iperf fio)

#cephNodes=(10.8.0.1 10.8.0.2 10.8.0.3)
cephNodes=(cephnode01 cephnode02 cephnode03)

for node in ${cephNodes[*]}
do
	ssh root@$(node) << EOF
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
					 $(apt install $var &> /dev/null);
					echo "$var installed"
			fi

		echo "starting iperf server"
		iperf -s
		done
EOF

done

for node in ${cephNodes[*]}
do	
	#do tests
	ssh root@$node << EOF
		for num in ${cephNodes}
		do
			if[$(HOSTNAME) != $node]
				 iperf -c $num >> perfOF${node}.txt
			fi
		done

		fio --output fioOf${node}.txt --numjobs=10 --size=10GB --bs=4k --iodepth=1 --rw=randwrite --direct=0 --ioengine=libaio --group_reporting --name=randomwrite
		echo fioOf${node}.txt >> perfOF${node}.txt
		scp ./perfOf${node}.txt root@10.8.0.10:~/perfOf${node}.txt
		rm fioOf${node}.txt
		rm perfOF${node}.txt
		rm randomwrite*
EOF	
	#copy report to summary file after every node
	cat perfOf${node}.txt >> summary.txt
done

#kill iperf servers again
for node in ${cephNodes[*]}
do
	ssh root@$node 'killall iperf;'
done
