ZOSVGUT6 ; OSE/SMH - Unit Tests for GT.M VistA Port;2019-12-26  10:53 AM
 ;;8.0;KERNEL;**10006**;;
 ;
 ; (c) Sam Habiel 2019
 ; Licensed under Apache 2.0
 ;
 D EN^%ut($t(+0),3)
 QUIT
 ;
ZOSFGUX1 ; @TEST *10006 NOASK^ZOSFGUX
 kill ^%ZOSF("GSEL")
 kill ^%ZOSF("XY")
 new oldvol set oldvol=^%ZOSF("VOL")
 do NOASK^ZOSFGUX
 do tf^%ut($data(^%ZOSF("GSEL")))
 do tf^%ut($data(^%ZOSF("XY")))
 do eq^%ut(^%ZOSF("VOL"),oldvol)
 quit
 ;
ZOSFGUX2 ; @TEST *10006 ONE^ZOSFGUX
 new gsel set gsel=^%ZOSF("GSEL")
 kill ^%ZOSF("GSEL")
 kill ^%ZOSF("XY")
 new oldvol set oldvol=^%ZOSF("VOL")
 do ONE^ZOSFGUX("XY")
 do tf^%ut('$data(^%ZOSF("GSEL")))
 do tf^%ut($data(^%ZOSF("XY")))
 do eq^%ut(^%ZOSF("VOL"),oldvol)
 set ^%ZOSF("GSEL")=gsel
 quit
 ;
RESJOB ; @TEST *10006 ^%ZOSF("RESJOB") indirectly
 ; ZEXCEPT: input,output,error,TESTJOB
 X ^%ZOSF("RESJOB")
 do succeed^%ut
 ;
 J TESTJOB:(input="/dev/null":output="/dev/null":error="/dev/null")
 N %J S %J=$ZJOB
 D CHKTF^%ut($zgetjpi(%J,"isprocalive"))
 D KILLJOB^ZSY(%J)
 H .01
 D CHKTF^%ut('$zgetjpi(%J,"isprocalive"))
 QUIT
 ;
TESTJOB ; [Private] Entry point for a test job to kill
 HANG 100
 QUIT
 ;
