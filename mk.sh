#!/bin/bash
if [ -z $1 ]
then 
	echo "partition must be specified"
	exit 1
else
	cp="crypt_part"
	echo "luks format"
	cryptsetup -y luksFormat $1
	echo "luks open"
    cryptsetup luksOpen $1 $cp
    echo "mkfs"
    mkfs.ext3 /dev/mapper/$cp 
    echo "e2label $1"
    e2label /dev/mapper/$cp persistence
    echo "mkdir $cp"
    mkdir /tmp/$cp
    echo "mount $cp"
    mount /dev/mapper/$cp /tmp/$cp
    echo "/ union" > /tmp/$cp/persistence.conf
    umount /tmp/$cp
    echo "cryptsetup luksClose $cp"
    cryptsetup luksClose $cp
fi
