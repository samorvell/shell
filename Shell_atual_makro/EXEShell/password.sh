###################################################################
# Menu para alteracao de passwords                                #
# Wilson Roberto Cortez                        versao: 001/03/98  #
# Alterado em 07/07/2000 - MARCO               versao: 001/07/00  #
# Joao Geraldo de Arruda       versao: 001/04/02 - Unix Sparc Solaris 8 #
###################################################################
clear
status=nok
echo   "MUDANCA DE PASSWORD "                  
echo 
echo -n "USERID A SER ALTERADO ==> ";read USER
if [ -z "$USER" ]
   then
   exit
else
   case $USER in
	alc) status=ok;;
	cfi) status=ok;;
	concli) status=ok;;
	contab) status=ok;;
	gerali) status=ok;;
	gernal) status=ok;;
	mb) status=ok;;
	operator) status=ok;;
	rb00) status=ok;;
	rcp) status=ok;;
	rm) status=ok;;
	tlv) status=ok;;
	storep) status=ok;;
   esac
       if [ $status != "ok" ]
          then
              echo
              echo "USUARIO INEXISTENTE ou NAO AUTORIZADO para Alterar" 
              echo 
              echo "tecle <ENTER> para encerrar."; read nada
              echo $LJ \(NAO Alterado Password - Usuario Inexistente ou Nao Autorizado:"$USER"\) `date` `tty` >> $OPERATOR/LOG.OPERATOR
              exit 
       else
              sudo passwd $USER
              sudo passwd -x 30 $USER
              clear
              echo
              echo
              echo "A senha do usuario $USER foi alterada com sucesso" 
              echo 
              echo "tecle <ENTER> para encerrar."; read nada
              echo $LJ \(Alterado o usuario:"$USER"\) `date` `tty` >> $OPERATOR/LOG.OPERATOR
       fi
fi
