#!/bin/bash
  #
  # $1 = nome a procurar
  #
  # exemplo de uso:
  # $ ./search.sh Super
  # $ ./search.sh Super*
  # $ ./search.sh *Super*
  #
  # O * ém curinga, fazendo procura parcial (usando o LIKE)
  #
  
  # Testa pra ver se e a procura exata ou parcial i
if [ "$*" = "${*#*\*}" ];then
  	# Faz pesquisa exata do nome
  	mysql -u Samuel -e\
  	"SELECT * FROM agenda WHERE nome = '$*'" mysql_bash
  
 # Procura por partes do nome
else
  	# ${*//\\*/%} = troca todos * por %, que e o curinga do LIKE
  	mysql -u Samuel -e\
  	"SELECT * FROM agenda WHERE nome LIKE '${*//\\*/%}'" mysql_bash
fi
