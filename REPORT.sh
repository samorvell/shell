#!/bin/bash
#Shell scrpt para reenviar arquivos de relatorio
clear
#echo "/==============================================/"
#read -p "Relatorio solicitado e do tipo ARQ? (sim ou nao) " TIPOtput rev
echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA
tput cup 3 24
echo            "  R E L T O R I O S   P O R T A L  "
tput sgr0
echo -e "						 MENU PRINCIPAL RELATORIOS PORTAL
										|=============================|
										|1) Para relatorios tipo ARQ: |
										|=============================|
										|2) Para relatorios tipo PDF: |
										|=============================|"
read -p "Escolha uma opcao: " OPT

case $OPT in
1)
        echo "/==============================================/"
        echo "Para relatorios tipo ARQ, sao relaltorios para todas as lojas"
        echo "nao ha relatorio para loja individual."
        OLD=/home2/makro/snd/interface/old
        echo "/==============================================/"
        echo "Informe a quantidade de relatorios: "
        read QTD
        echo "Informe a data do relatorio solicitado: "
        read DATA
        DIA=`julian $DATA`
                for i in $( seq $QTD ); do
                echo "/==============================================/"
                echo "Informe o nome do $i relatorio: "
                read REL
                echo "/==============================================/"
                        if [ -e $OLD/$REL.$DIA.Z ]; then
                        echo "Arquivo esta no diretorio."
                        read RESP
                        ARQ=`ls $OLD/$REL.$DIA.Z`
                        cp $ARQ /home2/makro/snd/interface/
                        ARQ1=/home2/makro/snd/interface/$REL.$DIA.Z
                        uncompress $ARQ1
                        ARQ2=/home2/makro/snd/interface/$REL.$DIA
                        chmod 777 $ARQ2
                                else
                                echo "Arquivo nao esta no diretorio ou esta com outro nome, verifique. "
                        fi
                done
;;
2)
echo "/==============================================/"
read -p "Informe a quantidade de relatorios: " QTD
echo "/==============================================/"
read -p "Informe o numero da loja: " LJ
echo "/==============================================/"
#read -p "Favor informar o nome do relatorio: " REL
read -p "Informe a data do relatorio solicitado: YYYYMMDD " DATA
echo "/==============================================/"
DIA=`julian $DATA`

for i in $( seq $QTD ); do
		echo   "Informe o nome do $i relatorio: "
		read REL
		echo "/==============================================/"
		if [ -e $MS_LIST/list/str_000$LJ/old/$REL.*.$DIA.Z ] ; then
        echo "Arquivo esta no diretorio. "
        read RESP
        ARQ=`ls $MS_LIST/list/str_000$LJ/old/$REL.*.$DIA.Z`
        cp $ARQ /$MS_LIST/list/str_000$LJ/
        ARQ1=$MS_LIST/list/str_000$LJ/$REL.*.$DIA.Z
        gunzip $ARQ1
        ls -ltr $MS_LIST/list/str_000$LJ/$REL.*.$DIA
        chmod 777 $MS_LIST/list/str_000$LJ/$REL.*.$DIA
		else
        echo "Arquivo nao esta no diretorio ou esta com outro nome, verifique. "
		fi
done
;;
*)echo "Favor informar uma opcao valida! "                