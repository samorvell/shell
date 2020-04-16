#! /bin/bash
#Shell para rodar arquivos scrcom versao 1.0
#Desenvolvido por Samuel Amaro da Silva
#Verificar lojas no toad, na tabela NRSTAUS, quais loja estao com erro no scrcom
#Informar a quantidade de lojas com erro, depois informar o numero das lojas para execucao
#Nessa versao  ainda necessida executar o ctrl+d para sair do sql, apos exeuctar a procedure

clear
echo "|=========================================================|"
echo "|Shell de facil entendimento, basta seguir as instrucoes  |"
echo "|SCRCOM V. 1.0                                            |"
echo "|=========================================================|"

DAY=`date --date="-1 day" +20%y%m%d` 	 #Variavel que armazena o dia anterior para linha for store abaixo

read -p "Informe a data do rundate aaaammdd: " DATA
read -p 'Entre com a LOJA (ou lojas separadas por espaco) ' LJ
DIA=`julian $DATA`

#echo 'Entre com o nome do sql a ser executado:'
#read  PRG
#if [ ! -r ${PRG}.sql ]
#then
#  echo SQL $PRG.sql nao existe neste diretorio
#  exit 1

#fi
VT_PRGEXE=/tmp/${LOGNAME}_SCRCOM_roda.sql

cat > $VT_PRGEXE << end_sql
SET ECHO OFF
SET HEADING OFF
SET VERIFY OFF
SET PAGESIZE 0
SET LINESIZE 600
SET FEEDBACK OFF
alter session set NLS_NUMERIC_CHARACTERS = ',.';
SPOOL /tmp/&1.$LOGNAME
-- SELECT 'EXECUTANDO LOJA:', STORE_NO from STORE;
end_sql
cat  $PRG.sql  >>  $VT_PRGEXE
cat >> $VT_PRGEXE << end_sql
spool off
exit;
end_sql

rm /tmp/${PRG}*${LOGNAME} >/dev/null 2>/dev/null
for file in  $LJ
do
        VT_HOST_LJ=`$MS_PROGS/get_var_store.sh $file 4`
        echo chamando loja ${VT_HOST_LJ} ... arquivo lojas !!!!
  sqlplus -s ops$storep/ops$storep@${VT_HOST_LJ} @$VT_PRGEXE ${PRG}_${VT_HOST_LJ}.lst &
  sleep 1
done