##############################################################################
#    Menu para Inclusao e/ou Alteracao de Impressoras, utilizando Samba      #
#    Marco Antonio Ribeiro       versao: 001/12/03 - Unix Sparc Solaris 8    #
##############################################################################
tela=999
while test $tela -ne 0
do 
#-----------------------------------------------------------------------------#
. $OPERATOR/CABEC_OPERATOR.sh #criacao do cabecalho do operator
#-----------------------------------------------------------------------------#
      clear;tput rev
      echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA
      tput cup 2 23
      echo "Manutencao das I M P R E S S O R A S" 
      tput sgr0
      echo
      echo "                           $TBOLD  1$TOFF - Inclusao / Alteracao "
      echo "                           $TBOLD  2$TOFF - Exlusao de Impressora"
      echo "                           $TBOLD  3$TOFF - Lista Impressoras"
      echo
      echo "                           $TBOLD  0$TOFF - Volta ao menu principal"
      tput cup 23 0;echo "Mensagens:\c"
      tput cup 10 29;echo "Opcao Escolhida -->"  
      tput cup 10 49; read opc  
      case $opc in 
         1) clear;rot=0
	    while test $rot -eq 0
	    do
            #------------------------------------------------------------------#
            . $OPERATOR/CABEC_OPERATOR.sh #criacao do cabecalho do operator
            #------------------------------------------------------------------#
            	clear;tput rev
            	echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA
            	tput sgr0
	    	echo;echo
            	echo "                         Inclusao / Alteracao de Impressoras"
                tput cup 23 0;echo "Mensagens:\c"
            	tput cup 2 29
	    	tput cup 5 5; echo "Nome da Impressora ==>" 
	    	tput cup 5 28; read resp
	    	if [ -n "$resp" ]
	           then
	           IMP=`echo $resp |tr "[a-z]" "[A-Z]" `
	           valida=` cat defimp.txt`;status=nok
	           for i in $valida
	           do
	           if [ "$IMP" = "$i" ]
		      then
		      status=ok
		   fi
	          done
	          if [ "$status" != "ok" ]
		     then
		     tput cup 23 13; echo "Nome digitado INVALIDO !!!\c"
		     sleep 3
	          else
                     dir=/etc/cups/ppd/$IMP.ppd
                     if [ -f "$dir" ]
                        then
		        tput cup 23 13; echo "Impressora Ja EXISTENTE !!!   Sera ALTERADA\c"
		        procedimento=ALTERA
		     else
                        tput cup 23 13; echo $IMP" NAO EXISTE !!! Sera incluida\c"
		        procedimento=INCLUI
		     fi
		     tput cup 7 5; echo "Digite o Nome do COMPARTILHAMENTO (WINDOWS):"
		     tput cup 7 53; read COMP
		     tput cup 9 5; echo "Digite o Nome do Micro (Servidor de Impressao):"
		     tput cup 9 53; read MICRO
		     if [ -n "$MICRO" ]
			then
			tput cup 15 5; echo $procedimento "a Impressora "$IMP" ? (s,<n>): \c"
			read sn 
			if [ "$sn" = "s" -o "$sn" = "S" ]
			   then
                           sudo lpadmin -p $IMP -E -v smb://$MICRO/$COMP -P /usr/share/cups/model/textonly.ppd -o printer-error-policy=retry-job

			   if [ "$procedimento" = "ALTERA" ]
			      then
			      sudo lpadmin -x $IMP
			   fi

                           sudo lpadmin -p $IMP -E -v smb://$MICRO/$COMP -P /usr/share/cups/model/textonly.ppd -o printer-error-policy=retry-job

                        if [ $IMP = "XEROX" ]
                           then
                           sudo lpadmin -p XEROX -E -v socket://171.6.0.100 -P /usr/share/cups/model/textonly.ppd -o printer-error-policy=retry-job
                           sudo lpadmin -d XEROX
#                          sudo lpoptions -d XEROX >/dev/null 2>&1
                        fi
                           sudo accept $IMP
                           sudo cupsenable $IMP
		           tput cup 23 13; echo "\07 OK ..... Impressora: "$IMP"                      \c"
			   sleep 2
                           echo $LJ \($procedimento $IMP\) `date` `tty` >> $OPERATOR/LOG.OPERATOR
			fi
		     fi
		  fi
	    else
	    rot=999
            fi
	    done;;
         2) clear;rot=0
	    while test $rot -eq 0
	    do
            #------------------------------------------------------------------#
            . $OPERATOR/CABEC_OPERATOR.sh #criacao do cabecalho do operator
            #------------------------------------------------------------------#
            	clear;tput rev
            	echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA
            	tput sgr0
	    	echo;echo
	    	tput rev
            	tput cup 2 25; echo "EXCLUSAO\c";tput sgr0;echo " De Impressoras"
                tput cup 23 0;echo "Mensagens:\c"
	    	tput cup 5 5; echo "Nome da Impressora ==> "
	    	tput cup 5 28; read resp
	    	if [ -n "$resp" ]
		   then
	           IMP=`echo $resp |tr "[a-z]" "[A-Z]"`
	           valida=`cat defimp.txt`;status=nok
	           for i in $valida
	           do
	           if [ "$IMP" = "$i" ]
		      then
		      status=ok
		   fi
	           done
	           if [ "$status" != "ok" ]
		      then
		      tput cup 23 13; echo "Nome digitado INVALIDO !!!\c"
		      sleep 3
	           else
                      dir=/etc/cups/ppd/$IMP.ppd
                      if [ -f "$dir" ]
		         then
		         tput cup 15 5; echo "Excluir a Impressora "$IMP" ?? (s,<n>): \c"
		         read sn 
		         if [ "$sn" = "s"  -o "$sn" = "S" ]
		            then
		            sudo cupsdisable $IMP
			    sudo reject $IMP  
			    sudo lpadmin -x $IMP
		            tput cup 23 13; echo "Impressora=> "$IMP" EXCLUIDA!!!\c"
			    sleep 2
                            echo $LJ \(Excluida Impressora: $IMP\) `date` `tty` >> $OPERATOR/LOG.OPERATOR
		         fi
		      else
                          tput cup 23 13; echo "A Impressora $IMP NAO EXISTE !!!\c"
		          sleep 2
		      fi
                   fi
	        else
	           rot=999
                fi
	    done;;
         3) clear
            #------------------------------------------------------------------#
            . $OPERATOR/CABEC_OPERATOR.sh #criacao do cabecalho do operator
            #------------------------------------------------------------------#
            tput rev
            echo "     " $RAZAO "      " $LOJA "   " $DIA_SEM $DIA $MES $ANO $HORA
            tput sgr0
	    echo;echo
            tput cup 2 25; echo "Listagem de Impressoras"
            tput cup 23 0;echo "Mensagens:\c"
	    tput cup 5 0
            dir=/etc/cups/ppd
            ls $dir | cut -f1 -d "."
	    tput cup 23 13; echo "Digite <enter> para continuar\c"
	    read cont
            echo $LJ \(Listou Impressoras\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
         0) tela=0
	    clear;exit;;
         *) tput cup 23 13; echo "Opcao Invalida...!!! \c";sleep 2;;
      esac 
done
exit
