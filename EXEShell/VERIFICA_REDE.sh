#--------------------------------------------------------------------------#
#VERIFICA SE A REDE ESTA NO AR
#--------------------------------------------------------------------------#
if [ `ps -eaf | grep -v grep | grep -c "stnetp78.sh" ` -ne 0 -o `ps -eaf | grep -v grep | grep -c "stnetp10" ` -ne 0 ]
      then
         clear
         echo;echo;echo;echo;echo;echo;
         echo "\07 Os Programas da rede estão ativos, favor encerrar antes de usar esta opcão"
         echo ""
         echo "\07 TECLE ENTER"
          read nada
         sleep 1
         exit
fi
