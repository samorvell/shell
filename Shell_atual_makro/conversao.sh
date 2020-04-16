#! /bin/bash
#Crie um programa que permita fazer a conversao cambial entre Reais e Dolares. Considere como taxa de cambio US$1,0 = R$2,40. Leia um valor em Reais pelo teclado e mostre o correspondente em Dolares.
read -p "Informe o valor em reais R$:" DIN
CON=`expr "scale=1; ($DIN / 2.40)"|bc`
echo "Valor em dolar = $ $CON"
