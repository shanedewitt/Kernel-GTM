ZOSVGUT6 ; OSE/SMH - Unit Tests for GT.M VistA Port;2019-12-26  2:11 PM
 ;;8.0;KERNEL;**10006**;;
 ;
 ; (c) Sam Habiel 2019
 ; Licensed under Apache 2.0
 ;
 D EN^%ut($t(+0),3)
 QUIT
 ;
ZTMGRSET ; @TEST ZTMGRSET Rename Routines ; *10006*
 D PATCH^ZTMGRSET(10006)
 D CHKTF^%ut($T(+2^%ZOSV2)[10006)
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
DELDEV ; @TEST *10006 DEL^%ZOSV2 does not preserve current device
 N XCN,DIE
 S XCN=0,DIE=$$OREF^DILF($NA(^TMP($J)))
 K ^TMP($J)
 S ^TMP($J,$I(XCN),0)="KBANHELLO ; VEN/SMH - Sample Testing Routine"
 S ^TMP($J,$I(XCN),0)=" ;;"
 S ^TMP($J,$I(XCN),0)=";this is not supposed to be saved"
 S ^TMP($J,$I(XCN),0)=" WRITE ""HELLO WORLD"""
 S ^TMP($J,$I(XCN),0)=" QUIT"
 S XCN=0
 D SAVE^%ZOSV2("KBANHELLO")
 do tf^%ut($T(+1^KBANHELLO)["Sample")
 ;
 n file s file="/tmp/boo-"_$R(9999999)
 o file:newversion
 u file
 do eq^%ut($IO,file,"io 1")
 D DEL^%ZOSV2("KBANHELLO")
 do eq^%ut($IO,file,"io 2")
 c file:delete
 quit
