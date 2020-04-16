#!/bin/bash
read -p "Informe a data do rundate aaaammdd: " DATA
DIA=`julian $DATA`
read -p "Entre com a LOJA (ou lojas separadas por espaco)00 " LJ
for file in $LJ ;
do
PRGEXE=/tmp/${LOGNAME}_SCRCOM_roda.sql
#rm -rf /home0/users/trescon/SCRCOM/procscrcom/*.sql
cp /home2/makro/st_rcv/str_000$file/scrcom$DIA /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$file.sql
PRG=/home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$file.sql
cat > $PRGEXE << end_sql
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
cat  $PRG  >>  $PRGEXE
cat >> $PRGEXE << end_sql
spool off
exit;
end_sql

 sqlplus $ORAID @$PRG                   #/home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$file.sql
done
cd  /home0/users/trescon/SCRCOM/procscrcom/
tar -cf scrcom$DIA.tar /home0/users/trescon/SCRCOM/procscrcom/*.sql 2> /dev/null
cd /home0/users/trescon/SCRCOM/procscrcom/
bzip2 scrcom$DIA.tar /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA.tar 2> /dev/null
#mv /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA.tar.bz2 /home0/users/trescon/SCRCOM/procscrcom/scrcomlojas/
rm -rf /home0/users/trescon/SCRCOM/procscrcom/*.sql
rm -rf /home0/users/trescon/SCRCOM/procscrcom/scrcomlojas/*.sql
echo "Arquivos compactados"
echo "e deletados"

#cp /home2/makro/st_rcv/str_000$LJ/scrcom$DIA /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$LJ.sql
#sqlplus $ORAID @/home0/users/trescon/SCRCOM/procscrcom/scrcomlojas/scrcom$DIA$ESTORE.sql
#mv /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$LJ.sql /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$LJ.sql_teste_ok

#done




#cp /home2/makro/st_rcv/str_000$LJ/scrcom$DIA /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$LJ.sql
#sqlplus $ORAID @/home0/users/trescon/SCRCOM/procscrcom/scrcomlojas/scrcom$DIA$ESTORE.sql
#mv /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$LJ.sql /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$LJ.sql_teste_ok

#done
