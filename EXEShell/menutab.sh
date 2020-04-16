############################################################################
#Joao Geraldo de Arruda       versao: 001/04/02 - Unix Sparc Solaris 8     #
############################################################################
# -------------------------- ROTINA CHECA ERRO ----------------------------
RT_CHECA_ERRO ( )                                                          
{                                                                           
  if [ $VT_RETORNO != 0 ]                                                   
     then                                                             
       tput rev                                                                 
       echo;echo;echo;echo;echo;                                           

       echo From: root@MAKRO$LJ > $OPERATOR/EMAIL_REORG
       echo 'To:geraldo@makro.com.br' >> $OPERATOR/EMAIL_REORG
       echo 'cc:noboru@makro.com.br' >> $OPERATOR/EMAIL_REORG
       a='Subject:Reorg. de Tabela - '`date`
       echo $a >> $OPERATOR/EMAIL_REORG 
       echo "Erro no reorg da tabela" $TABELA >> $OPERATOR/EMAIL_REORG
       cat $OPERATOR/tmp/$TABELA\_$ARG.log >> $OPERATOR/EMAIL_REORG
       cat $OPERATOR/status.$TABELA >> $OPERATOR/EMAIL_REORG
       cat $OPERATOR/EMAIL_REORG >$OPERATOR/ERRO_$TABELA 
       cat $OPERATOR/EMAIL_REORG | /usr/lib/sendmail geraldo@makro.com.br

       echo " \07 Erro no reorg da tabela $TABELA, favor verificar       (Tecle Enter)"  >/dev/tty

       read nada

       tput sgr0                                                                
       VT_RETORNO='0';
       exit                                                      
  fi                                                                        
}                                                                           
# -------------------------- VERIFICA STATUS -------------------------------#
RT_CHECA_STATUS ( )                                                   
# --------------------------------------------------------------------------#
{
LINHA1='';
CONT="0";
        if [ -s $OPERATOR/status.$TABELA ]
           then 
              for ARG in $LINHA
              do
              if test `grep -c < $OPERATOR/status.$TABELA "$ARG" ` -ge 1
                 then 
                     echo                
              else 
                 if [ "$ARG" = "DROP_TABLE.sql" -o "$ARG" = $TABELA"_CT.sql" -o "$ARG" = "IMPORT.sh" ]
                    then 
                    if [ "$CONT" = "0" ]
                    then
                    LINHA1=$LINHA1" DROP_TABLE.sql "$TABELA"_CT.sql IMPORT.sh"
                    CONT=`expr $CONT + 1 `
                    continue
                    fi
                 continue
                 fi
                 LINHA1=$LINHA1' '$ARG
              fi
              done
        else         
        rm $OPERATOR/status.$TABELA"_OK" > /dev/null 2>&1
        LINHA1=$LINHA
        fi 
        LINHA=$LINHA1

        RT_REORG
}
# -------------------------- ROTINA REORGANIZAGAO --------------------------#
RT_REORG ( )                                                          
# --------------------------------------------------------------------------#
{
       for ARG in $LINHA
       do
       if [ $ARG = EXPORT.sh -o $ARG = IMPORT.sh ]
          then 
       sh $REORG/$ARG $TABELA
       VT_RETORNO=$?; RT_CHECA_ERRO
       cat $OPERATOR/tmp/$TABELA\_$ARG.log >>$OPERATOR/status.$TABELA
       echo '#PARM = '$ARG OK >>$OPERATOR/status.$TABELA
          else
       $ORACLE_HOME/bin/sqlplus -s ops\$storep/ops\$storep @$REORG/$ARG $TABELA >$OPERATOR/tmp/$TABELA\_$ARG.log
       VT_RETORNO=$?; 
 
       case $VT_RETORNO in               
       152) VT_RETORNO="0";;   #drop table or view does not exist
       174) VT_RETORNO="0";;   #drop public synonym dos not exist
       187) VT_RETORNO="0";;   #index ou tabela ja existente
         *)                             
       esac                               
 
       RT_CHECA_ERRO

       cat $OPERATOR/tmp/$TABELA\_$ARG.log >>$OPERATOR/status.$TABELA
       echo '#PARM = '$ARG OK >>$OPERATOR/status.$TABELA
       fi
       done                           

       mv $OPERATOR/status.$TABELA $OPERATOR/status.$TABELA"_OK"
       rm -f $MS_ARQUIVOS/$TABELA.dmp
}
###############################################################################
USER="ops\$storep/ops\$storep"
clear
opc=999; msg=" " 
while test $opc -ne 0
do  
. CABEC_OPERATOR.sh # cria cabecalho                                            
  clear;tput rev
  echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA
  tput cup 2 18
  echo "R E O R G A N I Z A Ç Ã O   D E   T A B E L A"
  tput sgr0
  echo 
  echo 
     echo "                             $TBOLD 1$TOFF - REORG. DE TABELA"
     #echo "                             $TBOLD 2$TOFF - REORG. SEGUNDA FEIRA" 
     #echo "                             $TBOLD 3$TOFF - REORG. TERCA FEIRA" 
     #echo "                             $TBOLD 4$TOFF - REORG. QUARTA FEIRA" 
     echo "                             $TBOLD 5$TOFF - VERIFICA STATUS "       
     echo "                             $TBOLD 0$TOFF - VOLTA AO MENU PRINCIPAL"
     tput cup 19 0;                                                      
     echo "                             Opcao Escolhida -->  "  >/dev/tty
     tput cup 19 49;                                                     
  read opc  
  case $opc in
       ERRO) ;; 
       1)echo;
#------------------------------------------------------------------------------#
        . $OPERATOR/VERIFICA_ROTINA_DIARIA.sh                                  
#------------------------------------------------------------------------------#
        . $OPERATOR/VERIFICA_REDE.sh                                  
#------------------------------------------------------------------------------#
        ROTINA="./backup.sh";  export ROTINA                                 
        MSG="\07 Executando BACKUP FISICO DIARIO, favor aguardar"; export MSG
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_ROTINA_BACKUP.sh                                  
#------------------------------------------------------------------------------#

        echo BACKUP > $MS_ARQUIVOS/BLOCK_USER_REORG
        /etc/init.d/oracle start #Ativa banco de dados                 
        clear

        echo "Informe o nome da tabela" >/dev/tty
        read TABELA                                                         
        export TABELA
        clear
        LINHA=`grep -w "$TABELA" $OPERATOR/TABELAS_GERAL | cut -f2-22 -d " "`
        if [ -z "$LINHA" ]                                                   
           then                                                              
           tput rev
           echo;echo;echo;echo;echo;                                           
           echo " \07 Tabela não existente, favor verificar  (Tecle Enter)"  >/dev/tty
           read nada
           tput sgr0
           rm -f $MS_ARQUIVOS/BLOCK_USER_REORG
           exit
        fi                                                                   
        echo $LJ \(Reorganização Tabela $TABELA - Inicio\) `date` `tty` >> $OPERATOR/LOG.OPERATOR
        RT_CHECA_STATUS # verifica status, chama rotina de reorganizacao    #
        rm -f $MS_ARQUIVOS/BLOCK_USER_REORG
        echo $LJ \(Reorganização Tabela $TABELA - Fim\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
     #  2)echo;
#------------------------------------------------------------------------------#
     #   . $OPERATOR/VERIFICA_ROTINA_DIARIA.sh                                  
#------------------------------------------------------------------------------#
     #   . $OPERATOR/VERIFICA_REDE.sh                                  
#------------------------------------------------------------------------------#

     #   ROTINA="./backup.sh";  export ROTINA                                 
     #   MSG="\07 Executando BACKUP FISICO DIARIO, favor aguardar"; export MSG
#------------------------------------------------------------------------------#
     #    . $OPERATOR/VERIFICA_ROTINA_BACKUP.sh                                  
#------------------------------------------------------------------------------#

     #   echo BACKUP > $MS_ARQUIVOS/BLOCK_USER_REORG
     #   /etc/init.d/oracle start #Ativa banco de dados                 
     #   clear

     #   a=`cat TABELAS_SEGUNDA`
     #   for TABELA in $a
     #   do
     #   export TABELA
     #   LINHA=`grep -w "$TABELA" $OPERATOR/TABELAS_GERAL | cut -f2-22 -d " "`
     #   echo $LJ \(Reorganização de Segunda $TABELA inicio \) `date` `tty` >> $OPERATOR/LOG.OPERATOR
     #   RT_CHECA_STATUS # verifica status, chama rotina de reorganizacao    #
     #   echo $LJ \(Reorganização de Segunda $TABELA Fim \) `date` `tty` >> $OPERATOR/LOG.OPERATOR
     #   done
     #   rm -f $MS_ARQUIVOS/BLOCK_USER_REORG
     #   echo $LJ \(Reorganização de Segunda executada com Sucesso \) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
     # 3)echo
#------------------------------------------------------------------------------#
     #   . $OPERATOR/VERIFICA_ROTINA_DIARIA.sh                                  
#------------------------------------------------------------------------------#
     #   . $OPERATOR/VERIFICA_REDE.sh                                  
#------------------------------------------------------------------------------#
     #   ROTINA="./backup.sh";  export ROTINA                                 
     #   MSG="\07 Executando BACKUP FISICO DIARIO, favor aguardar"; export MSG
#------------------------------------------------------------------------------#
     #    . $OPERATOR/VERIFICA_ROTINA_BACKUP.sh                                  
#------------------------------------------------------------------------------#


     #   echo BACKUP > $MS_ARQUIVOS/BLOCK_USER_REORG
     #   /etc/init.d/oracle start #Ativa banco de dados                 
     #   clear

     #   a=`cat TABELAS_TERCA`
     #   for TABELA in $a
     #   do
     #   export TABELA
     #   LINHA=`grep -w "$TABELA" $OPERATOR/TABELAS_GERAL | cut -f2-22 -d " "`
     #   echo $LJ \(Reorganização de Terça $TABELA inicio \) `date` `tty` >> $OPERATOR/LOG.OPERATOR
     #   RT_CHECA_STATUS # verifica status, chama rotina de reorganizacao    #
     #   echo $LJ \(Reorganização de Terça $TABELA fim \) `date` `tty` >> $OPERATOR/LOG.OPERATOR
     #   done
     #   rm -f $MS_ARQUIVOS/BLOCK_USER_REORG
     #   echo $LJ \(Reorganização de Terça executada com Sucesso \) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
     #4) echo
#------------------------------------------------------------------------------#
     #   . $OPERATOR/VERIFICA_ROTINA_DIARIA.sh                                  
#------------------------------------------------------------------------------#
     #   . $OPERATOR/VERIFICA_REDE.sh                                  
#------------------------------------------------------------------------------#
     #   ROTINA="./backup.sh";  export ROTINA                                 
     #   MSG="\07 Executando BACKUP FISICO DIARIO, favor aguardar"; export MSG
#------------------------------------------------------------------------------#
     #    . $OPERATOR/VERIFICA_ROTINA_BACKUP.sh                                  
#------------------------------------------------------------------------------#

     #   echo BACKUP > $MS_ARQUIVOS/BLOCK_USER_REORG
     #   /etc/init.d/oracle start #Ativa banco de dados                 
     #   clear

     #   a=`cat TABELAS_QUARTA`
     #   for TABELA in $a
     #   do
     #   export TABELA
     #   LINHA=`grep -w "$TABELA" $OPERATOR/TABELAS_GERAL | cut -f2-22 -d " "`
     #   echo $LJ \(Reorganização de Quarta $TABELA inicio \) `date` `tty` >> $OPERATOR/LOG.OPERATOR
     #   RT_CHECA_STATUS # verifica status, chama rotina de reorganizacao    #
     #   echo $LJ \(Reorganização de Quarta $TABELA inicio \) `date` `tty` >> $OPERATOR/LOG.OPERATOR
     #   done
     #   rm -f $MS_ARQUIVOS/BLOCK_USER_REORG
     #   echo $LJ \(Reorganização de Quarta executada com Sucesso \) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
     5) clear;echo;echo -n "DIGITE O NOME DA TABELA ==> " ; read TAB
             if [ -z "$TAB" ]                                            
                    then                                                     
                      echo;echo "NOME DE TABELA INVALIDO"                  
                      opc=ERRO                                             
                   else                                                     
                if test `grep -c $TAB TABELAS_GERAL` = 0                    
                      then                                               
                      echo;echo "TABELA INEXISTENTE !!!"                 
                      opc=ERRO                                           
                   else                                                     
                   more $OPERATOR/status.$TAB
                fi
             fi
        echo $LJ \(Verificacao de Status\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
     0) clear;
	exit;;
     *) echo
        echo "                                Opcao Invalida";;
  esac
  opc=999;echo;echo "Tecle <enter> para continuar";read nada
done
