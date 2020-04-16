#!/bin/bash
#read -p "Informe parte do nome do programa " PROG
PROG=`cat prog.txt`
sleep 1
while  true ; do
CHECK=`ps -eaf|grep $PROG |grep -v "grep"|wc -l`
CHECK1=`ps -eaf|grep $PROG`
echo $CHECK1 > ver.log
PROG1=`cat ver.log| awk '{print $9,$10}'`
#teste=`awk -F $CHECK1 ":" '{print substr ($7,2,42)}'`
#read -p  "Verifica valor variavel $CHECK" nada
#read -p "$CHECK"
if [ ${CHECK} -eq 1 ] ; then
	clear
	echo "Processado $PROG1 "
#	echo $PROG1
	HORA=`date | cut -c12-19`
	echo "Hora $HORA  "
	sleep 240
#	a=1
#	b=1
#	s=`expr $A + $B +1 `
#	echo $s
		else	
	#	clear
	#	read -p " Processado $PROG, pressione enter  " nada
		echo "OK" > prog.txt
		exit 0
	#	read -p "Deseja sair ou reprocessar (1 reprocessa) (2 sair)" REP
case $REP in 
1) ./verificagl.sh $1;;
2) exit 100
esac
fi
done
