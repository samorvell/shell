#! /bin/bash
#Shell para rodar arquivos scrcom versao 1.0
#Desenvolvido por Samuel Amaro da Silva
#Verificar lojas no toad, na tabela NRSTAUS, quais loja estao com erro no scrcom
#Informar a quantidade de lojas com erro, depois informar o numero das lojas para execucao
#Nessa versao  ainda necessida executar o ctrl+d para sair do sql, apos exeuctar a procedure

clear
echo "|=========================================================|"
echo "|Shell de facil entendimento, basta seguir as instrucoes  |"
echo "|SCRCOM V. 1.0                                            |"
echo "|=========================================================|"


DAY=`date --date="-1 day" +20%y%m%d` 	 #Variavel que armazena o dia anterior para linha for store abaixo

read -p "Informe a data do rundate aaaammdd: " DATA
read -p "Deseja remover os arquivos do diretorio SCRCOM? (sim ou nao): " RESPRM
DIA=`julian $DATA`                       #Variavel para armazenar o dia juliano
if [ $RESPRM = sim  ] ; then
        rm /home0/users/trescon/SCRCOM/procscrcom/*.sql
        echo "Arquivos excluidos!"
        else
        echo "Ok! Vamos continuar!"
fi
echo
read -p "Informe a quantidade de lojas com erro na tabela NRSTATUS: " QTSTATUS
        for i in $( seq $QTSTATUS ) ; do
                echo "Informe o numero da $i loja. (Formato 00): "
                read ESTORE                                 #ESTORE = Erro store
                cp /home2/makro/st_rcv/str_000$ESTORE/scrcom$DIA /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$ESTORE.sql
                ls /home0/users/trescon/SCRCOM/procscrcom/
                sqlplus $ORAID @/home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$ESTORE.sql
                echo "Ultima loja executada Loja $ESTORE"
        done
cp /home0/users/trescon/SCRCOM/procscrcom/*.sql /home0/users/trescon/SCRCOM/procscrcom/scrcomlojas/
tar -cf scrcom$DIA.tar /home0/users/trescon/SCRCOM/procscrcom/scrcomlojas/*.sql
bzip2 scrcom$DIA.tar
mv /home0/users/trescon/progs/scrcom$DIA.tar.bz2 /home0/users/trescon/SCRCOM/procscrcom/scrcomlojas/
rm -rf /home0/users/trescon/SCRCOM/procscrcom/scrcomlojas/*.sql

	

#read -p "Deseja copiar os arquivos de todas as lojas? (sim ou nao)  " CPALL
#if [ $CPALL != sim ] ; then
#	read -p "Informe as lojas com erro, que apresenta na tabela NRSTATUS, separados por (,): " QTSTATUS
	
		


#read -p "Deseja copiar os arquivos do diretorio str para o diretoricd o SCRCOM? (sim ou nao)  " CPARQ
#if [ $CPARQ = sim ] ; then
#	cp /home2/makro/st_rcv/str_000$STORE/scrcom$DIA /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$STORE.sql




#DATA=20150512 			#data do dia anterior



#rm  /home0/users/trescon/SCRCOM/procscrcom/*.sql
#rm  /home0/users/trescon/SCRCOM/procscrcom/scrcomlojas/*.sql

#echo $dia
# rm  /home0/users/trescon/SCRCOM/procscrcom/*.sql

#for STORE in `$MS_PROGS/store_gen $ORAID $DAY`
##for STORE in 01 02
#do
 #     sqlplus $ORAID @/home0/users/trescon/SCRCOM/procscrcom/scrcomlojas/scrcom$DIA$STORE.sql
  
       # cp /home0/users/trescon/SCRCOM/procscrcom/scrcom15041$STORE /home0/users/trescon/SCRCOM/scrcom15041$STORE.sql

      #cp /home2/makro/st_rcv/str_000$STORE/scrcom$DIA /home0/users/trescon/SCRCOM/procscrcom/scrcom$DIA$STORE.sql


  #/home0/users/trescon/SCRCOM/scrcom14350$STORE.sql
  ##gunzip /home0/users/trescon/SCRCOM/scrcom14323$STORE.sql.gz
#  echo "leu loja "$STORE
 #exit
#done



