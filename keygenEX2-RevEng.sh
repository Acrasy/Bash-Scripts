#!/bin/bash

i="0"
n="0"
k1="0"
k2="0"
k3="0"
seed="0"
printf "hello world...id pls?\n10digits\n";

while [[ ${#num} -ne 10 ]];do
	read num
done

while [[ $num -gt "0" ]];do
	seed=$(($seed+$num%10))
	num=$(($num/10))
done
echo "seed is $seed"


while [[ $(($k1%$seed)) -ne 0 ]] || [[ ! (($k1 -gt "99" &&  $k1 -lt "999")) ]];do
	n=$((RANDOM%=55))
	k1=$(($n*$seed))
done

while [[ $(($k2%$seed)) -ne 0 || $k2 -eq $k1 || ! ($k2 -gt "99" && $k2 -lt "1000") ]];do
	n=$((RANDOM%=55))
	k2=$(($n*$seed))
done

while [[ $(($i%$seed)) -eq 0 ]];do
	i=$(((RANDOM%=899 ) +100))
	k3=$i
done

echo "Your key is $k1-$k2-$k3"
