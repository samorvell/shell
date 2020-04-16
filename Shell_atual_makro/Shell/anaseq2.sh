#! /bin/bash
echo "Informe o numero da loja."
read LOJA
echo "Informe a data do moviento do arquivo no modelo aaaammdd:"
read DATA
echo "Informe a quantidade de arquivos:"
read QTARQ
dia=`julian $DATA`
case $QTARQ in 
	1) echo "Informe o nome do arquivo:"
	read ARQ
	cd /home2/makro/st_rcv/str_000$LOJA
	tail -2 $ARQ$dia
	;;
	2) echo "Informe o primeiro arquivo:"
	read ARQ1
	   echo "Informe o segundo arquivo:"
	read ARQ2
	cd /home2/makro/st_rcv/str_000$LOJA
	tail -2 $ARQ1$dia
	
	tail -2 $ARQ2$dia
	;;
	*) echo "Quantidade invalida"
	;;
esac 

=============================================================================================
#! /bin/bash

echo "Informe o numero da loja:"
read LOJA
echo "Informe a data do arquivo:"
read DATA
echo -e "Informe a quantidade de arquivos a ser analisado:"
read QTD
dia=`julian $DATA`
if [ $QTD -eq 1 ] ; then
        echo "Informe o nome do arquivo:"
        read ARQ
        cd /home2/makro/st_rcv/str_000$LOJA
        tail -2 $ARQ$dia
else
                for i in $( seq $QTD ) ; do
                echo "Informe o nome do $i� arquivo"
                read ARQ
                cd /home2/makro/st_rcv/str_000$LOJA
                tail -2 $ARQ$dia
                done
fi
======================================================================================

#! /bin/bash

clear
echo "Informe o numero da loja, formado de dois digitos 00 :"
read LOJA
echo "Informe a data do arquivo:"
read DATA
echo "Data informada � maior que um dia atras? (Sim ou N�o)"
read TIME
echo -e "Informe a quantidade de arquivos a serem analisados:"
read QTD
dia=`julian $DATA` #Variavel para armazenar o dia juliano
echo "Dia juliano da data informada:$dia"
echo

test -z $TIME = sim
if [ $? -eq 0 ] ; then
	if [ $QTD -eq 1 ] ; then
        echo "Informe o nome do arquivo:"
        read ARQ                            
	cd /home2/makro/st_rcv/str_000$LOJA/old
        tail -2 $ARQ$dia
        fi
else    

		if [ $QTD -eq 1 ] ; then
        	echo "Informe o nome do arquivo:"
        	read ARQ                                #Se quantidade de arquivo for igual a 1 executar comandos abaixo
        	cd /home2/makro/st_rcv/str_000$LOJA
        	tail -2 $ARQ$dia
		else                                            #Se quantidade de arquivos for maior que ent�o executa os comandos abaixo
                	for i in $( seq $QTD ) ; do
                	echo "Informe o nome do $i� arquivo"
                	read ARQ
                	cd /home2/makro/st_rcv/str_000$LOJA
                	tail -2 $ARQ$dia
                	done
		fi
fi		
