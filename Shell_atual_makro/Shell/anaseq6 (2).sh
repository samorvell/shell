#! /bin/bash
clear
echo "Informe o numero da loja:"
read LOJA
echo "Informe a quantidade de arquivos:"
read QTD
echo "Informe a data para analise dos arquivos aaaammdd:"
read DATA
dia=14240 			#Variavel para armazenar o dia juliano
day=`date --date="-1 day" +20%y%m%d`
#echo "Dia juliano da data informada:$dia"
echo

if [ $DATA != $day  ] ; then
	for i in $( seq $QTD ) ; do
	echo "Informe o nome do $i° arquivo"
	read ARQ
	cd /home2/makro/st_rcv/str_000$LOJA/old
	ls -ltr $ARQ$dia*
	echo "Deseja descompactar e analisar arquivos?"
	read RESP
		if [ $RESP != sim  ] ; then
		echo "Ok!"
		else 
		ls -ltr $ARQ$dia.gz
		cp /home2/makro/st_rcv/str_000$LOJA/old/$ARQ$dia.gz /home2/makro/st_rcv/str_00086/arqdescom
		cd /home2/makro/st_rcv/str_00086/arqdescom
		uncompress $ARQ$dia.gz
		tail -2 $ARQ$dia
		fi
	done
else
	 for i in $( seq $QTD ) ; do
         echo "Informe o nome do $i° arquivo"
         read ARQ
         cd /home2/makro/st_rcv/str_000$LOJA/
         ls -ltr $ARQ$dia
         tail -2 $ARQ$dia
         done 

fi
