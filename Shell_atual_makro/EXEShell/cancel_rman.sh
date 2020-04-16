ps -eaf | grep rman | grep -v "root" | grep '?' >/tmp/c
PROCESSOS=`cat < /tmp/c | cut -c9-14`     
if [ -n "$PROCESSOS" ]
   then
for NUM_PROC in $PROCESSOS                
    do                                    
         DATA=`date`
         echo;echo kill -9 $NUM_PROC      
         kill -9 $NUM_PROC                
    done                                  
# GERACAO DO LOG
fi
rm /tmp/c >/dev/null
