#! /bin/bash

clear
echo "Informe o numero da loja, formado de dois digitos 00 :"
read LOJA
echo "Informe a data do arquivo:"
read DATA
echo "Data informada e maior que um dia atras? (Sim ou Nao)"
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
        cd /home2/makro/st_rcv/str_000$LOJA/old/
        cp $ARQ.$dia  
        fi
else

                if [ $QTD -eq 1 ] ; then
                echo "Informe o nome do arquivo:"
                read ARQ                                
                cd /home2/makro/st_rcv/str_000$LOJA
                tail -2 $ARQ$dia
                else                                            #Se quantidade de arquivos for maior que então executa os comandos abaixo
                        for i in $( seq $QTD ) ; do
                        echo "Informe o nome do $i° arquivo"
                        read ARQ
                        cd /home2/makro/st_rcv/str_000$LOJA
                        tail -2 $ARQ$dia
                        done
                fi
fi
