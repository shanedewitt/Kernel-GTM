XUMF675P ;OIFO-BP/BATRAN - MFS parameters file ;01/19/2016
 ;;8.0;KERNEL;**675**;Jul 10, 1995;Build 17
 ;Per VA Directive 6402, this routine should not be modified.
 Q
 ;----------------------------------------------
POST ; -- Entry point
 N XUMF S XUMF=1
 D 89261
 N X S X="XUMF675" X ^%ZOSF("DEL")
 K XMY
 Q
 ;----------------------------------------------
TEST ; -- Entry point
 N XUMF S XUMF=1
 S XMY("G.XUPATH@DOMAIN.EXT")=""
 D 89261
 K XMY
 Q
 ;---------------------------------------------
89261 ; FILE 8926.1 TIU VHA ENTERPRISE STANDARD TITLE
 N XFIEN,XFILE
 S XFIEN=8926.1
 S XFILE="TIU Titles"
 S XUIEN=$O(^DIC(4.001,"B",XFIEN,0)) ;Get existed IEN
 I XUIEN>0 D DEL^XUMF675(XUIEN) ; delete entry
 D DEL^XUMF675(XFIEN) ; delete entry
 D ADD^XUMF675(XFIEN,".03;TIU Titles].07;TIU Titles]5;D ZRT^TIUZRT]2;D MFSUP^HDISVF09(8926.1,$G(ERROR)),BULL^TIUDD61]4.8;B") ; add entry
 D NODES^XUMF675(XFIEN,"DATA675",8) ; call ADD1 to add sub_entry
 D DELMD5^XUMF675(XFILE)
 D ADDMD5^XUMF675(XFILE,XFIEN)
 D SCMD5^XUMF675(XFILE,XFIEN)
 D SUBMD5^XUMF675(XFILE,".01^20^^^",XFIEN,.01)
 D SUBMD5^XUMF675(XFILE,".04^30^^8926.2^",XFIEN,.04)
 D SUBMD5^XUMF675(XFILE,".05^40^^8926.3^",XFIEN,.05)
 D SUBMD5^XUMF675(XFILE,".06^50^^8926.4^",XFIEN,.06)
 D SUBMD5^XUMF675(XFILE,".07^60^^8926.5^",XFIEN,.07)
 D SUBMD5^XUMF675(XFILE,".08^70^^8926.6^",XFIEN,.08)
 D SUBMD5^XUMF675(XFILE,"99.99^10^^^",XFIEN,99.99)
 S XFIEN=8926.12
 D SCMD5^XUMF675(XFILE,XFIEN)
 D SUBMD5^XUMF675(XFILE,".01^25^^^^D M89261^TIUZRT",XFIEN,.01)
 Q
 ;----------------------------------------------------
