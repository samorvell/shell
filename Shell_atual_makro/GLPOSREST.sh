#!/bin/bash
#Shell para reprocessar vendas do posto e restaurante
#quando necessario, houve uma correcao pois nao subia
#valores para o oracle 
######################################################
clear
GLP=./GLPOSREST.sh
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
OPT=999; msg=" "
while test $OPT -ne 0
do
CAB=$(tput rev; echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA; tput cup 3 24; echo            "REPROCESSA VENDA! "; tput sgr0)
tput rev
echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA
tput cup 3 24
echo            "R E P R O C E S S A   V E N D A !"
tput sgr0
#read -p "Favor informar a data de reprocessamento no formato yyyymmdd: " DATA
read -p  "
		1) Para reprocessar apenas o posto:

		2) Para reprocessar apenas restaurante: 

		3) Para reprocessar os dois (POSTO e RESTAURANTE): 
		
		4) Para reprocessar um restaurante especifico :

		0) Sair

			opcao Escolhida --> "  OPT
#echo -n "Escolha uma opcao: "
#read OPT
case $OPT in
1)clear 
echo $CAB
echo
echo 
echo
echo  "			       	 Reprocessa venda POSTO  "
echo  "  	        	Favor informar a data de reprocessamento: "
echo 
echo
read -p "		  Informe o ano: " ANO
read -p " 		  Informe o mes: " MES
read -p "		  Informe o dia: " DIA
DATA=$ANO$MES$DIA
DPROC=$DIA/$MES/$ANO
read -p "   Infomre o numero do chamado : " NUNC
echo $NUNC >> contro.log 
read -p "   Executando reprocessamento do posto data $DPROC
		     para confirmar 
		    pressione enter!  " nada
HORA=`date | cut -c12-19`
echo "Hora de inicio $HORA  "
echo "Hora de inicio $HORA" >> contro.log 
nohup sqlplus  $ORAID @$MS_PROGS/ins_posto_gl_lines $DATA &
echo $DPROC >> contro.log
PROG=ins_posto_gl_lines
echo $PROG > prog.txt
./verificaprog.sh
echo ins_posto_gl_lines $DATA >> contro.log
HORA=`date | cut -c12-19`
echo " Hora de termino $HORA " >> contro.log
echo "==============================================" >> contro.log
echo $? >> /dev/null
if  [ $? != 0   ] ; then 
echo "Variavel $? retornou diferente de 0, houve algum erro interno"
echo "Erro de retorno: $?"
	else		
			echo "Executatdo com sucesso!"
			HORA=`date | cut -c12-19`
			echo "Hora de termino $HORA  "
			read -p "Pressione enter!" nada
			clear
fi		
;;
2)clear 
echo $CAB
echo "


	   	  Reprocessa venda RESTAURANTE   "
echo "  	    Favor informar a data de reprocessamento: "
echo
echo
read -p "              Informe o ano: " ANO
read -p "              Informe o mes: " MES
read -p "              Informe o dia: " DIA
DATA=$ANO$MES$DIA
DPROC=$DIA/$MES/$ANO 
read -p "   Infomre o numero do chamado : " NUNC
echo $NUNC >> contro.log
read -p "   Executando reprocessamento do restaurante data $DPROC			  
		   Pressione enter!  " nada
				HORA=`date | cut -c12-19`
				echo " Hora inicio $HORA "
				echo "Hora de inicio $HORA" >> contro.log
			#	read -p "estou aqui" nada
				nohup sqlplus  $ORAID @$MS_PROGS/ins_rest_gl_lines $DATA &
				PROG=ins_rest_gl_lines 	
				echo $PROG > prog.txt
				./verificaprog.sh 
				echo $DPROC >> contro.log
				echo ins_rest_gl_lines $DATA >> contro.log
				HORA=`date | cut -c12-19`
				echo " Hora de termino $HORA " >> contro.log
				echo "==============================================" >> contro.log
				if  [ $? != 0   ] ; then 
				echo "Variavel $? retornou diferente de 0, houve algum erro interno"
				echo "Erro de retorno: $?"
				else
							echo "Executatdo com sucesso!"
							HORA=`date | cut -c12-19`
							echo " Hora de termino $HORA  "
							read -p "Pressione enter!" nada
							clear
				fi
;;
3)clear 
echo $CAB
echo  "         Reprocessaar POSTO e RESTAURANTE  "
echo "  Favor informar a data de reprocessamento: "
echo
echo
read -p "              Informe o ano: " ANO
read -p "              Informe o mes: " MES
read -p "              Informe o dia: " DIA
DATA=$ANO$MES$DIA
DPROC=$DIA/$MES/$ANO 
read -p "   Executando reprocessamento do posto e restaurante data $DPROC			   
		   Pressione enter!  " nada
 							 nohup sqlplus  $ORAID @$MS_PROGS/ins_posto_gl_lines $DATA &
							 if  [ $? != 0   ] ; then 
							 echo "Variavel $? retornou diferente de 0, houve algum erro interno"
							 echo "Erro de retorno: $?"
							 else
										echo "Executatdo GLPOSTO com sucesso!"
										read -p "Pressione enter!" nada
										clear
							 fi		 
 
										nohup sqlplus  $ORAID @$MS_PROGS/ins_rest_gl_lines $DATA &
										if  [ $? != 0   ] ; then 
										echo "Variavel $? retornou diferente de 0, houve algum erro interno"
										echo "Erro de retorno: $?"
										else
													echo "Executatdo GLRESTAURANTE com sucesso!"
												 	echo " Hora de termino  $HORA "
											read -p "Pressione enter!" nada
													clear
										fi
;;
4)clear
echo $CAB
echo " Reprocessar Restaurante especifico:  "
echo  "         Reprocessaar POSTO e RESTAURANTE  "
echo "  Favor informar a data de reprocessamento: "
echo
echo
read -p "              Informe o ano: " ANO
read -p "              Informe o mes: " MES
read -p "              Informe o dia: " DIA
DATA=$ANO$MES$DIA
DPROC=$DIA/$MES/$ANO
read -p " Informe os numero dos restaurates ( separadas por espaco XX)  "  LJ
for file in $LJ ; do
REST=/home0/users/trescon/Shell/GLPOST/
ARQSQL=/home0/users/trescon/Shell/GLPOST/teste.sql
PRGEXE=/home0/users/trescon/Shell/GLPOST/teste.sql
#rm -rf /home0/users/trescon/SCRCOM/procscrcom/*.sql
#cp /home2/makro/st_rcv/str_000$file/scrcom$DIA /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$file.sql
#PRG=/home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$file.sql
cat > $ARQSQL << end_sql
SET ECHO ON
SET HEADING OFF
SET VERIFY OFF
SET PAGESIZE 0
SET LINESIZE 600
SET FEEDBACK ON
alter session set NLS_NUMERIC_CHARACTERS = ',.';
PL/SQL 'EXECUTANDO LOJA:', STORE_NO from STORE;
end_sql
cat  $PRG  >>  $PRGEXE
cat >> $ARQSQL << end_sql
spool OFF
exit


end_sql
sqlplus $ORAID @$REST/teste
if [ $? != 0  ] ; then
echo "Nao deu!"
else
echo " retorno $? ok!"
fi
read -p "Pressione enter para sair! " nada
done										
clear
;;
0)read -p " 		     Pressione enter para sair!  "  nada
./MENU.sh
;; 
*) read -p "		   Favor informar uma opcao valida!
			   (Pressione enter!) " nada  ; 
clear
esac
done
