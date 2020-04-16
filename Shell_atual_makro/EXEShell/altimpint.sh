##############################################################################
#    Inclusao da Impressora LPTERRCP, utilizando Coneccao remota (internet)  #
#    Marco Antonio Ribeiro/Alvaro Melo              versao: 001/03/07        #
##############################################################################
IMP="LPTERRCP"
WHO=`who am i`
micro=`expr "$WHO" : '.*(\(.*\))'`
echo 'shift;shift;shift;shift;shift' 	 >/home/operator/tmpimp
echo 'server='$micro 			>>/home/operator/tmpimp
echo 'service='$IMP 			>>/home/operator/tmpimp
echo 'password=' 			>>/home/operator/tmpimp
echo '('				>>/home/operator/tmpimp
echo 'echo translate' 			>>/home/operator/tmpimp
echo 'echo "print -"'    		>>/home/operator/tmpimp
echo 'cat $*' 				>>/home/operator/tmpimp
echo ')|/home/samba/bin/smbclient "\\\\\\\$server\\\$service"$password -N -P >/dev/null/' 			        >>/home/operator/tmpimp
echo 'exit $?' 				>>/home/operator/tmpimp
dir=/etc/lp/printers/$IMP
if [ -d "$dir" ]
   then
   lpadmin -x $IMP
else
   lpadmin -p $IMP -v/dev/null -i/home/operator/tmpimp -o nobanner -F beginning -A "mail lp" -T 40-132-6
   accept $IMP
   enable $IMP
fi
echo;echo
echo "Impressora: "$IMP"    Para o IP: "$micro" Foi Criada!!!"
echo
echo "Digite [ENTER] para continuar: \c";read continua
echo $LJ \(INCL IMP via Internet $IMP\) `date` `tty` >> $OPERATOR/LOG.OPERATOR
exit
