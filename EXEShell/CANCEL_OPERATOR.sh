ps -eaf | grep operator | grep -v "root" >/tmp/b
PROCESSOS=`cat < /tmp/b | cut -c9-14`     
if [ -n "$PROCESSOS" ]
   then
for NUM_PROC in $PROCESSOS                
    do                                    
         echo;echo kill -9 $NUM_PROC      
         kill -9 $NUM_PROC                
    done                                  
fi
