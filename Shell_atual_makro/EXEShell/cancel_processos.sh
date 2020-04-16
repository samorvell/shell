ps -eaf | grep f60run | grep -v "root" >/tmp/b
PROCESSOS=`cat < /tmp/b | cut -c9-14`     
if [ -n "$PROCESSOS" ]
   then
for NUM_PROC in $PROCESSOS                
    do                                    
         DATA=`date`
         echo;echo kill -9 $NUM_PROC      
         kill -9 $NUM_PROC                
    done                                  
fi
DATA=`date`                                                           
echo "PROCESSOS CANCELADOS EM $DATA " >>/home/operator/LOG.OPERATOR
cat /tmp/b >>/home/operator/LOG.OPERATOR                           
rm /tmp/b >/dev/null
