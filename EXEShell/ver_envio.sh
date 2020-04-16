#!/bin/ksh
read nada
echo "user rxtx rxtx" >/tmp/w_envio
echo "cd loja$LJ" >>/tmp/w_envio
# echo "dir *com*" >>/tmp/w_envio
# echo "dir RX*" >>/tmp/w_envio
echo "dir *com* /tmp/dirlist.com" >>/tmp/w_envio
echo "dir RX* /tmp/dirlist.rx" >>/tmp/w_envio
ftp -in MAKROHO </tmp/w_envio
#-------------------------------------- MBS --------------------------------
echo "user rxtx rxtx" >/tmp/w_envio
echo "cd /home2/makro/rcv/str$LJ" >>/tmp/w_envio
# echo "dir *com*" >>/tmp/w_envio
echo "dir *com* /tmp/dirlist.mbs" >>/tmp/w_envio
ftp -in MBSPRD </tmp/w_envio
#------------------------ Junto os resultados  dos arquivos ----------------
echo " ">>/tmp/dirlist
echo " ">>/tmp/dirlist
echo "***********************  Arquivos RX  na area de Transmissao   ****************  ">>/tmp/dirlist
echo " ">>/tmp/dirlist
cat /tmp/dirlist.rx >>/tmp/dirlist
echo " ">>/tmp/dirlist
echo "*************  Arquivos do MBS (com) na area de Transmissao  *************">>/tmp/dirlist
echo " ">>/tmp/dirlist
cat /tmp/dirlist.com >>/tmp/dirlist
echo " ">>/tmp/dirlist
echo "*************  Arquivos no Servidor MBS ja para processar *******">>/tmp/dirlist
echo " ">>/tmp/dirlist
cat /tmp/dirlist.mbs >>/tmp/dirlist
echo " ">>/tmp/dirlist
echo " ">>/tmp/dirlist
echo " ">>/tmp/dirlist
