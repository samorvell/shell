#------------------------------------------------------------------------------#
# REMOVE BLOCK_USER
#------------------------------------------------------------------------------#
                 rm $MS_ARQUIVOS/BLOCK_USER_REORG
                 rm $MS_ARQUIVOS/BLOCK_USER_BACKUP
echo $LJ \(Removeu BLOCK_USER_SUPORTE\) `date` `tty` >> $OPERATOR/LOG.OPERATOR;;
exit
