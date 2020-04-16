#--------------------------------------------------------------------------#
#VERIFICA_ROTINA_BATCH
#--------------------------------------------------------------------------#
if [ -r $MS_ARQUIVOS/BLOCK_USER ]
then
    clear
    echo;echo;echo;echo;echo;echo;
    echo "\07 Executando ROTINA BATCH, Aguarde o término."
    echo
    echo "\07 ( TECLE ENTER )"
    read nada 
    sleep 1
    exit
fi
