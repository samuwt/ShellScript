#!/bin/bash
clear
ESCOLA='SENAI Profº Vicente Amato'
echo 'Digite seu nome:'
read NOME
echo 'Digite sua idade:'
read IDADE
clear
echo "Você estuda na escola: $ESCOLA"
echo
echo "O seu nome é: $NOME"
echo
echo "A sua idade é: $IDADE"
echo
[ $IDADE -le "17" ] && echo "Junior" && exit
[ $IDADE -le "50" ] && echo "Pleno" && exit
echo "Senior"
echo
