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
echo  "		       	 Reprocessa venda POSTO  "
echo  "  		Favor informar a data de reprocessamento: "
echo 
echo
read -p "		  Informe o ano: " ANO
read -p " 		  Informe o mes: " MES
read -p "		  Informe o dia: " DIA
DATA=$ANO$MES$DIA
DPROC=$DIA/$MES/$ANO 
read -p "   Executando reprocessamento do posto data $DPROC
		     para confirmar 
		    pressione enter!  " nada
sqlplus  $ORAID @$MS_PROGS/ins_posto_gl_lines $DATA
echo $? >> /dev/null
if  [ $? != 0   ] ; then 
echo "Variavel $? retornou diferente de 0, houve algum erro interno"
echo "Erro de retorno: $?"
	else		
			echo "Executatdo com sucesso!"
			read -p "Pressione enter!" nada
			clear
fi		
;;
2)clear 
echo $CAB
echo "   Reprocessa venda RESTAURANTE   "
echo "  Favor informar a data de reprocessamento: "
echo
echo
read -p "              Informe o ano: " ANO
read -p "              Informe o mes: " MES
read -p "              Informe o dia: " DIA
DATA=$ANO$MES$DIA
DPROC=$DIA/$MES/$ANO 
read -p "   Executando reprocessamento do restaurante data $DPROC			  
		   Pressione enter!  " nada
				sqlplus  $ORAID @$MS_PROGS/ins_rest_gl_lines $DATA
				if  [ $? != 0   ] ; then 
				echo "Variavel $? retornou diferente de 0, houve algum erro interno"
				echo "Erro de retorno: $?"
				else
							echo "Executatdo com sucesso!"
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
 							 sqlplus  $ORAID @$MS_PROGS/ins_posto_gl_lines $DATA
							 if  [ $? != 0   ] ; then 
							 echo "Variavel $? retornou diferente de 0, houve algum erro interno"
							 echo "Erro de retorno: $?"
							 else
										echo "Executatdo GLPOSTO com sucesso!"
										read -p "Pressione enter!" nada
										clear
							 fi		 
 
										sqlplus  $ORAID @$MS_PROGS/ns_rest_gl_lines $DATA  
										if  [ $? != 0   ] ; then 
										echo "Variavel $? retornou diferente de 0, houve algum erro interno"
										echo "Erro de retorno: $?"
										else
													echo "Executatdo GLRESTAURANTE com sucesso!"
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
sqlplus $ORAID @$REST/teste
if [ $? != 0  ] ; then
echo "Nao deu!"
else
echo " retorno $? ok!"
fi
done
;;
0)read -p " 		     Pressione enter para sair!  "  nada
./MENU.sh
;; 
*) read -p "		   Favor informar uma opcao valida!
			   (Pressione enter!) " nada  ; 
clear
esac
done
