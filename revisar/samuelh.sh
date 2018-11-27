#!/bin/bash
clear

echo "#######################################################################"
echo "########## Digite o arquivo ou diretório que você quer acessar#########"
echo "#######################################################################"

printf ":"
read ENDER
[ -d "$ENDER" ] && echo "==: É um DIRETÓRIO" && exit
[ -f "$ENDER" ] && echo "==: É um ARQUIVO" && exit
echo
printf "O CAMINHO QUE FOI DIGITADO NÃO EXISTE\n"
echo
