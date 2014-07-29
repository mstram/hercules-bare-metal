#
#  Hercules "Bare Metal"  
#                            * Read this file into hercules with the SCRIPT <this-filename-command **
#                            * Run with the RESTART command
#
#      Attempt to write 255 records to device 0001 on CCCC HHHH
#                                                  0000 0001
#
#       Mike Stramba July 29, 2014
#
#        Device     KeyLen  DataLen(dec)  Records Written     Expected (allowed) Number of Records
#        --------    ------  -------     ---------------     ------------------------------------
#         3350         0      74              236                             74
#         3340         0      74              105                             74
#         3375         0      74              255                             74
#         3380         0      74              255                             74
#         3390         0      74              255                             ???
#         9345         0      74              255                             ???
r 1=08
r 6=2000
r 002000=05C0               #                      BALR  R12,0
                            #
r 002002=4130 00FF          #                      LA    R3,255
r 002006=4110 0001          #                      LA    R1,1         RECORD NUMBE
r 00200A=4120 C03E          ##02038                LA    R2,CCWWRITE
r 00200E=5020 0048          ##00048                ST    R2,CAW
r 002012=9C00 0001          #             DOIO     SIO   X'01'
r 002016=9D00 0001          #                      TIO   X'01'
r 00201A=4210 C072          # 02074                STC   R1,SRCHREC
r 00201E=4110 1001          #                      LA    R1,1(,R1)    NEXT RECORD
r 002022=4210 C082          # 02084                STC   R1,WCKDRECN
r 002026=4210 C08A          # 0208C                STC   R1,RECNUM
r 00202A=4630 C010          #                      BCT   R3,DOIO
r 00202E=8200 C08E          #                      LPSW  WAITPSW
#                           #
r 002040=07 002060 40 00 0006   #          23 CCWWRITE CCW  7,CCHH,X'40',6
r 002048=31 002070 40 00 0005   #          24 SRCHCCW  CCW  X'31',CCHHR,X'40',5
r 002050=08 002048 00 00 0000   #          25          CCW  X'08',SRCHCCW,0,0
r 002058=1D 002080 00 00 0010   #          26          CCW  X'1D',WCKD,0,16
                            #           *
                            #           *              MBZ   CC      HH
r 002060=00 00 0000 0001    #             CCHH     DC X'0000',X'0000',X'0001'  SEEK DATA CYL=0000 HD=0001
                            #           *
                            #           *             CC      HH      R
r 002070=00 00 00 01        #             CCHHR    DC X'0000',X'0001'         SRCH ID EQUAL
r 002074=00                 #             SRCHREC  DC                X'00'
                            #           *               C  C   H  H  R
r 002080=0000 0001          #             WCKD     DC X'0000',X'0001'
r 002084=01                 #             WCKDRECN DC X'01'
r 002085=00                 #             KEYLEN   DC X'00'
r 002086=004A               #             DATALEN  DC X'004A'
r 002088=D9C5C37A           #             DATA     DC C'REC:'
r 00208C=01                 #             RECNUM   DS X
#
r 002090=00 0A 0000 0000ABCD   #             WAITPSW  DC    X'00',X'82',X'0000',X'000