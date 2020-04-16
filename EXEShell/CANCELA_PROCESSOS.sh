#--------------------------------------------------------------------------#
#ROTINA PARA CANCELAR PROCESSOS ANTES DA DESATIVACAO DO BANCO DE DADOS
VT_RETORNO=0
if test `ps -eaf | grep -v grep | grep -c stnet ` -ne 0
      then
         clear
         echo;echo;echo;echo;echo;echo;
         echo "Os Programas da rede estao ativos, favor encerrar antes de usar esta opcao  (TECLE ENTER)"
         read nada
         VT_RETORNO=1
         exit
fi
ps -G501 -f >/tmp/b
if test `wc -lw /tmp/b |cut -c1-8` -gt 1
      then 
         PROCESSOS=`cat < /tmp/b | cut -c9-14`                                 
         for NUM_PROC in $PROCESSOS                                            
            do                                                                
             sudo /usr/bin/kill -9 $NUM_PROC
              done                                                              
fi                                                                    
rm /tmp/b >/dev/null                                                  
