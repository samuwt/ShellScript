#!/bin/bash

clear
printf "\n\033[42;1;38mRepositorio Debian 8.7 Sala B-03 [10.107.132.20]\033[0;0m\n\n"
ifconfig |grep "10.107" > /dev/null 2> /dev/null
if [ $? != 0 ]; then 
    printf "\033[31mNenhuma interface configurada na rede do Senai\033[0;0m\n\n"
else 
    path=$(showmount -e 10.107.132.20 |grep 87 |cut -d* -f 1)
    mkdir /mnt/pkg > /dev/null 2> /dev/null
    DATA=$(date +%d-%m-%Y_%H:%M:%S)
    cp /etc/apt/sources.list /etc/apt/sources.list_$DATA
    mount -t nfs 10.107.132.20:$path /mnt/pkg/ > /dev/null 2> /dev/null
    seq 3 |xargs -I@ echo deb file:/mnt/pkg/blu@ jessie main contrib > /etc/apt/sources.list
    apt-get update && printf "\n\033[44;1;38mFinalizado\033[0;0m\n\n"
fi
