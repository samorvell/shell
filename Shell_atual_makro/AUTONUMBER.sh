#! /bin/bash 
#By Samuel Amaro da Silva
#Shell para corrigir erro de sequencia, busca numero da sequncia correta nos arquivos, e executa o update no banco do mbsho#
#V. 1.0
clear
OPT=999
while test $OPT -ne 0
do
AN=./AUTONUMBER.sh
#tput cup 2 27
clear
MN=./MENU.sh
LJ=`uname -n`
   LOJA="$LJ"
RAZAO="MAKRO ATACADISTA S.A"
TOFF=`tput rmso`
TBOLD=`tput bold`
TBLINK=`tput blink`
TRES=`tput smso`
DIA=`date | cut -c9-10`
DIA_SEM=`date | cut -c1-3`
case $DIA_SEM in
 Sun) DIA_SEM="Domingo";; Mon) DIA_SEM="Segunda";; Tue) DIA_SEM="Terca";;
 Wed) DIA_SEM="Quarta";;  Thu) DIA_SEM="Quinta";;  Fri) DIA_SEM="Sexta";;
 Sat) DIA_SEM="Sabado";;    *) DIA_SEM=err;;
esac
MES=`date | cut -c5-7`
case $MES in
 Jan) MES="Janeiro";;Feb) MES="Fevereiro";;Mar) MES="Marco";;Apr) MES="Abril";;
 May) MES="Maio";;Jun) MES="Junho";;Jul) MES="Julho";;Aug) MES="Agosto";;
 Sep) MES="Setembro";;Oct) MES="Outubro";;Nov) MES="Novembro";;
 Dec) MES="Dezembro";;  *) MES=err;;
esac
ANO=`date | cut -c26-29`
HORA=`date | cut -c12-19`
#OPT=999; msg=" "
##########################################
#while  test $OPT -ne 0
#do
tput rev
echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA
tput cup 3 24
echo              "  C O R R I G I  A U T O N U M B E R "
tput sgr0
echo
#read -p "Pressione enter!" nada
echo
read -p "                        1) Para efetuar correcao tabela autonumber 	
                        0) Sair

                        opcao Escolhida --> "  OPT

case $OPT in
1)read -p "		Informe o numero da loja (00) " LJ
read -p "		Informe a quantidade de arquivos a serem reprocessados " QTD
read -p "		Informe a data de reprocessamento do arquivos: " DATA
dia=`julian $DATA`                       #Variavel para armazenar o dia juliano
day=`date --date="-1 day" +20%y%m%d`
#echo "Dia juliano da data informada:$dia"
#Variaveis do script
#$dia : Data Jualiana
#$day : Data menos um dia `date --date="-1 day" +20%y%m%d`
#$LJ : Numero da LJ informada pelo usuáo.
#$QTD : Quantidade de arquivos para serem lidos
#$ARQ : Nome do arquivo a ser lido
DIR=/home2/makro/st_rcv/str_000$LJ/ #Variavel dieretorio normal para arquivos com a data do dia anterior igual a data de reprocessamento
DIROLD=/home2/makro/st_rcv/str_000$LJ/old/ #Variavel do direitorio para data diferente da do dia anterior para reprocessamento
if [ $DATA != $day  ] ; then #Se a DATA for difernete do dia anterior ele ira buscar no diretorio old
	for i in $( seq $QTD ) ; do
	read -p "Informe o nome do $i arquivo: " ARQ
	if [ -e $DIROLD$ARQ$dia ]; then #Verifica se o arquivo esta no diretorio 
		cd /home2/makro/st_rcv/str_000$LJ/old/
		ls -ltr $ARQ$dia*
		cp $ARQ$dia* ../
		gunzip $DIR$ARQ$dia
		NUM=$(sed '1{s/[^0-9]\+//g;q};d' $DIR$ARQ$dia)
		ARQSEQ=/tmp/${LOGNAME}_anaseq_roda.sql
		#Select para verificar o numero antes de atualizar
		read -p " Pressione enter para verificar o numero antes de atualizar" nada		
					cat > $ARQSEQ  << end_sql
					select * from autonumber
					where seq_no = $LJ
					and key_name = '$ARQ'

					/
end_sql
		sqlplus $ORAID @$ARQSEQ #select para verificar numero de sequencia 
		
						read -p "Pressione enter para atualizar" nada 
						cat > $ARQSEQ << end_sql
						update autonumber set no = $NUM
						where key_name = '$ARQ'
						and seq_no = $LJ

						/
end_sql
			sqlplus $ORAID @$ARQSEQ #Atualiza numero de sequencia


							cat > $ARQSEQ  << end_sql
							select * from autonumber
							where seq_no = $LJ
							and key_name = '$ARQ'

							/
end_sql
				sqlplus $ORAID @$ARQSEQ #select apos atualizacao
			
			
	else
			    read -p "Arquivo nao esta no diretorio verifique! Presseione enter para sair! " nada
			exit 1		
		fi
		done
else
	for i in $(seq $QTD); do
	read -p "Informe o nome do $i° arquivo " ARQ
		if [ -e $DIR$ARQ$dia ]; then  #Verifica se o arquivo esta no diretorio
			read -p  "Arquivo encontrado (Pressione enter)" nada 
			cd /home2/makro/st_rcv/str_000$LJ/
			ls -ltr $ARQ$dia*
			cp $ARQ$dia* ../
			gunzip $DIR$ARQ$dia
			NUM=$(sed '1{s/[^0-9]\+//g;q};d' $DIR$ARQ$dia)
			ARQSEQ=/tmp/${LOGNAME}_anaseq_roda.sql
			#Select para verificar o numero antes de atualizar
			read -p " Pressione enter para verificar o numero antes de atualizar" nada
			cat > $ARQSEQ  << end_sql
			select * from autonumber
			where seq_no = $LJ
			and key_name = '$ARQ'

			/
end_sql
			sqlplus $ORAID @$ARQSEQ
				read -p "Pressione enter para atualizar"
				cat > $ARQSEQ << end_sql
				update autonumber set no = $NUM
				where key_name = '$ARQ'
				and seq_no = $LJ

				/
end_sql
				sqlplus $ORAID @$ARQSEQ
					cat > $ARQSEQ  << end_sql
					select * from autonumber
					where seq_no = $LJ
					and key_name = '$ARQ'

					/
end_sql
					else 
					read -p "Arquivo nao encontrado (Pressione enter)" nada
				exit 1
			fi
		done		
fi
;;
0)	exit 0;;
*)read -p "              Escolha uma opcao valida! Tecle <enter> "
clear
esac
OPT=999
done 
AN
