#!/bin/bash
read -p "Informe data do movimento aaaammdd " DATA
read -p "Informe as lojas separadas por espacos " LJ
for file in $LJ  ;   do
DIA=`julian $DATA`
cp /home2/makro/st_rcv/str_000$file/old/scrcom$DIA.gz /home0/users/trescon/scrcom1/
DIR=/home0/users/trescon/scrcom1/scrcom$DIA.gz
DIRE=/home0/users/trescon/scrcom1/scrcom$DIA.lj_$file.gz
mv $DIR /home0/users/trescon/scrcom1/scrcom$DIA.lj_$file.gz
gunzip  $DIRE
ls -ltr /home0/users/trescon/scrcom1/
#mv /home0/users/trescon/scrcom1/scrcom$DIA /home0/users/trescon/scrcom1/scrcom$DIA.$file
echo "Arquivos copiados para o direntorio anterior! "
done
