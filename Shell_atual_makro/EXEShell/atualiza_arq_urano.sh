#!/bin/bash
ValidUpd=` find /home/work/TRANSF/storeprod/PRODUTOS_TOPMAXS.txt -type f -mmin -4 | wc -l ` 
if [ "${ValidUpd}" -ne "0" ]
then
  touch /mnt/DPDTRANSF/URANO-LOJA06/Configuracoes_06bal01.txt 
  touch /mnt/DPDTRANSF/URANO-LOJA06/Configuracoes_06bal02.txt
  touch /mnt/DPDTRANSF/URANO-LOJA06/Configuracoes_06bal03.txt
  touch /mnt/DPDTRANSF/URANO-LOJA06/Configuracoes_06bal04.txt 
  touch /mnt/DPDTRANSF/URANO-LOJA06/Configuracoes_06bal05.txt
  touch /mnt/DPDTRANSF/URANO-LOJA06/Configuracoes_06bal06.txt
  touch /mnt/DPDTRANSF/URANO-LOJA06/Configuracoes_06bal07.txt
  cp -a -f /home/work/TRANSF/storeprod/PRODUTOS_TOPMAXS.txt //mnt/DPDTRANSF/URANO-LOJA06/PRODUTOS_06bal01.txt > /tmp/log_import_balancas_urano.txt 
  cp -a -f /home/work/TRANSF/storeprod/PRODUTOS_TOPMAXS.txt //mnt/DPDTRANSF/URANO-LOJA06/PRODUTOS_06bal02.txt > /tmp/log_import_balancas_urano.txt
  cp -a -f /home/work/TRANSF/storeprod/PRODUTOS_TOPMAXS.txt //mnt/DPDTRANSF/URANO-LOJA06/PRODUTOS_06bal03.txt > /tmp/log_import_balancas_urano.txt
  cp -a -f /home/work/TRANSF/storeprod/PRODUTOS_TOPMAXS.txt //mnt/DPDTRANSF/URANO-LOJA06/PRODUTOS_06bal04.txt > /tmp/log_import_balancas_urano.txt
  cp -a -f /home/work/TRANSF/storeprod/PRODUTOS_TOPMAXS.txt //mnt/DPDTRANSF/URANO-LOJA06/PRODUTOS_06bal05.txt > /tmp/log_import_balancas_urano.txt
  cp -a -f /home/work/TRANSF/storeprod/PRODUTOS_TOPMAXS.txt //mnt/DPDTRANSF/URANO-LOJA06/PRODUTOS_06bal06.txt > /tmp/log_import_balancas_urano.txt
  cp -a -f /home/work/TRANSF/storeprod/PRODUTOS_TOPMAXS.txt //mnt/DPDTRANSF/URANO-LOJA06/PRODUTOS_06bal07.txt > /tmp/log_import_balancas_urano.txt
  unix2dos //mnt/DPDTRANSF/URANO-LOJA06/PRODUTOS_06bal01.txt > /tmp/log_import_balancas_urano.txt
  unix2dos //mnt/DPDTRANSF/URANO-LOJA06/PRODUTOS_06bal02.txt > /tmp/log_import_balancas_urano.txt
  unix2dos //mnt/DPDTRANSF/URANO-LOJA06/PRODUTOS_06bal03.txt > /tmp/log_import_balancas_urano.txt
  unix2dos //mnt/DPDTRANSF/URANO-LOJA06/PRODUTOS_06bal04.txt > /tmp/log_import_balancas_urano.txt
  unix2dos //mnt/DPDTRANSF/URANO-LOJA06/PRODUTOS_06bal05.txt > /tmp/log_import_balancas_urano.txt
  unix2dos //mnt/DPDTRANSF/URANO-LOJA06/PRODUTOS_06bal06.txt > /tmp/log_import_balancas_urano.txt
  unix2dos //mnt/DPDTRANSF/URANO-LOJA06/PRODUTOS_06bal07.txt > /tmp/log_import_balancas_urano.txt
fi
