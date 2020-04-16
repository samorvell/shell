#! /bin/bash
#Escreva um algoritmo para ler um valor (do teclado) e escrever (na tela) o seu antecessor.
clear
read -p "Informe qualquer numero:" NUM
SUB=`expr $NUM - 1`
echo
echo "Numero informado $NUM, numero anterior $SUB"
echo
