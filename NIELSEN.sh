#! /bin/bash
#|-------------------------------------------------------------|
#|      Shell para reprocessar arquivos NIELSEN                |
#|      V. 1.0 						       |
#|      V. 1.1 Atualização na data e layout da tela            |
#|      Author Samuel Amaro da Silva                           |
#|-------------------------------------------------------------|
# O shell faz uma conexao ftp com uma maquina remota, ha uma demora
# que e normal, basta apenas aguardar o processamento e envio dos
# 4 arquivos que e feito o envio.
############################################################################
#                               Cabecalho                                  #
############################################################################
clear
#OPT=999; msg=" "
#while  test $OPT -ne 0
#do
LJ=`uname -n`
   LOJA="$LJ"
RAZAO="MAKRO ATACADISTA S.A"
#TOFF=`tput rmso`
#TBOLD=`tput bold`
#TBLINK=`tput blink`
#TRES=`tput smso`
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
###########################################################################################
tput rev
echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA
tput cup  4  15
echo  " R E E N V I O  A R Q U I V O S  N I E L S E N  "
tput sgr0
DIR=/home2/makro/snd/interface/old
echo
echo
read -p  "
		1) Para reenvio arquivos NIELSEN

		0) Sair

			opcao Escolhida --> "  OPT
#echo -n "Escolha uma opcao: "
#read OPT
case $OPT in
1)
#read -p "        Informe a data para reenvio dos arquivos:(YYYYMMDD) " DTARQ
echo " 	    Favor informar a data de reenvio dos arquivos: "
echo
#echo
read -p "            Informe o ano: " ANO
read -p "            Informe o mes: " MES
read -p "            Informe o dia: " DIA
DTARQ=$ANO$MES$DIA
if [ -e $DIR/produtos$DTARQ.txt.gz ]  || [ -e $DIR/mv*$DTARQ.txt.gz ] || [ -e  $DIR/lojas$DTARQ.txt.gz ] || [ -e  $DIR/depto$DTARQ.txt.gz  ]; then
echo "                  Arquivos estao no diretorio!"
echo "                  Deseja reenvia-los? (sim/nao)"
read RESP
        if [ ${RESP} !=sim  ] ; then
        PROD=produtos$DTARQ.txt.gz
        RENV=_reenvio.txt.gz
        ENVPRD=produtos$DTARQ$RENV
        $MS_PROGS/rt_prc_ftp ftp.acnielsen.com.br makro sotCBySmMc WIN put $DIR $PROD /rede0286 $ENVPRD
        cp $DIR/mv*$DTARQ.txt.gz /home0/users/trescon/progs/
        MV=`ls mv*$DTARQ.txt.gz`
        ENVMV=$MV$RENV
        $MS_PROGS/rt_prc_ftp ftp.acnielsen.com.br makro sotCBySmMc WIN put $DIR $MV /rede0286 $ENVMV
        LOJAS=lojas$DTARQ.txt.gz
        ENVLJ=lojas$DTARQ$RENV
        $MS_PROGS/rt_prc_ftp ftp.acnielsen.com.br makro sotCBySmMc WIN put $DIR $LOJAS /rede0286 $ENVLJ
        DPTO=depto$DTARQ.txt.gz
        ENVDPTO=depto$DTARQ$RENV
        $MS_PROGS/rt_prc_ftp ftp.acnielsen.com.br makro sotCBySmMc WIN put $DIR $DPTO /rede0286 $ENVDPTO
        else
                read -p "  Ok! saindo! Pressione enter! "  nada
                exit 0
        fi
#exit 0
else
clear
echo "          Arquivos nao estao no direotrio, verifique."
read -p  "          Para sair pressione enter!"  nada
./NIELSEN.sh
clear
fi
#clear
;;
0)read -p " 		     Pressione enter para sair!  "  nada
./MENU.sh
;;
*) read -p "		   Favor informar uma opcao valida!
			   (Pressione enter!) " nada  ; 
clear
esac