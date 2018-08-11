#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "Script must be ran as root, try again with sudo"
	exit 1
fi

if [ $# -eq 0 ]; then
	echo "Must have arg of image location"
	exit 1
fi

diskutil list
read -p 'enter disk: ' diskNum
read -p "Confirm: disk is $diskNum and image is $1 (y/n): " conf

if [ "$conf" == "y" ]; then
	echo "unmounting  $diskNum..."
	diskutil unmountDisk $diskNum &&
	sudo dd if=$1 | pv -s 2G | dd of=$diskNum bs=1m
	
	echo "Executed Sucessfully!"
	exit
else
	echo "Something went wrong...quitting"
	exit 1
fi
