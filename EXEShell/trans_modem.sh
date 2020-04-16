RT_TRANS_MODEM ( )
{                
sudo cp -r /etc/uucp/Systems.modem /etc/uucp/oldconfig/Systems >/dev/null 2>&1
chown uucp:uucp /etc/uucp/oldconfig/* >/dev/null 2>&1
chmod 644 /etc/uucp/oldconfig/* >/dev/null 2>&1
rm /var/uucp/.Status/* >/dev/null 2>&1;  
rm /var/uucp/.Sequence/* >/dev/null 2>&1;
rm /var/uucp/.Admin/* >/dev/null 2>&1;   
rm /var/spool/locks/* >/dev/null 2>&1;   
clear
echo "\07                             A T E N Ç Ã O"                      
echo "\07 "                                                                     
echo "\07 DISCAGEM VIA MODEM HABILITADA"
echo "\07 "                                                                   
echo "\07 OBSERVAÇÕES IMPORTANTES:"
echo "\07 "
echo "\07 1 - Fazer a conexão para o H.O no número 0XX11 3742-6633."
echo "\07 "
echo "\07 2 - Solicitar a opção de transmissão por modem"
echo "\07 "
echo "\07 3 - Em caso de problemas ANTES DE ACIONAR O SUPORTE TÉCNICO, execute as opções      8 e 10 do operator e solicite as transmissões novamente."
echo "\07 "                                                                     
echo "\07 "                                                                     
}
#------------------------------------------------------------------------------#
ping -s 56 -c 5 MAKROHO >/dev/null 2>&1
OPERATOR=/home/operator;	export OPERATOR
VT_RETPING=$?;              
if [ $VT_RETPING != 0 ]     
then                        
echo $LJ \(Comsat FORA - Transmissao no modo Modem\) `date` `tty` >> $OPERATOR/LOG.OPERATOR
RT_TRANS_MODEM
else
if [ VT_RET != 0 ]
then              
     while        
clear
echo "\07                             A T E N Ç Ã O"
echo "\07 "
echo "\07 A CONEXÃO DA COMSAT ESTA OK !!!"
echo "\07 VC DESEJA FAZER UMA TRANSMISSÃO VIA MODEM ?? (S/N)"
read VT_RESP;   
do
case $VT_RESP in
s|S) RT_TRANS_MODEM
     echo $LJ \(Comsat OK - Operador mudou p/ MODEM\) `date` `tty` >> $OPERATOR/LOG.OPERATOR
     exit 10
exit;;
n|N) clear;
     echo $LJ \(Comsat OK - Operador NÃO mudou p/ MODEM\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;
     exit 11;;                  
*)                              
esac
done
fi
fi
