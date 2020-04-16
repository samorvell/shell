#!/bin/bash
#|
#|
#|
#|
#|
#|
#|
#|
#|
#|
#|
clear
OPT=999
while test $OPT -ne 0
do
HL=./HOLOGL.sh 
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
echo              "  R E P R O C E S S A  H O L O G L  "
tput sgr0
echo
#read -p "Pressione enter!" nada
echo
read -p "                        1) Reprocessar HOLOGL101
							
		 	2) Reprocessar HOLOGL102

                        0) Sair

                       Opcao Escolhida --> "  OPT

case $OPT in
1)read -p "		 Informe a data de reprocessamento
          		Pressione enter " nada
read -p   "                   ANO: " ANO
read -p	  "		   MES: " MES
read -p   "		   DIA: " DIA
read -p  "Informe o numero do chamado " NMCHA
echo $NMCHA >> hologl101.log
DATA=$DIA/$MES/$ANO
VT_RUNDATE=$ANO$MES$DIA
JULIAN=`julian $VT_RUNDATE`
VL_ARQ1=ARQHOLOGL101.${JULIAN}
read -p "			Data de processamento HOLOGL101 $DATA 
				Pressione enter para continuar " nada
HORA=`date | cut -c12-19`
echo "Data $DATA" >> hologl101.log
echo "Inicio $HORA " >> hologl101.log
echo "==============================="  
nohup sqlplus $ORAID @$MS_PROGS/hologl101 $VT_RUNDATE /tmp/$VL_ARQ1 &
PROG=hologl101
echo $PROG > prog.txt
./verificaprog.sh
#while true ; do
#CHECK=`ps -eaf|grep hologl |wc -l`
#CHECK1=`ps -eaf|grep hologl`
#echo $CHECK1 > ver.log
#PROG1=`cat ver.log| awk '{print $9,$10}'`
#if [ $CHECK -eq 1 ]; then
#	 echo "Processando $PROG1 "
#	 HORA=`date | cut -c12-19`
#         echo "Hora $HORA  "
#	 sleep 1
#         else
#         clear
#	 read -p  "Nao esta processando nada
#		Pressione enter  " nada
#fi	
#done
#chmod 777 /tmp/$VL_ARQ1
#mv -f /tmp/$VL_ARQ1 $MS_LIST/snd/interface/
HORA=`date | cut -c12-19`
read -p "e agora, sera que continua? pressione enter! " nada
echo "Data $DATA" >> hologl101.log
echo "Termino $HORA " >> hologl101.log
echo "==============================="
PROGS=`cat prog.txt`
LISTPROG=`ls /tmp/$VL_ARQ1`
if [ $LISTPROG -e   ]; then
	read -p "Arquivo esta no /tmp, pressione enter para proseguir! " nada
		chmod 777 $LISTPROG
		mv $LISTPROG $MS_LIST/snd/interface/
		TESTPROG=`ls $MS_LIST/snd/interface/$VL_ARQ1`
		if [ $TESTPROG -e  ]; then 
		echo " 		HOLOGL101 reprocessado, arquivo disponibilizado para portal "
		read -p "	Pressione enter para sair " nada
		else
			read -p  "Por favor rever, arquivo nao esta disponivel no diretorio para portal. "  nada
		fi
else 
read -p "Arquivo nao esta o /tmp, por favor verifique! Pressione enter!  " nada
fi
;;
2)read -p "			Informe a data do rundate
		 Pressione enter " nada
read -p   "                   ANO: " ANO
read -p	  "		   MES: " MES
read -p   "		   DIA: " DIA
read -p  "Informe o numero do chamado " NMCHA
PROG=hologl102
echo $NMCHA >> hologl102.log
echo $PROG > prog.txt
DATA=$DIA/$MES/$ANO
VT_RUNDATE=$ANO$MES$DIA
JULIAN=`julian $VT_RUNDATE`
VL_ARQ1=ARQHOLOGL102.${JULIAN}
read -p "			Data de processamento HOLOGL102 $DATA 
				Pressione enter para continuar " nada
nohup sqlplus $ORAID @$MS_PROGS/hologl102 $VT_RUNDATE /tmp/$VL_ARQ1 &
./verificaprog.sh 
chmod 777 /tmp/$VL_ARQ1
mv -f /tmp/$VL_ARQ1 $MS_LIST/snd/interface/
echo " 		HOLOGL101 reprocessado, arquivo disponibilizado para portal "
read -p "	Pressione enter para sair " nada
;;
0)exit
;;
*) read -p "              Escolha uma opcao valida! Tecle <enter> "
clear
esac
OPT=999
done


