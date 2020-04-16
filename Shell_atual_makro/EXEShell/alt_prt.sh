################################################################################
################################################################################
#         Alterar endereco de Impressora                                       #
#                                                                              #
################################################################################
IMP="";
PORT="";
REGUA="";
RESP='N';

INQUIRE ( ) {

clear

while test "$IMP" = "" 
  do
    tput cup 08 03 >/dev/tty
      echo 'Nome da Impressora......: ' >/dev/tty
    tput cup 08 45 >/dev/tty
      read IMP
  done


while test "$PORT" = "" 
  do
    tput cup 10 03 >/dev/tty
      echo 'Nome do Port ...........: ' >/dev/tty
    tput cup 10 45 >/dev/tty
      read PORT
  done

while test "$REGUA" = "" 
  do
    tput cup 12 03 >/dev/tty
      echo 'Nome do Regua ..........: ' >/dev/tty
    tput cup 12 45 >/dev/tty
      read REGUA
  done
 }

INQUIRE
 

while test "$RESP" = "N"
  do  
    tput cup 15 03 >/dev/tty
      echo 'Confirma valores acima:  S/N ' >/dev/tty
    tput cup 15 45 >/dev/tty
      read RESP
    if [ ${RESP:-t} = 'N' -o ${RESP:-t} = 'n' ]
          then 
          IMP=""
          REGUA=""
          PORT=""
          RESP=N
          INQUIRE
    fi 
  done
echo 'DEFINICAO DA IMPRESSORA'
