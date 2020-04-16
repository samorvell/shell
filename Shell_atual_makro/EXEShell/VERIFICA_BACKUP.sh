#-----------------------------------------------------------------------------#
#ROTINA PARA VERIFICACAO DO BACKUP                                             
#-----------------------------------------------------------------------------#
       if test $VT_RETORNO = 0
            then
       banner $MSG_BKP_OK | lp -d XEROX
       clear
       echo $LJ \($MSG_BKP_OK\) `date` `tty` >> $OPERATOR/LOG.OPERATOR
       echo;echo;echo;echo;echo;echo;
       echo " \07 *****************  A T E N C Ã O     **************" >/dev/tty
       echo;   
       echo " \07 $MSG_BKP_OK "                                        >/dev/tty
       echo;   
       echo " \07 Tecle Enter para prosseguir"
       echo;   
       echo " \07 *****************  A T E N C Ã O     **************" >/dev/tty
       /usr/bin/rm -f $MS_ARQUIVOS/BLOCK_USER_BACKUP >/dev/null 2>&1
       read nada
       else
       banner $MSG_BKP_ERRO | lp -d XEROX
       clear
       echo $LJ \($MSG_BKP_ERRO\) `date` `tty` >> $OPERATOR/LOG.OPERATOR
       echo;echo;echo;echo;echo;echo;
       tput rev
       echo " \07 *****************  A T E N C Ã O     **************" >/dev/tty
       echo;   
       echo " \07 $MSG_BKP_ERRO"                                       >/dev/tty
       echo;   
       echo " \07 Avisar o Suporte Técnico no Horário Comercial"       >/dev/tty
       echo;   
       echo " \07 Tecle Enter para prosseguir"
       echo;   
       echo " \07 *****************  A T E N C Ã O     **************" >/dev/tty
       tput sgr0
            read nada
       echo " BACKUP COM ERRO" >>/$OPERATOR/$LISTA.log
       /usr/bin/rm -f $MS_ARQUIVOS/BLOCK_USER_BACKUP >/dev/null 2>&1
       fi
