#!/bin/bash
clear

echo "Informe seu nome:"
read NOME

USER=$(echo $USER)

HORA=$(date "+%H")

if [ "$HORA" -le 11 ]
then
	echo "Bom dia $USER !!!"
else
if [ "$HORA" -ge 12 ]
then
	echo "Boa tarde $USER !!"
else
if [ "$HORA" -ge 18 ] && [ "$HORA" -lt 05 ]
then
	echo "Boa noite $USER !"
fi
fi
fi
