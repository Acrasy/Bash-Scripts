#!/bin/bash

CURRENT=$1;
NEXT="";
PASSWD="";

while true;do
	NEXT=$( unzip -l -e $CURRENT | grep -e [0-9]\.zip | cut -d " " -f 10 );
	PASSWD=$(unzip -l -e $CURRENT | grep -e [0-9]\.zip | cut -d " " -f 10 | cut -d "." -f 1);
	unzip -P $PASSWD $CURRENT;
	CURRENT=$NEXT;

	echo "current $CURRENT";
	echo "next $NEXT";
	echo "passwd $PASSWD";
done;
