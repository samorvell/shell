ARQ=$1
echo "Lista de Arquivos com Data e Tamanho"> /tmp/log.chegada
cd /home/rxtx
for file in loja*
do
 cd $file
 ls -lia $ARQ >> /tmp/log.chegada 2> /dev/null
 cd ..
done
more /tmp/log.chegada
