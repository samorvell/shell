#!/bin/bash
#Shell script para reenviar arquivos de relatorio, deve ser usado com
#usuario suheadof.

#Efetuar alteração para outro tipo de arquivo a ser procurado no MBSPRD
#relatorios do tipo ARQ
#Arquivo 
#MBSPRD: - home2/makro/list/str_00063/old -- Por loja PDF
#MBSPRD: - /home2/makro/snd/interface/old -- HO TXT
#Apos mover os arquivos da pasta OLD mudar permissões dos aquivos para 777
#com o comando chmod 777 nome DO arquivo

clear
read -p "Informe a quantidade de relatorios: " QTD
echo /==============================================/
read -p "Informe o numero da loja: " LJ
echo /==============================================/
#read -p "Favor informar o nome do relatorio: " REL
read -p "Favor informar data do relatorio solicitado: YYYYMMDD " DATA
echo /==============================================/
DIA=`julian $DATA`

for i in $( seq $QTD ); do
echo   "Informe o nome do $i relatorio: "
read REL

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
        echo "Arquivo nao esta no diretorio ou esta com outro nome verifique. "
fi
done
