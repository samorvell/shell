#--------------------------------------------------------------------------#
#VERIFICA SE A REDE ESTA NO AR
#--------------------------------------------------------------------------#
if test `ps -eaf | grep -v grep | grep -c "stnetp" ` -ne 0
      then
         clear
         echo;echo;echo;echo;echo;echo;
         echo "\07 Os Programas da rede est�o ativos, favor encerrar antes de usar esta opc�o"
         echo ""
         echo "\07 TECLE ENTER"
          read nada
         sleep 1
         exit
fi
