#!/bin/bash
#Verificar lojas no toad, na tabela NRSTAUS, quais loja estao com erro no scrcom
#Informar a data do run date, informar as lojas separadas por espacos, que sera executado.
#|-------------------------------------------------------|
#|      Shel para reprocessar arquivos SCRCOM            |
#|      V. 1.1                                           |
#|-------------------------------------------------------|
#|      V.1.2 Adicionado teste se arquivos constam no    |
#|      diretorio, se nao estiver ele pergunta se e para |
#|      copiar do diretorio old, para diretorio          |
#|      anterior.                                        |
#|      Author Samuel Amaro da Silva                     |
#|                                                       |
#|-------------------------------------------------------|
clear
OPT=999
while test $OPT -ne 0
do
SC=./SCRCOM.sh
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
echo              "  R E P R O C E S S A  S C R C O M  "
tput sgr0
echo
#read -p "Pressione enter!" nada2
echo
read -p "                        1) Para reprocessar SCRCOM
                        0) Sair

                        pcao Escolhida --> "  OPT

case $OPT in
1)read -p "                     Informe a data do rundate aaaammdd: " DATA
DIA=`julian $DATA`
read -p "                 Entre com a LOJA (ou lojas separadas por espaco) " LJ
for file in $LJ ; do
DIR=/home2/makro/st_rcv/str_000$file/scrcom$DIA*
        if  [ -e $DIR ] ; then
        echo "                          Arquivo esta no diretorio! "
                else
                echo "                          Arquivos nao estao no diretorio deseja procurar no old? (sim ou nao)"
                read RESP
                        if [ $RESP != sim  ] ; then
                        echo "                Ok!"
                        exit 1
                                else
                                for file in $LJ  ;   do
                                cp /home2/makro/st_rcv/str_000$file/old/scrcom$DIA* /home2/makro/st_rcv/str_000$file/scrcom$DIA.gz
                                DIR=/home2/makro/st_rcv/str_000$file/scrcom$DIA.gz
                                gunzip  $DIR
				#if [ $? != 0  ] ; then
				#	uncompress $DIR$DIR
				#	else
                                	read -p  "Arquivos copiados para o direntorio anterior! Pressione enter " nada
				#fi
                                done
 			                  fi
        fi
PRGEXE=/tmp/${LOGNAME}_SCRCOM_roda.sql
rm -rf /home0/users/trescon/SCRCOM/procscrcom/*.sql
cp /home2/makro/st_rcv/str_000$file/scrcom$DIA /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$file.sql
PRG=/home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$file.sql
cat > $PRGEXE << end_sql
SET ECHO ON
SET HEADING OFF
SET VERIFY OFF
SET PAGESIZE 0
SET LINESIZE 600
SET FEEDBACK ON
alter session set NLS_NUMERIC_CHARACTERS = ',.';
SPOOL /tmp/&1.$LOGNAME
PL/SQL 'EXECUTANDO LOJA:', STORE_NO from STORE;
end_sql
cat  $PRG  >>  $PRGEXE
cat >> $PRGEXE << end_sql
spool ON
exit;
end_sql
cd /home0/users/trescon/SCRCOM/procscrcom/
 sqlplus $ORAID @$PRG                   #/home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$file.sql
sleep 1
#cp /home2/makro/st_rcv/str_000$LJ/scrcom$DIA /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$LJ.sql
#sqlplus $ORAID @/home0/users/trescon/SCRCOM/procscrcom/scrcomlojas/scrcom$DIA$ESTORE.sql
#mv /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$LJ.sql /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$LJ.sql_teste_ok
done
cd  /home0/users/trescon/SCRCOM/procscrcom/
DIR1=/home0/users/trescon/SCRCOM/procscrcom/*.sql
#/home0/users/trescon/SCRCOM/procscrcom/scrcomlojas/
DIR2=/home0/users/trescon/SCRCOM/procscrcom/scrcomlojas/
cp $DIR1 $DIR2
tar -cf scrcom$DIA.tar /home0/users/trescon/SCRCOM/procscrcom/scrcomlojas/*.sql 2> /dev/null
cd /home0/users/trescon/SCRCOM/procscrcom/scrcomlojas/
gzip scrcom$DIA.tar /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA.tar 2> /dev/null
mv /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA.tar* /home0/users/trescon/SCRCOM/procscrcom/scrcomlojas/
rm -rf /home0/users/trescon/SCRCOM/procscrcom/*.sql
rm -rf /home0/users/trescon/SCRCOM/procscrcom/scrcomlojas/*.sql
#clear
echo "                    Arquivos compactados"
echo "                  e deletados com sucesso!"
echo "                     Pressione enter!"
read nada
#exit 0
clear
;;
0) clear ;exit ; $MN
;;
*)read -p "              Escolha uma opcao valida! Tecle <enter> "
clear
esac
OPT=999
done
SC
