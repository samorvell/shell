#!/bin/ksh
echo " \07 ESTA OPÇÃO SÓ FUNCIONA SE A COMSAT ESTIVER NO AR ( TECLE ENTER) \c"
read nada                                                                  
echo "user rxtx rxtx" >/tmp/w_recebe
echo "cd loja$LJ" >>/tmp/w_recebe
echo "dir TX*.*Z /tmp/dirlist.tx" >>/tmp/w_recebe
echo "dir ???com.str??.?????.Z /tmp/dirlist.com" >>/tmp/w_recebe
ftp -ivn MAKROHO </tmp/w_recebe
#-----------------------------  Junto os resultados dos arquivos -------------
echo " ">/tmp/dirlist
echo " ">>/tmp/dirlist
echo "********************* Arquivos TX *************************************">>/tmp/dirlist
echo " ">>/tmp/dirlist
cat /tmp/dirlist.tx >>/tmp/dirlist
echo " ">>/tmp/dirlist
echo "********************* Arquivos MBS ***************************************">>/tmp/dirlist
echo " ">>/tmp/dirlist
cat /tmp/dirlist.com >>/tmp/dirlist
echo " ">>/tmp/dirlist
echo " ">>/tmp/dirlist
echo " ">>/tmp/dirlist
