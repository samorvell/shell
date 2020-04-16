#!/bin/bash
ValidUpd=` find /home/work/TRANSF/storeprod/CADTXT.TXT -type f -mmin -3 | wc -l ` 
if [ "${ValidUpd}" -ne "0" ]
then
  cp -a -f /home/work/TRANSF/storeprod/CADTXT.TXT //mnt/DPDTRANSF/LOJA06/CADTXT.TXT
  cp -a -f /home/work/TRANSF/storeprod/SETORTXT.TXT //mnt/DPDTRANSF/LOJA06/SETORTXT.txt
  cp -a -f /home/work/TRANSF/storeprod/Configuracoes.txt //mnt/DPDTRANSF/LOJA06/Configuracoes.txt
  cp -a -f /home/work/TRANSF/storeprod/Produtos.txt //mnt/DPDTRANSF/LOJA06/Produtos.txt
fi
