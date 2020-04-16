#--------------------------------------------------------------------------#
#VERIFICA_ROTINA_BACKUP DIARIA E MENSAL
#--------------------------------------------------------------------------#
if [ -r $MS_ARQUIVOS/BLOCK_USER_BACKUP ]
   then 
      if test `ps -eaf | grep -v grep | grep -c "$ROTINA"` -ge 1
         then
            if test `ps -eaf | grep tar | grep -c "/dev/rmt/0u"` = 1
               then
                   clear
                   echo;echo;echo;echo;echo;
                   echo $MSG >/dev/tty
                   echo                      
                   echo "\07 ( TECLE ENTER )"
                   read nada                 
                   sleep 1                   
                   exit                      
             fi
      fi
fi
