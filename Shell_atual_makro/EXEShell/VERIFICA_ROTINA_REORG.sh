#--------------------------------------------------------------------------#
#VERIFICA_ROTINA_REORG
#--------------------------------------------------------------------------#
if [ -r $MS_ARQUIVOS/BLOCK_USER_REORG ]
   then 
      if test `ps -eaf | grep -v grep | grep -c "./oracle8.sh"` -ge 1
         then
          if test `ps -eaf | grep -v grep | grep -c "./menutab.sh"` -ge 1
               then
                   clear
                   echo;echo;echo;echo;echo;
                   echo "\07 Executando REORGANIZAÇÃO DE TABELAS, Aguarde o término."
                   echo                      
                   echo "\07 ( TECLE ENTER )"
                   read nada                 
                   sleep 1                   
                   exit                      
             fi
      fi
fi
