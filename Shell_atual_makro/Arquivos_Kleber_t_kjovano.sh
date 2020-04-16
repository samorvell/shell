#!/bin/bash
clear

echo "Informe o numero da loja 00:"
read STORE
echo "Informe o a quantidade de arquivos:"
read QTD
echo "Informe a data dos arquivos aaaammdd:"
read DATA
dia=`julian $DATA`

for i in $( seq  $QTD ) ; do
echo "Informe o nome do $i arquivo:"
read ARQ
cd /home2/makro/st_rcv/str_000$STORE/old/
ls -ltr *$ARQ$dia*
cp /home2/makro/st_rcv/str_000$STORE/old/$ARQ$dia.gz /tmp
cd /tmp/
gunzip $ARQ$dia.gz
ls -ltr /tmp/*$dia*
scp /tmp/$ARQ$dia t_wmarvyn@brsdl88:/tmp/
done