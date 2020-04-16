#############################################################################
#                               send files                                  #
#############################################################################
# Shell para envio de arquivos do MBS para o MAKROHO                        #
#                                                                           #
# Version: 1.0                                                              #
#                                                                           #
#############################################################################


VS_HOUSR=rxtx

MAKRO=/home0/makro; export MAKRO
RXTX=/home/rxtx/loja; export RXTX
HSTHO=MAKROHO; export HSTHO
. ${MAKRO}/misc/environment


#SE JA ESTIVER EM EXECUCAO MAIS DE UMA HORA MATA
VE_PROC="send_files_ho_store"
ps -eaf | grep ${VE_PROC} | grep -v grep | while read USER PRO PRO2 STR1 STR2 STR3
      do
          TEMPO_MM=`ps -eaf -o etime,args,pid | grep ${PRO} | grep ${VE_PROC} | grep -v grep |cut -c7-8| tr ' ' '0'`
          TEMPO_HH=`ps -eaf -o etime,args,pid | grep ${PRO} | grep ${VE_PROC} | grep -v grep |cut -c4-5| tr ' ' '0'`

          if [ ${TEMPO_HH:=0} -gt 0 ]
          then
           killpid -9 ${PRO}
          fi
          echo "${TEMPO_HH}-${TEMPO_MM}-${PRO}"
      done

#SE JA ESTIVER EM EXECUCAO NAO EXECUTA
a=`ps -eaf | grep ${VE_PROC} | wc -l`
test $a -le 3
VT_RET=$?
if [ $VT_RET = 0 ]
then
echo $a


 ##  A R Q U I V O S  *COM*

#    # CHECA QUAIS ESTAO NO MAKROHO
    rsh ${HSTHO} -l ${VS_HOUSR} ls -l ${RXTX}??/???com.str??.?????.Z | cut -c30-40,73-92 | tr ' ' '0' > /tmp/MBS_ARQ_TRANSF.CTL
    VT_ARQCTL=/tmp/MBS_ARQ_TRANSF.CTL

    for file in `ls ${MS_LIST}/snd/str??/???com?????.Z`
    do
        juli=`echo ${file} | cut -c30-34`
        loja=`echo ${file} | cut -c21-22`
        arq=`echo ${file} | cut -c24-29`
        arqdes=${RXTX}${loja}/${arq}.str${loja}.${juli}.Z

            echo "2 L${loja}"
            #SE NAO EXISTIR NO MAKROHO
	    arqchk=`ls -l ${file} | cut -c30-40 | tr ' ' '0'`
 	    arqchk=`echo ${arqchk}${arq}.str${loja}.${juli}.Z`

            grep $arqchk ${VT_ARQCTL} > /dev/null

            VT_RET=$?
            if [ $VT_RET != 0 ]
            then
	        echo "3"
	        #TESTA SE ARQUIVO ESTA OK
	        zcat ${file} > /tmp/mbs_check_file.tmp
	        crcln check /tmp/mbs_check_file.tmp
	        VT_RET=$?
	        if [ $VT_RET = 0 ]
	        then
	               #COPIA PARA O HO
	               rcp ${file} ${VS_HOUSR}@${HSTHO}:${arqdes}
	               VT_RET=$?
	               echo "4"
	               if [ $VT_RET = 0 ]
	               then
	                     rsh ${HSTHO} -l ${VS_HOUSR} chmod 777 ${arqdes}
	                     #GRAVA LOG DE ENVIO
	                     echo $arqchk >> ${MS_LIST}/snd/str${loja}/MBS_ARQ_TRANSF${loja}.${juli}.CTL
	                     echo "5"
	               fi
	       fi
               rm /tmp/mbs_check_file.tmp
	       echo "9"
            fi
    done
    rm /tmp/mbs_check_file.tmp

  ## R E L A T O R I O S

    # CHECA QUAIS ESTAO NO MAKROHO
    rsh ${HSTHO} -l ${VS_HOUSR} ls -l ${RXTX}??/??????.l????.?????.Z | cut -c30-40,73-92 | tr ' ' '0' > /tmp/MBS_ARQ_TRANSF.CTL
    VT_ARQCTL=/tmp/MBS_ARQ_TRANSF.CTL

    for file in `ls ${MS_LIST}/snd/str??/??????.l????.?????.Z`
    do
        juli=`echo ${file} | cut -c37-41`
        loja=`echo ${file} | cut -c34-35`
         arq=`echo ${file} | cut -c24-43`
        arqdes=${RXTX}${loja}/${arq}

        echo "2 L${loja}"
        #SE NAO EXISTIR NO MAKROHO
        arqchk=`ls -l ${file} | cut -c30-40 | tr ' ' '0'`
        arqchk=`echo ${arqchk}${arq}`

        grep $arqchk ${VT_ARQCTL} > /dev/null

        VT_RET=$?
        if [ $VT_RET != 0 ]
        then
           #COPIA PARA O HO
           rcp ${file} ${VS_HOUSR}@${HSTHO}:${arqdes}
           VT_RET=$?
           echo "4"
           if [ $VT_RET = 0 ]
           then
                 rsh ${HSTHO} -l ${VS_HOUSR} chmod 777 ${arqdes}
                 #GRAVA LOG DE ENVIO
                 echo $arqchk >> ${MS_LIST}/snd/str${loja}/MBS_ARQ_TRANSF${loja}.${juli}.CTL
                 echo "5"
           fi
           echo "9"
        fi
       done









##############################################################
##                                                          ##
##           CONVERSAO/ENVIO PDF PARA INTRANET              ##
##                                                          ##
##############################################################

     #reg01=Diretoria_SP-Capital
     #reg02=Diretoria_Sul-SP-Interior
     #reg03=Diretoria_RJ-Centro
     #reg04=Diretoria_Nordeste
     #reg05=Diretoria_Centro-Norte

    #### MOVE #### MOVE #### MOVE #### MOVE #### MOVE #### MOVE #### MOVE #### MOVE
    #### MOVE #### MOVE #### MOVE #### MOVE #### MOVE #### MOVE #### MOVE #### MOVE
    rm /tmp/envia_arq_par

    # LISTA ARQUIVOS LOJA PARA MOVER / CRIA DIRETORIOS
    for loja in `ls -d ${MS_LIST}/snd/str?? | cut -f5 -d'/' | cut -c4-5`
    do

        if [ ! -d ${MS_LIST}/list/str${loja} ]
        then
           mkdir ${MS_LIST}/list/str${loja}
           chmod 777 ${MS_LIST}/list/str${loja}
        fi

        if [ ! -d ${MS_LIST}/list/str${loja}/old ]
        then
           mkdir ${MS_LIST}/list/str${loja}/old
           chmod 777 ${MS_LIST}/list/str${loja}/old
        fi


        #DESCOMPACTA ARQUIVO ENVIADO PELA LOJA COM OS RELATORIOS
        file="$MS_LIST/rcv/str${loja}/lstcom*.Z"

        file0="$MS_LIST/rcv/str${loja}/ls0com*.Z"
        #ARQUIVOS ABERTURA
        uncompress ${file0}
        file0=`basename ${file0} .Z`
        unzip -j -o -d ${MS_LIST}/list/str${loja} ${MS_LIST}/rcv/str${loja}/${file0}

            #CRIA LISTA DE NOME DE DIRETORIOS INTRANET
             echo "open intranet
             user .rxtx.makro runner
             bin
             cd /intranet/relatorios/lojas
             mkdir Loja${loja}
             cd Loja${loja}
             mkdir vendas
             cd vendas
             mkdir #0#_hoje
             mkdir #1#_ontem
             mkdir #2#_anteontem
             cd /intranet/relatorios/lojas
             " >> /tmp/envia_arq_par

        if [ -s ${file}  ]
        then
             #ARQUIVOS FECHAMENTO
             echo "zip $loja"
             uncompress ${file}
             file=`basename ${file} .Z`
             unzip -j -o -d ${MS_LIST}/list/str${loja} ${MS_LIST}/rcv/str${loja}/${file}

             #GERA LISTA DOS ARQUIVOS A MOVER NA INTRANET
             echo "
             ls loja${loja}/vendas/#0#_hoje /tmp/dir_arq_dia-0_$loja
             ls loja${loja}/vendas/#1#_ontem /tmp/dir_arq_dia-1_$loja
             ls loja${loja}/vendas/#2#_anteontem /tmp/dir_arq_dia-2_$loja
               " >> /tmp/envia_arq_par
        fi
             echo "
             bye
               " >> /tmp/envia_arq_par
             ftp -v -n < /tmp/envia_arq_par > /dev/null
             rm -f /tmp/envia_arq_par
    done

    # LISTA ARQUIVOS REGIONAL PARA MOVER / CRIA DIRETORIOS
    for regi in `ls -d ${MS_LIST}/list/rgn?? | cut -f5 -d'/' | cut -c4-5`
    do
        #case $regi in
        #'01') regional=$reg01;;
        #'02') regional=$reg02;;
        #'03') regional=$reg03;;
        #'04') regional=$reg04;;
        #'05') regional=$reg05;;
        #esac
	regional=Dir_Regional_$regi

        echo "open intranet
        user .rxtx.makro runner
        bin
        mkdir /intranet/relatorios/lojas/${regional}
        cd /intranet/relatorios/lojas/${regional}
        mkdir #0#_hoje
        mkdir #1#_ontem
        mkdir #2#_anteontem
        cd /intranet/relatorios/lojas/
        ls ${regional}/#0#_hoje /tmp/dir_arq_diaR0_$regi
        ls ${regional}/#1#_ontem /tmp/dir_arq_diaR1_$regi
        ls ${regional}/#2#_anteontem /tmp/dir_arq_diaR2_$regi
        bye
          " >> /tmp/envia_arq_par
        ftp -v -n < /tmp/envia_arq_par > /dev/null
        rm -f /tmp/envia_arq_par
    done


    #MOVE OS ARQUIVOS D PARA D-1
    MOVER_REG=N
    for arq in `cat /tmp/dir_arq_dia??_??`
    do
        loja=`echo $arq | cut -c5-6`
        arq_des=`expr //${arq} : '.*/\(.*\)'`
        rel=`expr //${arq} : '.*/\(.*\)'`

        #CHECA SE + LOJA OU REGIONAL / E SE MUDA ARQUIVOS PARA ONTEM E ANTEONTEM
        MOVER=N
        if [ `echo $arq | cut -c1-4` != 'loja' ]
        then
             tipo=rgn
             #case `echo $arq | cut -f1 -d'/'` in
             #$reg01) rgn=01;;
             #$reg02) rgn=02;;
             #$reg03) rgn=03;;
             #$reg04) rgn=04;;
             #$reg05) rgn=05;;
             #esac
             dir_mov_des=`echo $arq | cut -f1 -d'/'`
             loja=`echo $arq | cut -c14-15`
             #loja=$rgn

             # SE ARQ CTRL REGIONAL FOI DELETADO PELO NIGHTRUN ENTAO MOVE PARA ONTEM/ANTEONTEM
             VT_ARQCTL_DIAS="${MS_LIST}/list/rgn${loja}/MBS_ARQ_INTRAN${loja}.?????.CTL"
             if [ -r ${VT_ARQCTL_DIAS}  ]
             then
                MOVER=N
             else
		MOVER_REG=S
                echo " " > ${MS_LIST}/list/rgn${loja}/MBS_ARQ_INTRAN${loja}.`julian`.CTL
             fi

	     if [ $MOVER_REG == 'S' ]
	     then
                MOVER=S
             fi

        else
             tipo=str
             dir_mov_des=loja${loja}/vendas

             # SE ARQUIVO DA LOJA CHEGOU ENTAO SETA P/ MOVE OS ANTERIORES PARA ONTEM/ANTEONTEM
             file="$MS_LIST/rcv/str${loja}/lstcom?????"
             if [ -s ${file}  ]
             then
                MOVER=S
             fi
        fi


        #SE NAO FOI MOVIDO ENTAO MOVE (OU DELETA) - INTRANET
        if [ $MOVER != 'N' ]
        then
            echo "move hoje .. ontem .. ante : $arq"
             echo "open intranet
             user .rxtx.makro runner
             bin
             cd /intranet/relatorios/lojas " > /tmp/envia_arq_par
             if [ $tipo != str ]
             then
                dia=`echo $arq | cut -f2 -d'/'| cut -c2-2 `
             else
                dia=`echo $arq | cut -c16-16`
             fi

             case $dia in
             '0') echo "rename $arq ${dir_mov_des}/#1#_ontem/${arq_des} " >> /tmp/envia_arq_par;;
             '1') echo "rename $arq ${dir_mov_des}/#2#_anteontem/${arq_des} " >> /tmp/envia_arq_par;;
             '2') echo "delete $arq" >> /tmp/envia_arq_par;;
             esac

             echo "bye " >> /tmp/envia_arq_par
             ftp -v -n < /tmp/envia_arq_par > /dev/null
             rm -f /tmp/envia_arq_par
             VT_ARQCTL_DIAS=${MS_LIST}/list/${tipo}${loja}/MOVE_INTRANET.CTL
             echo ${rel} >> $VT_ARQCTL_DIAS
       fi
    done

    rm /tmp/dir_arq_dia??_??
    #### MOVE #### MOVE #### MOVE #### MOVE #### MOVE #### MOVE #### MOVE #### MOVE
    #### MOVE #### MOVE #### MOVE #### MOVE #### MOVE #### MOVE #### MOVE #### MOVE



    #rm /tmp/envia_arq_par
    for loja in `ls -d ${MS_LIST}/snd/str?? | cut -f5 -d'/' | cut -c4-5`
    do
        #MOVE PARA OLD ARQ DE CONTROLE INDICA SE DEVE MOVER HOJE > ONTEM ....
           file="$MS_LIST/rcv/str${loja}/lstcom?????"
           file0="$MS_LIST/rcv/str${loja}/ls0com?????"
           mv $file $MS_LIST/rcv/str${loja}/old
           mv $file0 $MS_LIST/rcv/str${loja}/old

    done



    #LOOP PRINCIPAL
    #LOOP PRINCIPAL
    for file_in in `ls $MS_LIST/list/str??/*.* $MS_LIST/list/rgn??/*.* | grep -v CTL`
    do
        juli=`echo ${file_in} | tr '.' '/'`
        juli=`expr ${juli} : '.*/\(.*\)'`
        loja=`echo ${file_in} | cut -c22-23`
         arq=`expr //${file_in} : '.*/\(.*\)'`
         rel=`expr //${file_in} : '.*/\(.*\)' | cut -f1 -d'.'`
        tipo=`echo ${file_in} | cut -c19-21`
     dir_ori=`expr //${file_in} : './\(.*/\)'`

        #SE NAO EXISTIR NO LOG ENTAO ENVIA PARA A INTRANET
        arqchk=`ls -l ${file_in} | cut -c30-40 | tr ' ' '0'`
        arqchk=`echo ${arqchk}${arq}.pdf`
        VT_ARQCTL=${dir_ori}MBS_ARQ_INTRAN${loja}.${juli}.CTL
        grep $arqchk ${VT_ARQCTL} > /dev/null
        VT_RET=$?

        if [ $VT_RET != 0 ]
        then

            if [ `echo $arq |grep .pcl.| wc -l` != 0 ]
            then
                dire="_LOJA_${rel}"
            else
                dire="${rel}"
            fi
            dire=`echo ${dire}| tr '[:lower:]' '[:upper:]'`

             #CONVERTE PDF
             GRAVA_PDF=0; export GRAVA_PDF
             JULIAN=$juli; export JULIAN
             sh $MS_PROGS/lp_mbs ${dir_ori}${arq}
             unset GRAVA_PDF

             #Se o arquivo Ú pcl coloca ".LST" no nome
             if [ `echo $arq | grep pcl | wc -l`   = 1 ]
             then
                rel=${rel}.pcl
                arq=`echo ${arq} | sed s/pcl/LST/`
             fi
             arq_pcl=`echo ${arq} | sed s/LST/pcl/`

             #COPIA PARA A INTRANET VIA FTP
             dir_pdf=/tmp
             dir_intranet=/intranet/relatorios/lojas

             echo "open intranet
             user .rxtx.makro runner
             bin
             cd ${dir_intranet}" > /tmp/envia_arq_rel
             rm -f /tmp/arq_enviado.log
             if [ $tipo != 'rgn' ]
             then
                  echo "cd Loja${loja}
                  cd Vendas" >> /tmp/envia_arq_rel
             else
                  #case $loja in
                  #'01') regional=$reg01;;
                  #'02') regional=$reg02;;
                  #'03') regional=$reg03;;
                  #'04') regional=$reg04;;
                  #'05') regional=$reg05;;
                  #esac
                  regional=Dir_Regional_$loja
                  echo "cd $regional" >> /tmp/envia_arq_rel
             fi
             echo "mkdir ${dire}
             cd ${dire}
             put ${dir_pdf}/${arq_pcl}.pdf ${arq}.pdf
             ls ${arq}.pdf /tmp/arq_enviado.log
             cd ..
             cd #0#_hoje
             put ${dir_pdf}/${arq_pcl}.pdf ${arq}.pdf
             bye
               " >> /tmp/envia_arq_rel
             ftp -v -n < /tmp/envia_arq_rel > /dev/null
             rm -f /tmp/envia_arq_rel
             rm -f ${dir_pdf}/${rel}.pdf

             #TESTE SE FOI ENVIADO
             grep ${arq}.pdf /tmp/arq_enviado.log > /dev/null
             VT_RET=$?
             if [ $VT_RET = 0 ]
             then
                  #GRAVA LOG DE ENVIO
                  if [ $rel != "sall50" ]
                  then
                     echo $arqchk >> $VT_ARQCTL
                  fi
                  #GRAVA CONTROLE PARA NAO MOVER DE HOJE PARA ONTEM
                  VT_ARQCTL_DIAS=${MS_LIST}/list/${tipo}${loja}/MOVE_INTRANET.CTL
                  echo ${arq}.pdf >> $VT_ARQCTL_DIAS
                  #MOVE RELATORIO P/ OLD
                  gzip $file_in
                  mv ${file_in}.gz ${dir_ori}old
             fi
             rm -f /tmp/arq_enviado.log
        else
          echo "${tipo}${loja} ${arq}.pdf ja enviado "
        fi
    done
fi
