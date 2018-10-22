ZOSVGUT5 ; OSE/SMH - Unit Tests for GT.M VistA Port;Oct 22, 2018@10:32
 ;;8.0;KERNEL;**10004**;;
 ;
 D EN^%ut($t(+0),3)
 QUIT
 ;
ZTMGRSET ; @TEST ZTMGRSET Rename GTM Routines
 D PATCH^ZTMGRSET(10004)
 D CHKTF^%ut($T(+2^%ZOSV)[10004)
 QUIT
 ;
EC ; @TEST $$EC^%ZOSV
 N EC
 N V S V=$name(^PS(222,333,444,555,666,777,888))
 D
 . N $ET,$ES S $ET="S EC=$$EC^%ZOSV,$EC="""" D UNWIND^ZU"
 . I @V
 D CHKTF^%ut($P(EC,",",4)["GVUNDEF")
 QUIT
 ;
ZSY ; RUN ZSY with lsof in sbin
 D ^ZSY
 D SUCCEED^%ut
 QUIT
 ;
ACTJ ; Use of $T +0
 D CHKTF^%ut($$ACTJ^%ZOSV)
 QUIT
 ;
PATCH ; @TEST $$PATCH^XPDUTL, which prv accepted only 3 digits
 D CHKTF^%ut($$PATCH^XPDUTL("XU*8.0*10001"))
 QUIT
 ;
MAXREC ; @TEST $$MAXREC^%ZISH - $T +0
 D CHKTF^%ut($$MAXREC^%ZISH("^DD"))
 D CHKTF^%ut($$MAXREC^%ZISH($NA(^TMP("SAM",$J))))
 QUIT
