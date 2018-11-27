#!/bin/bash

echo "TESTE DE CONECTIVIDADE ESTÁ SENDO FEITO"
ping -c 2 8.8.8.8 > /mnt/teste.txt
ping -c 2 8.8.8.8

#cat /mnt/teste.txt
