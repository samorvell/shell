#############################################################################
# Menu para operacoes de backup                                             #
# Wilson Roberto Cortez                                  versao: 001/03/98  #
# Alterado: Noboru 16/10/97 (separado backup Unix e Oracle).                #
# Alterado: Noboru 07/01/98 (incluido export oracle full=y junto com unix). #
# Alterado: Noboru 03/05/00 (excluido uso do system/telecoteco).            #
# Joao Geraldo de Arruda       versao: 001/04/02 - Unix Sparc Solaris 8 #
# Joao Geraldo de Arruda       versao: 002/04/03 - Unix Sparc Solaris 8 #
#############################################################################
clear
opc=999; msg=" " 
while test $opc -ne 0
do  
#-----------------------------------------------------------------------------#
. $OPERATOR/CABEC_OPERATOR.sh #Rotina para criacao do cabecalho do operator
#-----------------------------------------------------------------------------#
clear;tput rev
  echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA
  tput cup 2 34
  echo "B A C K U P"  
  tput sgr0
  echo
  echo 
      echo "                            $TBOLD 1$TOFF - Backup Fisico Oracle (DIÁRIO)"
      echo "                            $TBOLD 2$TOFF - Backup Fisico Oracle (MENSAL)"
      echo "                            $TBOLD 0$TOFF - Volta ao menu principal"
  tput cup 19 0;                                                      
  echo "                             Opcao Escolhida -->  "  >/dev/tty
  tput cup 19 49;
  read opc  
  echo 
  case $opc in 
      1) clear;
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_ROTINA_DIARIA.sh 
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_ROTINA_REORG.sh
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_REDE.sh
#------------------------------------------------------------------------------#
         ROTINA="./backup.sh";	export ROTINA
         MSG="\07 Executando BACKUP FISICO DIARIO, favor aguardar"; export MSG
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_ROTINA_BACKUP.sh $ROTINA $MSG
#------------------------------------------------------------------------------#

         sudo echo BACKUP > $MS_ARQUIVOS/BLOCK_USER_BACKUP

      echo " ****************** A T E N C A O **********************" >/dev/tty
      echo " Continua BACKUP FISICO DIARIO               ( S/ N)    " >/dev/tty
      echo " ******************************************************* ">/dev/tty
         read RESPOSTA                          
         if [ $RESPOSTA != S -a $RESPOSTA != s ]
            then
               sudo rm -f $MS_ARQUIVOS/BLOCK_USER_BACKUP
               exit
         fi                                     
#------------------------------------------------------------------------------#
          . $OPERATOR/CANCELA_PROCESSOS.sh #Cancela processos ,rede no ar     #
#------------------------------------------------------------------------------#
         if [ VT_RETORNO = 1 ]  #0 = NAO 1 = SIM  
            then                                  
               exit                                 
         fi                                       
#------------------------------------------------------------------------------#
         sudo /etc/init.d/oracle stop  # DESATIVA ORACLE
#------------------------------------------------------------------------------#
         echo "INICIANDO O BACKUP "
        # sudo tar cvfP $MS_DAT /home /home1 >/home/operator/lista.fisico.diario.log
         #sudo tar cvfP - /home | rsh 10.52.254.110 dd of=/dev/rmt/0u obs=20b
         
         sudo /usr/openv/netbackup/bin/bpbackup -p UNX_LAN_LOJAS -s Diario-Full -w /home
         VT_RETORNO=$?
         MSG_BKP_OK="Backup Fisico Diario - OPCAO 1 - OK"            
         MSG_BKP_ERRO="ERRO no Backup Fisico Diario - OPCAO 1 - ERRO"
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_BACKUP.sh $VT_RETORNO
#------------------------------------------------------------------------------#
         sudo /etc/init.d/oracle start  # ATIVA ORACLE
#------------------------------------------------------------------------------#
         echo;;
     2) clear;
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_ROTINA_DIARIA.sh 
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_ROTINA_REORG.sh
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_REDE.sh
#------------------------------------------------------------------------------#
         ROTINA="./backup.sh";	export ROTINA
         MSG="\07 Executando BACKUP FISICO DIARIO, favor aguardar"; export MSG
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_ROTINA_BACKUP.sh $ROTINA $MSG
#------------------------------------------------------------------------------#

         sudo echo BACKUP > $MS_ARQUIVOS/BLOCK_USER_BACKUP

      echo " ****************** A T E N C A O **********************" >/dev/tty
      echo " Continua BACKUP FISICO DIARIO               ( S/ N)    " >/dev/tty
      echo " ******************************************************* ">/dev/tty
         read RESPOSTA                          
         if [ $RESPOSTA != S -a $RESPOSTA != s ]
            then
               sudo rm -f $MS_ARQUIVOS/BLOCK_USER_BACKUP
               exit
         fi                                     
#------------------------------------------------------------------------------#
          . $OPERATOR/CANCELA_PROCESSOS.sh #Cancela processos ,rede no ar     #
#------------------------------------------------------------------------------#
         if [ VT_RETORNO = 1 ]  #0 = NAO 1 = SIM  
            then                                  
               exit                                 
         fi                                       
#------------------------------------------------------------------------------#
         sudo /etc/init.d/oracle stop  # DESATIVA ORACLE
#------------------------------------------------------------------------------#
        # sudo tar cvfP $MS_DAT /home /home1 >/home/operator/lista.fisico.diario.log
         #sudo tar cvfP - /home | rsh 10.52.254.110 dd of=/dev/rmt/0u obs=20b
         
         sudo /usr/openv/netbackup/bin/bpbackup -p UNX_LAN_LOJAS -s Mensal-Full -w /home
         VT_RETORNO=$?
         MSG_BKP_OK="Backup Fisico Diario - OPCAO 1 - OK"            
         MSG_BKP_ERRO="ERRO no Backup Fisico Diario - OPCAO 1 - ERRO"
#------------------------------------------------------------------------------#
         . $OPERATOR/VERIFICA_BACKUP.sh $VT_RETORNO
#------------------------------------------------------------------------------#
         sudo /etc/init.d/oracle start  # ATIVA ORACLE
#------------------------------------------------------------------------------#
         echo;;
    0) clear
       exit;;
    *) echo
       echo "                                Opcao Invalida"
  esac 
  opc=999;echo "Tecle <enter> para continuar";read nada
done
