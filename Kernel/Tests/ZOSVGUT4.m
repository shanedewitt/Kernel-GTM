ZOSVGUT4 ; OSE/SMH - Unit Tests for Capacity Management Community Port;2020-01-13  2:52 PM
 ;;8.0;KERNEL;**10003**;;
 ;
 ; (c) Sam Habiel 2018-2020
 ; Licensed under Apache 2.0
 D EN^%ut($t(+0),3)
 QUIT
 ;
CACHE() Q ^%ZOSF("OS")["OpenM"
GTM()   Q ^%ZOSF("OS")["GT.M"
STARTUP ;
 ; ZEXCEPT: KMPVTEST,hl7date
 ;
 ; Fix the email address to which messages are sent
 s hl7date=$$FMTHL7^XLFDT(DT)
 N FDA,DIERR
 N CNT S CNT=0
 N ZOSVV F ZOSVV="VTCM","VSTM","VBEM","VMCM","VHLM" D
 . S CNT=CNT+1
 . S FDA(8969,"?+"_CNT_",",.01)=ZOSVV
 . S FDA(8969,"?+"_CNT_",",.02)=1 ; ON/OFF
 . S FDA(8969,"?+"_CNT_",",1.04)=1 ; Allow Test System?
 . S FDA(8969,"?+"_CNT_",",3.01)="POSTMASTER"
 . S FDA(8969,"?+"_CNT_",",3.02)="POSTMASTER"
 . S FDA(8969,"?+"_CNT_",",3.03)="POSTMASTER"
 . S FDA(8969,"?+"_CNT_",",3.04)="POSTMASTER"
 D UPDATE^DIE("E","FDA")
 I $D(DIERR) S $EC=",U1,"
 F ZOSVV="VTCM","VSTM","VBEM","VMCM","VHLM" D STARTMON^KMPVCBG(ZOSVV,1)
 S KMPVTEST="TESTING"
 ;
 ; Set-up DUZ(2) if not there as we need it for some tests
 I '$D(DUZ(2)) D DUZ^XUP(.5)
 ;
 ; Set-up DUZ("AG") to not be "V"
 I $G(DUZ("AG"))="V" D
 . N FDA S FDA(8989.3,"1,","AGENCY CODE")="O"
 . N DIERR D FILE^DIE("","FDA")
 . I $D(DIERR) S $EC=",U-CHECK-ME,"
 . S DUZ("AG")="O"
 QUIT
 ;
SHUTDOWN ;
 ; ZEXCEPT: KMPVTEST,hl7date
 I $$GTM S $ZSOURCE="ZOSVGUT4"
 K KMPVTEST
 k hl7date
 QUIT
 ;
 ; -- RUM --
RUMSET ; @TEST ZTMGRSET RUM Rename GTM/Cache Routines
 N IOP,POP S IOP="NULL" D ^%ZIS U IO
 D PATCH^ZTMGRSET(10003)
 D ^%ZISC
 ; Picked this routine specifically as *10003* is for both GTM and Cache
 D CHKTF^%ut($T(+2^%ZOSVKSD)[10003)
 QUIT
 ;
LOGRSRC ; @TEST LOGRSRC^%ZOSV Resource Logger
 ; Turn it off and on again (just in case we are on a transplanted system and the xref is wrong)
 N FDA S FDA(8989.3,"1,",300)="@"
 D FILE^DIE(,"FDA")
 S FDA(8989.3,"1,",300)="Y"
 D FILE^DIE(,"FDA") ;
 ; Get these variables so that we can find out later if we got captured in ^KMPTMP
 N KMPVNODE,Y D GETENV^%ZOSV S KMPVNODE=$P(Y,U,3)_":"_$P($P(Y,U,4),":",2) ;  IA 10097
 N KMPVH S KMPVH=$H
 N KMPVSINT S KMPVSINT=$$GETVAL^KMPVCCFG("VBEM","COLLECTION INTERVAL",8969)
 I 'KMPVSINT S KMPVSINT=15
 N TIME S TIME=$P($$NOW^XLFDT,".",2)
 N KMPVHRSEC S KMPVHRSEC=$E(TIME,1,2)_":"_$E(TIME,3,4)
 N KMPVHOUR S KMPVHOUR=$P(KMPVHRSEC,":")
 N KMPVMIN S KMPVMIN=$P(KMPVHRSEC,":",2)
 N KMPVSLOT S KMPVSLOT=+$P(KMPVMIN/KMPVSINT,".")
 N KMPVHTIME S KMPVHTIME=(KMPVHOUR*3600)+(KMPVSLOT*KMPVSINT*60) ; Same as KMPVVTCM using KMPVHANG.
 ;
 ; Log our usage--second call to calcualte a difference from the first invocation.
 D LOGRSRC^%ZOSV("$UNIT TEST$^PROTOCOL",1,"NOT USED")
 D LOGRSRC^%ZOSV("$UNIT TEST$^PROTOCOL")
 ;
 ; Check that we got captured
 N OPT S OPT=""
 N FOUND S FOUND=0
 F  S OPT=$O(^KMPTMP("KMPV","VBEM","DLY",+KMPVH,KMPVNODE,KMPVHTIME,OPT)) Q:OPT=""  I OPT["$UNIT TEST$" S FOUND=1
 D CHKTF^%ut(FOUND)
 QUIT
 ;
 ; -- Capacity Management --
SYSINFO ; @TEST $$SYSINFO^KMPDUTL1 System Information
 D CHKTF^%ut($$SYSINFO^KMPDUTL1()["GT.M")
 QUIT
 ;
CPUINFO ; @TEST D CPU^KMPDUTL5 CPU Information
 N ZZZ
 D CPU^KMPDUTL5(.ZZZ)
 N HOST S HOST=$O(ZZZ(""))
 D CHKTF^%ut($L(ZZZ(HOST),U)=4) ; 4 pieces: process name, # cores, speed, system memory
 QUIT
 ;
ROUFIND ; @TEST ROUFIND^KMPDU2 Routine Find
 N RTN,GLOBAL
 S GLOBAL=$NA(^TMP($T(+0),$J))
 K @GLOBAL
 D ROUFIND^KMPDU2(.RTN,"XUS",GLOBAL)
 D CHKTF^%ut(@GLOBAL@(0)["XUS")
 K @GLOBAL
 D ROUFIND^KMPDU2(.RTN,"XUS*",GLOBAL)
 N CNT S CNT=0
 N I S I="" F  S I=$O(@GLOBAL@(I)) Q:I=""  S CNT=CNT+1
 D CHKTF^%ut(CNT>50)
 QUIT
 ;
COVER ; @TEST Cover Sheet Statistics Calculations
 S ^KMPTMP("KMPD-CPRS")=1
 ; Run covershet for up to 10 patients
 N DFN F DFN=0:0 S DFN=$O(^DPT(DFN)) Q:'DFN  Q:DFN>10  D COVER1(DFN)
 ;
 ; Move data to yesterday
 ; -1 from the $H in the first two pieces
 ; ^KMPTMP("KMPDT","ORWCV","ORWCV 169.254.170.40-00980054-1")="64889,42842^64889,42845^1^127.0.0.1"
 ; ^KMPTMP("KMPDT","ORWCV-FT","ORWCV 127.0.0.1-0xDead1085733-1")="64889,59568^64889,59603^.5^"
 N S1,S2
 F S1="ORWCV","ORWCV-FT" S S2="" F  S S2=$O(^KMPTMP("KMPDT",S1,S2)) Q:S2=""  D
 . N D S D=^KMPTMP("KMPDT",S1,S2)
 . N START S START=$P(D,U,1)
 . N END   S END=$P(D,U,2)
 . N NSTART,NEND S NSTART=START,NEND=END ; new start, end
 . S $P(NSTART,",",1)=$P(START,",",1)-1
 . S $P(NEND,",",1)=$P(END,",",1)-1
 . N ND S ND=D ; new D
 . S $P(ND,U,1)=NSTART
 . S $P(ND,U,2)=NEND
 . S ^KMPTMP("KMPDT",S1,S2)=ND
 ;
 ; Run nightly job
 D ^KMPDBD01
 D CHKTF^%ut(+$$RETURN^%ZOSV("wc -l "_$$DEFDIR^%ZISH_"KMPD/cvload-"_hl7date_".dat")>0)
 QUIT
 ;
COVER1(DFN) ; [Private] Inner worker for each patient
 ; Foreground Stats (starts first)
 N IP,HWND
 S IP=$R(255)_"."_$R(255)_"."_$R(255)_"."_$R(255)
 S HWND="0xDead"_$R(99999999)
 N XWBFGTIM S XWBFGTIM=$H
 N XWB S XWB(5,"P",0)=DFN,XWB(5,"P",1)=IP,XWB(5,"P",2)=HWND
 D STRTCVR1^XWBPRS
 ;
 ; Background Status
 N ZZZ
 D START^ORWCV(.ZZZ,DFN,IP,HWND)
 ;
 ; Switch to foreground stats again
 D STRTCVR2^XWBPRS(ZZZ)
 ;
 ; Run the RPCs for the foreground stats
 N XWBCSRPC
 S XWBCSRPC="ORQQPXRM REMINDERS UNEVALUATED" K ZZZ D LIST^ORQQPXRM(.ZZZ,1,0)     D ONECOVER^XWBPRS
 S XWBCSRPC="ORQQPXRM REMINDERS APPLICABLE"  K ZZZ D APPL^ORQQPXRM(.ZZZ,1,0)     D ONECOVER^XWBPRS
 S XWBCSRPC="ORQQPXRM REMINDERS CATEGORIES"  K ZZZ D CATEGORY^ORQQPXRM(.ZZZ,1,0) D ONECOVER^XWBPRS
 K ^TMP("XWBFGP",$J,"TODO")
 S XWBCSRPC="ORQQPX REMINDERS LIST"          K ZZZ D REMIND^ORQQPX(.ZZZ,1)       D ONECOVER^XWBPRS
 ;
 ; Poll for the Background Job
 N I F I=1:1 K ZZZ D POLL^ORWCV(.ZZZ,DFN,IP,HWND) Q:$G(ZZZ(1))["DONE"  Q:I>10  H 1
 I I>10 D FAIL^%ut("BG CV Job never finished. Is taskman running?")
 QUIT
 ;
SAGG ; @TEST SAGG Data Collection
 D ^KMPSGE
 D CHKTF^%ut(+$$RETURN^%ZOSV("wc -l "_$$DEFDIR^%ZISH_"KMPS/files-"_hl7date_".dat")>1000)
 D CHKTF^%ut(+$$RETURN^%ZOSV("wc -l "_$$DEFDIR^%ZISH_"KMPS/globals-"_hl7date_".dat")>100)
 D CHKTF^%ut(+$$RETURN^%ZOSV("wc -l "_$$DEFDIR^%ZISH_"KMPS/packages-"_hl7date_".dat")>100)
 D CHKTF^%ut(+$$RETURN^%ZOSV("wc -l "_$$DEFDIR^%ZISH_"KMPS/taskman-"_hl7date_".dat")>0)
 D CHKTF^%ut(+$$RETURN^%ZOSV("wc -l "_$$DEFDIR^%ZISH_"KMPS/version-"_hl7date_".dat")>0)
 D CHKTF^%ut(+$$RETURN^%ZOSV("wc -l "_$$DEFDIR^%ZISH_"KMPS/volumes-"_hl7date_".dat")>0)
 QUIT
 ;
 ; -- VistA System Monitor Unit Tests --
 ;
VSTM ; @TEST VSM Storage Monitor
 K ^KMPTMP("KMPV","VSTM")
 D RUN^KMPVVSTM
 D CHKTF^%ut(+$$RETURN^%ZOSV("wc -l "_$$DEFDIR^%ZISH_"KMPV/VSTM-"_hl7date_".dat")>0)
 D SEND^KMPVVSTM
 D SUCCEED^%ut
 QUIT
 ;
VBEM ; @TEST VSM Business Event Monitor (replaces old CM task)
 ; make sure RUM is on - this test runs after LOGRSRC above, which turns it on and records data.
 K ^KMPTMP("KMPV","VBEM","TRANSMIT")
 K ^KMPTMP("KMPV","VBEM","COMPRESS")
 ; Only runs on Yesterday's data!
 M ^KMPTMP("KMPV","VBEM","DLY",+$H-1)=^KMPTMP("KMPV","VBEM","DLY",+$H)
 D ^KMPVBETR
 D CHKTF^%ut($data(^KMPTMP("KMPV","VBEM","COMPRESS")))
 D CHKTF^%ut(+$$RETURN^%ZOSV("wc -l "_$$DEFDIR^%ZISH_"KMPV/VBEM-"_hl7date_".dat")>0)
 QUIT
 ;
VHLM ; @TEST VSM Section HL7 mointor
 ; Turn on patient registration messages
 N IEN43 S IEN43=$O(^DG(43,0))
 I 'IEN43 D FAIL^%ut("MAS PARAMETERS NOT DEFINED") QUIT
 S $P(^DG(43,IEN43,"HL7"),U,2,3)="1^1"
 ;
 ; Create patient registration message
 N $ET,$ES S $ET="D VHLMERR^ZOSVGUT4"
 N DFN S DFN=1
 N % S %=$$EN^VAFCA04(DFN,$$NOW^XLFDT)
 ;
 ; Get Registration Message Number
 N PIVOT S PIVOT=$O(^VAT(391.71," "),-1)
 N MESS S MESS=$G(^VAT(391.71,PIVOT,1))
 I 'MESS D FAIL^%ut("Message not generated") QUIT
 ;
 ; Get Message number in HLMA (message - site number from the beginning)
 N SITE S SITE=+$P($$PARAM^HLCS2,U,6)
 N HLMA S HLMA=$P(MESS,SITE,2,99)
 ;
 ; Get HL7 message number
 N HLIEN S HLIEN=+^HLMA(HLMA,0)
 ;
 ; Backdate the message by one day for our testing
 N DATE   S DATE=+^HL(772,HLIEN,0)
 N NDATE S NDATE=$$FMADD^XLFDT(DATE,-1)
 N FDA S FDA(772,HLIEN_",",.01)=NDATE
 D FILE^DIE(,"FDA")
 ;
 D ^KMPVVHLM
 D CHKTF^%ut(+$$RETURN^%ZOSV("wc -l "_$$DEFDIR^%ZISH_"KMPV/VHLM-"_hl7date_".dat")>1)
 QUIT
 ;
VHLMERR ;
 S $ET="W ""EMERGENCY"" HALT"
 ; The following is an expected error due to 2 digit vs 3 digit site numbers
 I $ST($ST-1,"PLACE")["RGADTP" S $EC="" QUIT  ; clear error and just continue
 D ^%ZTER
 S $EC=""
 S $ET="B"
 D UNWIND^ZU
 QUIT
 ;
VMCM ; @TEST VSM Message Count Monitor
 ; This one runs perpetually. The only way to stop is it to kill it.
 ; thus the HALTONE^ZSY.
 ; ZEXCEPT: IN,OUT,ERROR
 K ^KMPTMP("KMPV","VMCM","DLY",+$H)
 N %J
 I $$GTM D
 . J ^KMPVVMCM:(IN="/dev/null":OUT="/dev/null":ERROR="/dev/null")
 . S %J=$ZJOB
 . D CHKTF^%ut($zgetjpi(%J,"isprocalive"))
 . H 1
 . D HALTONE^ZSY(%J)
 . F  Q:'$zgetjpi(%J,"isprocalive")  H .001 ; Wait around til shi
 I $$CACHE D
 . J ^KMPVVMCM
 . S %J=$ZCHILD
 . D CHKTF^%ut($D(^$J(%J)))
 . H 1
 . N % S %=$ZU(4,$J)
 . F  Q:'$D(^$J(%J))  H .001 ; Wait around till death
 D SEND^KMPVVMCM
 D CHKTF^%ut(+$$RETURN^%ZOSV("wc -l "_$$DEFDIR^%ZISH_"KMPV/VMCM-"_hl7date_".dat")>1)
 QUIT
 ;
VTCM ; @TEST VSM Timed Collection Monitor
 ; This one runs perpetually. The only way to stop is it to kill it.
 ; thus the HALTONE^ZSY.
 ; ZEXCEPT: IN,OUT,ERROR
 K ^KMPTMP("KMPV","VTCM","DLY",+$H)
 N %J
 I $$GTM D
 . J ^KMPVVTCM:(IN="/dev/null":OUT="/dev/null":ERROR="/dev/null")
 . S %J=$ZJOB
 . D CHKTF^%ut($zgetjpi(%J,"isprocalive"))
 . H 1
 . D HALTONE^ZSY(%J)
 . F  Q:'$zgetjpi(%J,"isprocalive")  H .001 ; Wait around til shi
 I $$CACHE D
 . J ^KMPVVTCM
 . S %J=$ZCHILD
 . D CHKTF^%ut($D(^$J(%J)))
 . H 1
 . N % S %=$ZU(4,$J)
 . F  Q:'$D(^$J(%J))  H .001 ; Wait around till death
 D SEND^KMPVVTCM
 D CHKTF^%ut(+$$RETURN^%ZOSV("wc -l "_$$DEFDIR^%ZISH_"KMPV/VTCM-"_hl7date_".dat")>1)
 QUIT
 ;
TASK ; @TEST Task Creator
 ; This just prints a message rather than crash
 N IOP,POP S IOP="NULL" D ^%ZIS U IO
 D KMPVTSK^KMPVCBG
 D ^%ZISC
 D SUCCEED^%ut
 QUIT
 ;
PATCHS ; @TEST Test SAGG Patch Listing that they are correct
 N X D VERPTCH^KMPDUTL1("S",.X)
 D TF^%ut(+$P(X(0),U,3)=0)
 QUIT
 ;
PATCHD ; @TEST Test CM Patch Listing that they are correct
 N X D VERPTCH^KMPDUTL1("D",.X)
 D TF^%ut(+$P(X(0),U,3)=0)
 QUIT
