%ZISUTL ;ISD/HGW - Device Handler Utility routine ; 8/19/20 10:51am
 ;;8.0;KERNEL;**18,24,34,69,118,127,199,275,425,599,736**;JUL 10, 1995;Build 12
 ;Per VHA Directive 2004-038, this routine should not be modified
 ; Unit test routine ^ZZUTZI00
 Q  ;No entry from top
GETDEV(X) ;Return IO variables
 ; ZEXCEPT: POP
 I '$D(^TMP("XUDEVICE",$J,X)) S POP=1 Q
 ;Cleanup first
 N % K IO("S")
 D SYMBOL("K") ;Kill first
 D SYMBOL(1,$NA(^TMP("XUDEVICE",$J,X)))
 Q
SAVDEV(NM) ;Save IO variables
 ;NM=Handle name
 N %,Y,R
 I $G(IO)="" Q
 S Y=$$FINDEV(NM) I 'Y S Y=$$NEXTDEV(NM)
 S R=$NA(^TMP("XUDEVICE",$J,Y)) K @R ;Clear
 S @R@(0)=NM
 D SYMBOL(0,R)
 Q
SYMBOL(MODE,ROOT) ;0=Save, 1=Restore, K=Kill IO variables
 N %
 ;Handle IO as special case.  Don't want to kill all of IO.
 I MODE=0 S:$D(IO)#2 @ROOT@("IO")=IO
 I MODE=1 S:$D(@ROOT@("IO")) IO=@ROOT@("IO")
 F %="IO(""DOC"")","IO(""HFSIO"")","IO(""Q"")","IO(""S"")","IO(""SPOOL"")","IO(""ZIO"")","IOBS","IOCPU","IOF","IOHG","IOM","ION","IOPAR","IOUPAR","IOS","IOSL","IOST","IOST(0)","IOT","IOXY" D
 . I MODE=0 S:$D(@%)#2 @ROOT@(%)=@% Q
 . I MODE=1 S:$D(@ROOT@(%)) @%=@ROOT@(%) Q
 . I MODE="K" K @%
 . Q
 Q
RMDEV(X) ;Remove saved IO variables.
 N Y
 S Y=$$FINDEV(X)
 Q:'Y
 K ^TMP("XUDEVICE",$J,"B",X),^TMP("XUDEVICE",$J,+Y)
 Q
RMALLDEV() ;Remove saved IO variables for all devices saved in table.
 K ^TMP("XUDEVICE",$J)
 Q 1
FINDEV(NM) ;Find Device name and return IEN.
 Q $O(^TMP("XUDEVICE",$J,"B",NM,0))
NEXTDEV(NM) ;Return next available device.
 N Y
 F Y=1:1 Q:'$D(^TMP("XUDEVICE",$J,Y))
 S ^TMP("XUDEVICE",$J,"B",NM,Y)=""
 Q Y
OPEN(HNDL,IOP,%ZIS) ;Open extrinsic function
 ;Parameters
 ;HNDL=Handle name
 ;IOP string--optional
 ;%ZIS string--optional
 N %
 I $G(IOP)="" K IOP ;Remove IOP if null.
 D ^%ZIS,SAVDEV(HNDL):POP=0
 Q
CLOSE(X1) ;Close extrinsic function
 ;X1=Handle
 N %,Y
 S Y=$$FINDEV(X1)
 Q:'Y
 D GETDEV(Y)
 D ^%ZISC,RMDEV(X1)
 Q
USE(X1) ;Restore IO* variables pertaining to the device.
 ;X1=Handle name
 ; ZEXCEPT: IOT
 N %,Y
 S Y=$$FINDEV^%ZISUTL(X1)
 Q:'Y
 D GETDEV^%ZISUTL(Y)
 I $G(IOT)'="RES" U $S($D(IO(1,IO)):IO,1:IO(0))
 K IO("CLOSE")
 Q
LINEPORT() ;Return device name for line port.
 N %
 S %=$$LNPRTIEN^%ZISUTL($$LNPRTNAM^%ZISUTL)
 Q +$P($G(^%ZIS(3.23,+%,0)),"^",3)
LNPRTSUB() ;Return line port subtype pointer.
 N %
 S %=$$LNPRTIEN^%ZISUTL($$LNPRTNAM^%ZISUTL)
 Q +$P($G(^%ZIS(3.23,+%,0)),"^",4)
LNPRTNAM() ;Return Line port name
 N Y,%
 S Y="",%=$G(^%ZOSF("OS"))
 I %["VAX DSM"!(%["OpenM-NT") D
 .S Y=$ZIO
 E  I %["MSM" X "S Y=$ZDEV($I)"
 Q Y
LNPRTIEN(X) ;Return internal entry number of Line/port
 Q:X'?1AN.29ANP 0
 Q $O(^%ZIS(3.23,"B",X,0))
LNPRTADR(X) ;Returns Line/Port name of a fixed device.
 N %,Y
 S Y=""
 S %=$O(^%ZIS(1,"B",X,0))
 S %=$O(^%ZIS(3.23,"C",+%,0))
 I %,$G(^%ZIS(3.23,+%,0))]"" S Y=$P(^(0),"^")
 Q Y
FIND(IOP) ;e.f. Get the IEN of a device
 N %XX,%YY,%ZIS,%ZISV
 S %ZISV=^%ZOSF("VOL"),%XX=$$UP^%ZIS1(IOP) D 1^%ZIS5
 Q %YY
NOQ(IOP) ;e.f. Return queueing status
 ;Call with Device name, Return 1 if NO QUEUE, Else 0.
 N %X,%Y S %X=$$FIND(IOP) Q:%X'>0 0
 S %Y=$P($G(^%ZIS(1,%X,0)),U,12)
 Q %Y=2
UNIQUE(ZISNA) ;Build a unique number to add to a device name
 ;If passed a name put the number before the last dot.
 N %,%1,%2
 S %2=$INCREMENT(^TMP("ZISUTL",$J))  ;Kernel exemption, allowed to use $INCREMENT
 S %=$H,%=$H_"-"_$J,%=$$CRC32^XLFCRC(%)_"-"_%2
 I '$L($G(ZISNA)) Q %
 S %1=$L(ZISNA,"."),%="_"_%
 S:%1=1 %=ZISNA_% S:%1>1 %=$P(ZISNA,".",1,%1-1)_%_"."_$P(ZISNA,".",%1)
 Q %
ENDOFILE() ;p599 Set Cache end-of-file to work like DSM
 ;Return 1 if mode was changed, 0 if unchanged
 N %
 I ($$VERSION^%ZOSV(1)["Cache")!($$VERSION^%ZOSV(1)["IRIS") D  Q 1
 .I +$$VERSION^%ZOSV>2010 X "D $SYSTEM.Process.SetZEOF(1)"
 .I +$$VERSION^%ZOSV'>2010 S %=$ZUTIL(68,40,1)
 Q 0
