#! /bin/bash 
#By Samuel Amaro da Silva
#Shel para corrigir erro de sequencia, busca numero da sequncia correta nos arquivos, e executa o update no banco do mbsho#
#V. 1.0
clear
read -p "Informe o numero da loja (00) " LJ
read -p "Informe a quantidade de arquivos a serem reprocessados " QTD
read -p "Informe a data de reprocessamento do arquivos: " DATA
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


pasta env da ndd mais 10k