#!/bin/ksh                                                                     
################################################################################
#                             rt_emporium.sh                                   #
################################################################################
#            Shell para execucoes arquivos emporium           	               #
################################################################################
# Usage: rt_emporium.sh <start|stop|check>                                     #
################################################################################
#  REVISIONS:                                                                  #
#  Ver       Date         Author           Description                         #
#  --------- ----------   ---------------  -------------------------           #
#  1.0:                                                                        #
#  1.1:      13/02/2013   rcordeiro(cit)   Demanda 284955->MKR-2171            #
#                                          Inclusao da chamada para            #
#              u                            geracao e leitura do                #
#                                          arquivo da comanda                  #
#  1.2:      15/02/2013   Alvaro Melo      Parametrizar IP e HOST              #
#                                                                              #
#  1.3:      15/10/2013   Alvaro Melo      Chamar aplica豫o de impressoao via  #
#                                          Coletor de dados                    #
#                                                                              #
################################################################################
                                                                               
# DEBUG=1 ; export DEBUG                                                       #

if [ ${DEBUG:=0} = 1 ]
then
   set -x
fi


if [ $# -lt 1 ]
then
   echo Usage: $0 ' <start/stop/check> '
   exit 1
fi

#-------------------------- registrar date no log -------------------------------#
date

#-------------------------------- SET AMBIENTE ----------------------------------#
. /home/store/bin/environment.sh
#CRIAR VARIAVEIS LOCAIS
. $MS_PROGS/get_variables.sh rt_prc_empor
if [ ${DEBUG:=0} = 1 ]
then
   set -x
fi

VT_EMPLOG=$VS_DIRLOG/transcribo$VS_DIAJUL.log
VT_TRALOG=$VS_DIRLOG/transcribo_exe$VS_DIAJUL.log
VT_DIRWRK=/home/work
VT_EMPLOJ=`echo $VS_LOJ| awk '{ printf("%04d\n",$1) }'`/   #LOJA COM 4 DIGITOS
VT_EMPLOJ2=`echo $VS_LOJ| awk '{ printf("%04d\n",$1) }'`   #LOJA COM 4 DIGITOS
VT_EMPBAS=$VT_DIRWRK/EMPORIUM
VT_EMPSND=$VT_DIRWRK/EMPORIUM/SND/
VT_EMPRCV=$VT_DIRWRK/EMPORIUM/RCV/
VT_HYSRCV=$VT_DIRWRK/EMPORIUM/RCV_HISTORY/
VT_HYSSND=$VT_DIRWRK/EMPORIUM/SND_HISTORY/
VT_BADRCV=$VT_DIRWRK/EMPORIUM/RCV_BAD/
VT_PORSND=10`echo $VS_LOJ| awk '{ printf("%03d\n",$1) }'` #8906        #VERIFICAR QUAL A REGRA PARA DEMAIS LOJAS !!!! #
VT_PORRCV=11`echo $VS_LOJ| awk '{ printf("%03d\n",$1) }'` #8806
VT_LOGIN=$MS_LIST/log/dissemino_output$VS_DIAJUL.log
VT_LOGOUT=$MS_LIST/log/dissemino_input$VS_DIAJUL.log

DELAY=1; export DELAY
VL_DTMV=`date| awk '{ printf("%08s\n",$4) }'`



#----------------------------- PREPARA AMBIENTE ----------------------------------#
chmod 777 $VT_EMPLOG >/dev/null 2>/dev/null
VT_AMB=`uname -n|cut -c1-5`
if [ `uname -n` = "MAKRO88" -o `uname -n` = "MAKRO77" -o $VT_AMB = 'BRSHL' -o $VT_AMB = 'BRSDL' ]
then
	if [ -z "$VT_HOST_DES" -o -z "$VT_PORT_DES" ]
	then
		VT_IPEMP="NAO-CADASTRADO-SYPARSEL"
		VT_PORDIS="NAO-CADASTRADO-SYPARSEL"
	else
		VT_IPEMP=$VT_HOST_DES
		VT_PORDIS=$VT_PORT_DES
	fi
else
	VT_IPEMP=BRSPCLJ01 ###########################
	VT_PORDIS=10000
fi

if [ ! -d $VT_DIRWRK/EMPORIUM ]
then
	mkdir $VT_DIRWRK/EMPORIUM
	chmod 777 $VT_DIRWRK/EMPORIUM
fi

for dir in $VT_EMPSND $VT_EMPRCV $VT_HYSRCV $VT_BADRCV $VT_HYSSND
do
	if [ ! -d $dir ]
	then
		mkdir $dir
		chmod 777 $dir
	fi
	if [ ! -d $dir$VT_EMPLOJ ]
	then
		mkdir $dir$VT_EMPLOJ
		chmod 777 $dir$VT_EMPLOJ
	fi
done
#---------------------------------------------------------------------------------#




case $1 in
 'start')
	
	#------------------------ CHECA ROTINA DE FECHAMENTO ESTA RODANDO ------------------------#
        if [ -r $MS_ARQUIVOS/BLOCK_USER ]
        then
		echo "       ROTINA DE FECHAMENTO DE LOJA EM EXECUCAO, AGUARDE TERMINO  !!!!!!!"
		if [ ${VL_RESTART:=0} = 0 ] 
		then
		   read x
		fi
		exit
        fi

	#------------------------ CHECA USUARIO QUE ESTA INICIANDO ------------------------#
	VL_STOREP=`id | grep "(storep)" | grep -v grep |wc -l`
        if [ $VL_STOREP = 0 ]
        then
		echo "       SOMENTE USUARIO STOREP PODE INICIAR A REDE  !!!!!!!"
		if [ ${VL_RESTART:=0} = 0 ] 
		then
		   read x
		fi
		exit
        fi
        

	#------------------------ CHECA ESTE PROGRAMA J� EST� EM EXECU플O ------------------------#
	ps -ef | grep $0 | grep -v grep | grep -v $$ >/dev/null 2>/dev/null
	VT_RET=$?
	if [ $VT_RET = 0 ]
	then
		echo "                REDE JA ESTA ATIVA !!!!!!!"
		if [ ${VL_RESTART:=0} = 0 ] 
		then
		   read x
		fi
		exit
	fi

	touch /home/store/admin/restart_rede.run
	chmod 777 /home/storeprod/nohup.out
	
	while true
	do
		date
		sh $MS_PROGS/rt_prc_etiquetap10.sh 
		#----------------------------- ATIVA DISSEMINO ----------------------------------#
		EMP=`ps -aef | grep dissemino | grep -v grep | grep -c dissemino`
		echo $EMP  
		
		if [ -s ${VT_LOGOUT} ]
		then
    	VT_ERRO1=`grep "resultado do bloco: -8" ${VT_LOGOUT} |wc -l`
    else
    	VT_ERRO1=0
    fi
    
		if [ -s ${VT_LOGOUT} ]
		then
      VT_ERRO2=`grep "Sem resposta no bloco" ${VT_LOGOUT} |wc -l`
    else
    	VT_ERRO2=0
    fi

		if [ -s ${VT_LOGIN} ]
		then
       VT_ERRO3=`grep "11-Resource temporarily unavailable" ${VT_LOGIN} |wc -l`
    else
    	 VT_ERRO3=0
    fi
                                                                                                 
    #LOG
  	date >> /tmp/status_diss.log
    echo "${EMP:=0}  ${VT_ERRO1:=0}  ${VT_ERRO2:=0}  ${VT_ERRO3:=0}" >> /tmp/status_diss.log
	  
		if [ ${EMP:=0} = 0  -o ${VT_ERRO1:=0} -gt 30 -o ${VT_ERRO2:=0} -gt 30 -o ${VT_ERRO3:=0} -gt 30 ]
		then
			  date >> /tmp/status_diss.log
			  echo "${EMP:=0}  ${VT_ERRO1:=0}  ${VT_ERRO2:=0}  ${VT_ERRO3:=0}" >> /tmp/status_diss.log
				# MATAR TODOS OS PROCESSOS
				ps -ef | grep dissemino | grep -v grep | while read RECORD
				do
					echo $RECORD | while read USER PROCID PPROCID ROMMEL
					do
						echo Finalizado  $PROCID dissemino  >/dev/tty
						killpid  $PROCID
						echo $PROCID
					done
				done
				echo "$MS_PROGS/ct_dissemino.sh $VT_EMPLOJ2 $VT_PORDIS $VT_IPEMP $VT_EMPSND$VT_EMPLOJ $VT_EMPRCV$VT_EMPLOJ $VT_EMPBAS $VT_LOGIN $VT_LOGOUT $MS_ARQUIVOS/dissemino.xml" >> /tmp/status_diss.log
				$MS_PROGS/ct_dissemino.sh $VT_EMPLOJ2 $VT_PORDIS $VT_IPEMP $VT_EMPSND$VT_EMPLOJ $VT_EMPRCV$VT_EMPLOJ $VT_EMPBAS $VT_LOGIN $VT_LOGOUT $MS_ARQUIVOS/dissemino.xml >> /tmp/status_diss.log 2>> /tmp/status_diss.log
	        		
	  		if [ $VT_ERRO1 -gt 30 -o $VT_ERRO2 -gt 30 ]
	  		then
	           mv $VT_LOGOUT $VT_LOGOUT.$$
        fi
	  		if [ $VT_ERRO3 -gt 30 ]
	  		then
	           mv $VT_LOGIN $VT_LOGIN.$$
	      fi
	      /home/store/bin/dissemino --dissemino-control=$MS_ARQUIVOS/dissemino.xml --trace=$MS_LIST/log/dissemino.$VS_DIAJUL.log --debug-level=9 > $MS_LIST/log/dissemino_start.$VS_DIAJUL.log 2> $MS_LIST/log/dissemino_start.$VS_DIAJUL.log
		else
			echo  "DISSEMINO ESTA ATIVO"
		fi

		#----------------------------- LOADER DE TRANSACOES  ----------------------------------#
		for RCV in $VT_EMPRCV$VT_EMPLOJ*          #$VS_DIRTRN
		do
			if [ -s $RCV ]
			then
				VT_ARQRCV=`basename $RCV`
				echo $RCV

					# executa loader (shvldr)
					VS_DIRTRN=$VT_EMPRCV$VT_EMPLOJ; export VS_DIRTRN

					$MS_PROGS/shvldr.sh  $VS_ORAPWD $VT_ARQRCV  vemp_ticket
					VT_RET=$?

					if [ $VT_RET != 0 -o -s $VS_DIRARQ/vemp_ticket.bad ]
					then
					        VT_RET=0
					        #TESTA SE ESTA DUPLICADO
					        VT_DUP=`grep "ORA-00001" $VS_DIRARQ/vemp_ticket.log |wc -l | awk '{ printf("%s\n",$1) }'`
					        if [ $VT_DUP != 0 ]
					        then
					                mv -f   $RCV   $VT_HYSRCV$VT_EMPLOJ$VT_ARQRCV.$VL_DTMV.DUP
					                VT_RET=1
					        fi

                  #TESTA SE EXISTE REGISTRO DESPREZADO QUE NAO SEJA TRANSA플O (SUJEIRA)
					        if [ -s $VS_DIRARQ/vemp_ticket.bad -a $VT_RET = 0 ]
					        then
        					        VT_DIS=`grep "|" $VS_DIRARQ/vemp_ticket.bad |wc -l | awk '{ printf("%s\n",$1) }'`
        					        if [ $VT_DIS = 0 ]
        					        then
        					                mv -f   $RCV   $VT_HYSRCV$VT_EMPLOJ$VT_ARQRCV.$VL_DTMV.DIS
        					                VT_RET=1
        					        else
                					        mv -f $VS_DIRARQ/vemp_ticket.bad $VS_DIRARQ/$VT_ARQRCV.bad
        					        fi
                 fi

                    #CASO OCORRA ERRO COPIA PARA O BAD
                    if [ $VT_RET = 0 ]
                    then
        					        #SE BANCO ESTA FORA NAO MOVE
        					        VT_BAD1=`grep "ORA-12541" $VS_DIRARQ/vemp_ticket.log |wc -l | awk '{ printf("%s\n",$1) }'`
        					        VT_BAD2=`grep "ORA-12500" $VS_DIRARQ/vemp_ticket.log |wc -l | awk '{ printf("%s\n",$1) }'`
        					        VT_BAD3=`grep "SQL*Loader-704" $VS_DIRARQ/vemp_ticket.log |wc -l | awk '{ printf("%s\n",$1) }'`
        					        VT_BAD4=`grep "SQL*Loader-700" $VS_DIRARQ/vemp_ticket.log |wc -l | awk '{ printf("%s\n",$1) }'`
        					        VT_BAD5=`grep "SQL*Loader-500" $VS_DIRARQ/vemp_ticket.log |wc -l | awk '{ printf("%s\n",$1) }'`

        					        if [ $VT_BAD1 = 0 -a $VT_BAD2 = 0 -a $VT_BAD3 = 0 -a $VT_BAD4 = 0 -a $VT_BAD5 = 0 ]
        					        then
        						        mv -f $RCV   $VT_BADRCV$VT_EMPLOJ
        						fi
        						mv -f $VS_DIRARQ/vemp_ticket.log $VS_DIRARQ/$VT_ARQRCV.log
					        fi

					        rm -f $VS_DIRARQ/vemp_ticket.bad
					else
						mv -f   $RCV   $VT_HYSRCV$VT_EMPLOJ
					fi

			fi
		done

		#--------------------- EXECUTA SQL INTERFACE ( PROCESSA NOTAS )  ----------------------#
#		sqlplus -s $VS_ORAPWD @$MS_PROGS/dt_emp_invoice

                #PROCESSA NF
		sqlplus -s $VS_ORAPWD @$MS_PROGS/dt_emp_invoice 1 text >>$MS_LIST/log/dt_emp_invoice.$VS_DIAJUL 2>>$MS_LIST/log/dt_emp_invoice.$VS_DIAJUL
                #PROCESSA CUPOM (OUTROS)
		sqlplus -s $VS_ORAPWD @$MS_PROGS/dt_emp_invoice 2 text >>$MS_LIST/log/dt_emp_invoice.$VS_DIAJUL 2>>$MS_LIST/log/dt_emp_invoice.$VS_DIAJUL

		#----------------------------- GERA ARQUIVOS SAIDA   ----------------------------------#
		umask 000
		sqlplus -s $VS_ORAPWD @$MS_PROGS/ct_emp_dep
		sqlplus -s $VS_ORAPWD @$MS_PROGS/ct_emp_plu
		sqlplus -s $VS_ORAPWD @$MS_PROGS/ct_emp_price
		sqlplus -s $VS_ORAPWD @$MS_PROGS/ct_emp_bar
		sqlplus -s $VS_ORAPWD @$MS_PROGS/ct_emp_kit
		sqlplus -s $VS_ORAPWD @$MS_PROGS/ct_emp_kit_ho
		sqlplus -s $VS_ORAPWD @$MS_PROGS/ct_emp_cli
		sqlplus -s $VS_ORAPWD @$MS_PROGS/ct_emp_kit_rom
		sqlplus -s $VS_ORAPWD @$MS_PROGS/ct_emp_invoice
		sqlplus -s $VS_ORAPWD @$MS_PROGS/ct_emp_user
		sqlplus -s $VS_ORAPWD @$MS_PROGS/ct_emp_comanda

		#REVER O ENVIO POIS DEVE SER NA ORDER DE GERA플O
		for SND in $MS_LIST/cus_???_?????.????? \
		           $MS_LIST/plu_???_?????.????? \
		           $MS_LIST/kit_rom_???_?????.????? \
		           $MS_LIST/inv_???_?????.????? \
		           $MS_LIST/dep_???_?????.????? \
		           $MS_LIST/user_???_?????.????? \
		           $MS_LIST/ret_???_??????????_?????.????? \
		           $MS_LIST/com_???_?????.????????.?????
		do
			if [ -s $SND ]
			then
				VT_ARQ=`basename $SND`
				mv -f $SND $VT_HYSSND$VT_EMPLOJ
				cp -f $VT_HYSSND$VT_EMPLOJ$VT_ARQ $VT_EMPSND$VT_EMPLOJ
				VT_RET=$?
				echo "$VT_RET $SND"  >> $VT_TRALOG

			else
				rm -f $SND
			fi
		done



    #SE JA ESTIVER EM EXECUCAO MAIS DE XXX MINUTOS MATA
    #VE_PROC="transc"
    #ps -eaf | grep ${VE_PROC} | grep -v grep | while read USER PRO PRO2 STR1 STR2 STR3
    #do
    #          TEMPO_MM=`ps -eo etime,args,pid | grep ${PRO} | grep ${VE_PROC} | grep -v grep |cut -c7-8| tr ' ' '0'`
    #          TEMPO_HH=`ps -eo etime,args,pid | grep ${PRO} | grep ${VE_PROC} | grep -v grep |cut -c4-5| tr ' ' '0'`
    #          if [ ${TEMPO_MM:=0} -gt 15 ]
    #          then
    #                killpid ${PRO}
    #          fi
    #          echo "${TEMPO_HH}-${TEMPO_MM}-${PRO}"
    #done


	 #Move arquivos de romaneios para o transf
	 for file in ${MS_LIST}/ROM_?????_??????_???????.html
	 do
	    if [ -s $file ]
	    then
	       #MOVE PARA AREA DE ARQUIVOS
	       chmod -f 777 $file >/dev/null 2>/dev/null
	       mv -f $file $MS_TRANSF/arquivos/
	    fi
	 done 
	 
		sleep $DELAY
	done
;;
'stop')

	rm -f /home/store/admin/restart_rede.run
	# MATAR TODOS OS PROCESSOS
	# MATA O RT_PRC_EMPORIUM START
	ps -ef | grep $0 | grep -v grep | grep -v stop |while read RECORD
	do
		echo $RECORD | while read USER PROCID PPROCID ROMMEL
		do
		       echo Finalizado  $PROCID $0  >/dev/tty
		       killpid  -9 $PROCID
		       echo $PROCID
		done
	done

	# MATA O DISSEMINO
	ps -ef | grep dissemino | grep -v grep | while read RECORD
	do
		echo $RECORD | while read USER PROCID PPROCID ROMMEL
		do
			echo Finalizado  $PROCID dissemino  >/dev/tty
			killpid  $PROCID
			echo $PROCID
		done
	done

	# MATA O DT_EMP_INVOICE
	ps -ef | grep dt_emp_invoice | grep -v grep | while read RECORD
	do
		echo $RECORD | while read USER PROCID PPROCID ROMMEL
		do
			echo Finalizado  $PROCID dt_emp_invoice  >/dev/tty
			killpid  -9 $PROCID
			echo $PROCID
		done
	done

	# LIMPEZA DE ARQUIVOS ANTIGOS DA AREA HISTORY
	echo "Aguarde ... Limpeza de Transacoes Antigas" >/dev/tty
	find $VT_HYSRCV$VT_EMPLOJ -name "*" -type f -mtime +7 -print -exec rm -f {} >/dev/null 2>/dev/null \;
	find $VT_HYSSND$VT_EMPLOJ -name "*" -type f -mtime +7 -print -exec rm -f {} >/dev/null 2>/dev/null \;
	find $VT_BADRCV$VT_EMPLOJ -name "*" -type f -mtime +30 -print -exec rm -f {} >/dev/null 2>/dev/null \;
        find $VT_EMPBAS/TMP/ -name "*" -type f -mtime +2 -print -exec rm -f {} >/dev/null 2>/dev/null \;
        rm -Rf $VT_EMPBAS/history/

	sqlplus -s $VS_ORAPWD @$MS_PROGS/dt_emp_clear >/dev/null 2>/dev/null


	exit
;;
 'check')
	echo "               STATUS REDE CONECTO"
	echo " "
	echo " "
	echo " "

	#------------------------ CHECA ROTINA DE FECHAMENTO ESTA RODANDO ------------------------#
        if [ -r $MS_ARQUIVOS/BLOCK_USER ]
        then
		echo "               ROTINA DE FECHAMENTO DE LOJA EM EXECUCAO, AGUARDE TERMINO  !!!!!!!"
		echo " "
        fi

	#------------------------ CHECA USUARIO QUE ESTA INICIANDO ------------------------#
	VL_STOREP=`id | grep "(storep)" | grep -v grep |wc -l`
        if [ $VL_STOREP = 0 ]
        then
		echo "               SOMENTE USUARIO STOREP PODE INICIAR A REDE  !!!!!!!"
        fi

	ps -ef | grep $0 | grep -v grep | grep -v check >/dev/null 2> /dev/null
	VT_RET=$?
	if [ $VT_RET != 0 ]
	then
		echo "               REDE NAO ESTA ATIVA "
	else
		echo "               REDE ATIVA "
	fi

	ls -l $VT_BADRCV$VT_EMPLOJ* >/dev/null 2> /dev/null
	VT_RET=$?
	if [ $VT_RET = 0 ]
	then
		echo " "
		echo " "
		echo "               EXISTEM TRANSACOES ENVIADAS PELO PDV CONECTO NAO PROCESSADAS "
	fi

;;
esac

exit
