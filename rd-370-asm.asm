#
#  Hercules "Bare Metal"       Mike Stramba   July 29 2014
#                              mikestramba@gmail.com
#
#   Attempt to read record #'s 1-255 from CYL 0000 HD 0001 from dev #001
#
#   No error checking :), it will either work or not
#
#
#
#
# Read this file into Hercules with the SCRIPT <this-filename>
# Then run it with the RESTART command
#
r 002000= 05C0               #           2          BALR  R12,0
r 002002= 41B0 C07E          # 02080     5          LA    R11,BUFF
r 002006= 4130 00FF          #           7          LA    R3,255
r 00200A= 4110 0001          #           8          LA    R1,1         RECORD NUMBE
r 00200E= 4120 C046          # 02048     9          LA    R2,CCWREAD
r 002012= 5020 0048          #          10          ST    R2,CAW
r 002016= 9C00 0001          #          11 DOIO     SIO   X'01'
r 00201A= 9D00 0001          #          12          TIO   X'01'
#
#                                                   BZ    CONTINUE
#                                                   BC    4,CSWSTORD
#                                                   BC    2,RETRYIO
#                                                   BC    1,NOTOP
#
#                                                   CHDVEND EQU X'0C'
#
#                                          CSWSTORD TM CSW,CHDVEND
#                                                   BC 3,OK
#                                                    .... Otherwise check CSW (probably unit check)
#
r 00201E= 4210 C070          # 02072    13          STC   R1,SRCHREC
r 002022= 4110 1001          #          14          LA    R1,1(,R1)    NEXT RECORD
r 002026= 1800 1800          # 02077                STC   R1,RCKDRECN
r 00202A= 1800 1800          # 0207F    16          STC   R1,RECNUM
                             #       17 *
r 00202E= 41B0 B010          #          18          LA    R11,16(,R11)
r 002032= BEB7 C05F          # 02061    19          STCM  R11,B'0111',RDCCW+1
r 002036= 4630 C014          # 02016    20          BCT   R3,DOIO
r 00203A= 8200 C03E          # 02040    21          LPSW  WAITPSW
r 002040                     #         22          DS    0D
r 002040= 008200000000ABCD   #          23 WAITPSW  DC    X'00',X'82',X'0000',X'000
r 002048= 0700206840000006   #          29 CCWREAD  CCW  7,CCHH,X'40',6
r 002050= 3100206E40000005   #          30 SRCHCCW  CCW  X'31',CCHHR,X'40',5
r 002058= 0800205000000000   #          31          CCW  X'08',SRCHCCW,0,0
r 002060= 0600208000000010   #          32 RDCCW    CCW  X'06',BUFF,0,16
r 002068= 000000000001       #          36 CCHH     DC X'0000',X'0000',X'0001'  SEE
                             #       38 *             CC      HH      R
r 00206E= 00000001           #          39 CCHHR    DC X'0000',X'0001'         FOR
r 002072= 00                 #          40 SRCHREC  DC                X'00'
#
r 2080 = 00                             #  BUFF     DS X'4096'

