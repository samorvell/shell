et###############################################################################
# Menu para restauracao de arquivos                    antes: 001/01/99        #
# Wilson R. Cortez/Alterado p/ Marco A. Ribeiro versao atual: 001/09/99        #
# Joao Geraldo de Arruda       versao: 001/04/02 - Unix Sparc Solaris 8        #
# Noboru                       versao: 001/02/03 - Opcao para remover arq.FISCO#
################################################################################
clear
opc=999
while test $opc -ne 0
do  
#-----------------------------------------------------------------------------#
. $OPERATOR/CABEC_OPERATOR.sh #criacao do cabecalho do operator                
#-----------------------------------------------------------------------------#
  clear;tput rev
  echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA
  tput cup 2 33
  echo "R E S T O R E" 
      tput sgr0
  echo
  echo 
  echo "                         $TBOLD 1$TOFF - Verificar o conteudo dos Backups" 
  echo "                         $TBOLD 2$TOFF - Restaurar Arquivos"
  echo "                         $TBOLD 0$TOFF - Volta ao menu principal"
  echo
  echo
  echo -n '                          Opcao Escolhida --> '
  read opc  
  echo 
  case $opc in 
    1) clear;
       while
       echo ' INFORME O TIPO DE BACKUP:';
       echo '                           Para Backup do Rb00 = <rb00>';
       echo '                           Para Backup Suporte Técnico = <sup>';
       read tipo 
       do 
       clear
       case $tipo in
            rb00) COMANDO="cpio -icBt < $MS_DAT | more"
                  break;;
             sup) COMANDO="tar tvf $MS_DAT"
                  break;;
               *)                                          
               ;;                                         
       esac 
       done
       cd $OPERATOR
       echo $COMANDO
       echo $LJ \(Verificou Conteudo\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
    2) clear
       while
       echo "Que tipo de arquivo deseja restaurar:"
       echo "                                      Arquivos = <A>" 
       echo "                                      Fisco = <F>"
       echo "                                      Forms = <M>"
       echo "                                      Relatorios = <R>" 
       echo "                                      Programas = <P>"
       echo "                                      Shell script = <S>"
	read resp
        do
	case $resp in
		A|a) DIR="$MS_ARQUIVOS/"
	    	    	show="ARQUIVO(S)";break;;
		F|f) DIR="$MS_FISCO/"
			show="ARQUIVO(S) DO FISCO";break;;
		M|m) DIR="$MS_FORMS60/"
			show="ARQUIVO(S) DO FORMS";break;;
	  	R|r) DIR="$MS_RELATORIOS/"
			show="RELATORIO(S)";break;;
	  	P|p) DIR="$MS_PROGS/"
			show="PROGRAMA(S)";break;;
	  	S|s) DIR="$MS_SHELL/"
			show="SHELL SCRIPT(S)";break;;
                  *)                                          
                  ;;                                         
	esac
        done                                                        
          echo $show
          read nada;;
    0) clear
       exit;;
    *) echo
       echo "                                Opcao Invalida";;
  esac 
  opc=999;echo "Tecle <enter> para continuar ";read nada
done
