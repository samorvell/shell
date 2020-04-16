SELECT S.STORE_NO                                  LOJA         ,
       C.DTMOV                                     DATA         ,
       C.CASTAECF                                  STATUS       ,
       H.TILL_NO                                   PDV          ,
       C.NMECF                                     ECF          ,
       SUM(H.TOT_NM_FOOD)                          SISTEMA      ,
       C.VCCTB                                     REDUCAO      ,
       SUM(H.TOT_NM_FOOD) - C.VCCTB                DIFERENCA
      -- DECODE (C.SQCRZ,0,'REDUCAO Z NAO LANCADA')  OBS --pegar pelo coo
  FROM CTDETMAP     C,
       HIST_INVOICE H,
       STORE        S,
       CTCADECF     T
 WHERE NMTIPFAT   = 5
   AND PROC_IND   = 1
   AND C.NMECF    = H.NMECF
   AND C.DTMOV    = H.INVOICE_DATE
   AND C.CASTAECF = 'E'
   AND C.NMECF    = T.NMECF
   AND C.NMCRO    = T.NMCRO
   AND T.CATIPECF = 'LOJ'
   GROUP BY C.DTMOV     ,
            S.STORE_NO  ,
            C.CASTAECF  ,
            H.TILL_NO   ,
            C.NMECF     ,
            C.VCCTB
          -- C.SQCRZ
HAVING SUM(H.TOT_NM_FOOD) - C.VCCTB <> 0
 ORDER BY DTMOV ASC                                                             
/

