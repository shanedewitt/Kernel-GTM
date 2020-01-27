KMPSGE ;OAK/KAK/JML - Master Routine;2020-01-10  11:42 AM ;Jan 24, 2020@17:15
 ;;2.0;SAGG PROJECT;**1,10001**;Jul 02, 2007;Build 5
 ; Original Code by Department of Veterans Affairs in Public Domain
 ; *10001* (c) Sam Habiel 2018,2020
 ; Changes licensed under Apache 2.0.
 ;
EN ;-- this routine can only be run as a TaskMan background job (fg ok for GT.M)
 ;
 ; *10001* Remove ZTQUEUED requirement
 ;
 N CNT,COMPDT,HANG,KMPSVOLS,KMPSZE,LOC,MAXJOB,MGR,NOWDT,OS
 N PROD,PTCHINFO,QUIT,SESSNUM,SITENUM,TEMP,TEXT,UCI,UCIVOL
 N VOL,X,ZUZR,RESULT,XMZSENT
 ;
 ; maximum number of consecutively running jobs
 S MAXJOB=6
 ; hang time for LOOP and WAIT code
 S HANG=1 ; *10001* changed from 300 to 1 sec. I think 300 is from 1998's computers.
 ;
 S SESSNUM=+$H,U="^",SITENUM=$P($$SITE^VASITE(),U,3)
 ;
 S NOWDT=$$NOW^XLFDT
 ;
 S OS=$$MPLTF^KMPSUTL1
 I OS="UNK" D  Q
 .S TEXT(1)="   SAGG Project for this M platform is NOT implemented !"
 .D MSG^KMPSLK(NOWDT,SESSNUM,.TEXT)
 ;
 S MGR=^%ZOSF("MGR"),PROD=$P(^%ZOSF("PROD"),",")
 S PROD=$S($P(^KMPS(8970.1,1,0),U,3)="":PROD,1:$P(^(0),U,3))
 S LOC=$P(^KMPS(8970.1,1,0),U,2)
 ;
 L +^XTMP("KMPS")
 S ^XTMP("KMPS",0)=$$FMADD^XLFDT($$DT^XLFDT,14)_U_NOWDT_U_"SAGG data"
 K ^XTMP("KMPS",SITENUM),^XTMP("KMPS","ERROR")
 K ^XTMP("KMPS","START"),^XTMP("KMPS","STOP")
 ;
 ; routine KMPSUTL will always be updated with patch release
 S PTCHINFO=$T(+2^KMPSUTL) ; *10001* ; don't use ZLOAD -- that's silly
 S PTCHINFO=$P(PTCHINFO,";",3)_" "_$P(PTCHINFO,";",5)
 ; session number^M platform^SAGG version_" "_patch^start date-time^
 ;     -> completed date-time will be set in $$PACK
 S ^XTMP("KMPS",SITENUM,0)=SESSNUM_U_OS_U_PTCHINFO_U_NOWDT_U
 N $ET,$ES S $ET="D ERR1^KMPSGE" ; *10001* use $ET, not $ZT
 S TEMP=SITENUM_U_SESSNUM_U_LOC_U_NOWDT_U_PROD
 ;
 ; GT.M all OSes
 I OS="GTM" D START^%ZOSVKSE(TEMP)  ; *10001* Do not Job on GTM since only a single "volume"
 ;
 ; KMPS*2.0*1 - Now analyzing all volumes, not just those in the SAGG PROJECT file
 I $E(OS)="C" D  ; Cache
 .S CNT=0
 .S VOL=""
 .F  S VOL=$O(^|"%SYS"|SYS("UCI",VOL)) Q:VOL=""  D
 ..Q:$G(^|"%SYS"|SYS("UCI",VOL))]""
 ..J START^%ZOSVKSE(TEMP_U_VOL)
 ..S CNT=CNT+1
 ..I CNT=MAXJOB S CNT=$$WAIT(HANG,MAXJOB)
 ;
 D EN^KMPSLK(SESSNUM,SITENUM)
 S QUIT=0
 D LOOP(HANG,SESSNUM,OS)
 I 'QUIT D
 .I '$$VA^KMPVLOG D LOG(SESSNUM,SITENUM,OS) QUIT  ; *10001* Dump Output to $HFS/KMPS/
 .E  S RESULT=$$PACK(SESSNUM,SITENUM)         ; *10001* Previous VA behavior unchanged
 .S XMZSENT=+RESULT,COMPDT=$P(RESULT,U,2)
 .S X=$$OUT^KMPSLK(NOWDT,OS,SESSNUM,SITENUM,XMZSENT,.TEXT)
 .D MSG^KMPSLK(NOWDT,SESSNUM,.TEXT,COMPDT)
 D END^KMPSLK
 Q
 ;
LOOP(HANG,SESSNUM,OS) ;
 ;---------------------------------------------------------------------
 ; Loop until all volume sets complete
 ;
 ; HANG.....  time to wait to see if all volume sets have completed
 ; OS.......  type of operating system
 ; SESSNUM..  +$Horolog number of session
 ;---------------------------------------------------------------------
 N GBL,UCIVOL1,I
 ;
 F  Q:'$D(^XTMP("KMPS","START"))!+$G(^XTMP("KMPS","STOP"))  H HANG I (+$H>(SESSNUM+3)) D TOOLNG Q
 ;
 Q:QUIT
 ;
 I $D(^XTMP("KMPS","ERROR")) D  Q
 .N J,JEND,OUT,TEXT,VOL
 .S QUIT=1
 .S TEXT(1)=" The SAGG Project has recorded an error on volume set(s):"
 .S OUT=0,VOL="",JEND=$S(OS="CVMS":2,OS="CWINNT":4,1:5)
 .F I=3:1 Q:OUT  D
 ..S TEXT(I)="      "
 ..F J=1:1:JEND S VOL=$O(^XTMP("KMPS","ERROR",VOL)) S:VOL="" OUT=1 Q:VOL=""  S TEXT(I)=TEXT(I)_VOL_"   "
 .S (TEXT(2),TEXT(I))=""
 .S TEXT(I+1)=" See system error log for more details."
 .I OS["C" D
 ..S TEXT(I+2)=""
 ..S TEXT(I+3)=" Also run "_$S(OS="CVMS":"Integrity",1:"INTEGRIT")_" on the listed volume(s)."
 .D MSG^KMPSLK(NOWDT,SESSNUM,.TEXT)
 ;
 I $D(^XTMP("KMPS","STOP")) D  Q
 .N TEXT
 .S QUIT=1
 .S TEXT(1)=" The SAGG Project collection routines have been STOPPED!  No report"
 .S TEXT(2)=" has been generated."
 .D MSG^KMPSLK(NOWDT,SESSNUM,.TEXT)
 ;
 I '$D(^XTMP("KMPS",SITENUM,SESSNUM,NOWDT)) D  Q
 .N TEXT
 .S QUIT=1
 .S TEXT(1)=" The SAGG Project collection routines did NOT obtain ANY global"
 .S TEXT(2)=" information.  Please ensure that the SAGG PROJECT file is"
 .S TEXT(3)=" properly setup.  Then use the 'One-time Option Queue' under"
 .S TEXT(4)=" Task Manager to re-run the 'SAGG Master Background Task'"
 .S TEXT(5)=" [KMPS SAGG REPORT] option."
 .D MSG^KMPSLK(NOWDT,SESSNUM,.TEXT)
 ;
 Q
 ;
LOG(SESSNUM,SITENUM,OS) ; [Private] Log output into $HFS/KMPS/...
 ; SESSNUM..  +$Horolog number of session
 ; SITENUM..  site number
 ;
 N COMPDT S COMPDT=$$NOW^XLFDT
 S $P(^XTMP("KMPS",SITENUM,0),U,5)=COMPDT
 ;
 ; Delete Old Files
 N DAYS S DAYS=14*4 ; keep data for 56 days, or 4 runs
 D DELLOG^KMPVLOG("KMPS","globals",DAYS)
 D DELLOG^KMPVLOG("KMPS","packages",DAYS)
 D DELLOG^KMPVLOG("KMPS","version",DAYS)
 D DELLOG^KMPVLOG("KMPS","volumes",DAYS)
 D DELLOG^KMPVLOG("KMPS","files",DAYS)
 D DELLOG^KMPVLOG("KMPS","taskman",DAYS)
 ;
 ; SAGG Globals are not in a writable format; they are sent to Albany as
 ; Packman globals. We will reorganize to make it in a usable format.
 ; Line 1 is the header
 ;
 ; 1. Export the global sizes
 K ^TMP($J,"KMPVLOG")
 N L S L=1
 I OS="GTM" S ^TMP($J,"KMPVLOG",L)="GLOBAL^BLOCKS^BLOCK SIZE^BYTES^ADJACENCY^REGION^ACCESS METHOD^JOURNALING STATE^JOURNAL FILE^J SETS^J KILLS"
 ; Blocks ^ Pointer Blocks ^ Total Bytes ^ Pointer Bytes ^ Big Blocks
 ; ^ Big Bytes ^ Big Strings ^ Data size ^ Top Pointer Block
 ; ^ Top Pointer Eff ^ Bottom Pointer Block ^ Bottom Pointer Eff
 ; ^ Pointer Block - Pointer Eff ; Pointer Block - Pointer Eff ; etc
 ; ^ Data Block ^ Data Eff ^ Big Strings Block ^ Big Strings Eff
 E  I $E(OS)="C" D
 . S ^TMP($J,"KMPVLOG",L)="BLOCKS^POINTER BLOCKS^TOTAL BYTES^POINTER BYTES^BIG BLOCKS^BIG BYTES^BIG STRINGS^DATA SIZE"
 . S ^(L)=^(L)_"^TOP POINTER BLOCK^TOP POINTER EFF%^BOTTOM POINTER BLOCK^BOTTOM POINTER EFF%^POINTER DATA^DATA BLOCK^DATA EFF%^BIG STRINGS BLOCK^BIG STRINGS EFF%" ; **naked**
 S L=L+1
 N H S H=+$H
 N D S D=$O(^XTMP("KMPS",SITENUM,H,""))
 N GLO S GLO=""
 N GLD S GLD="" ; global directory file; useless here.
 F  S GLO=$O(^XTMP("KMPS",SITENUM,H,D,GLO)) Q:GLO=""  D
 . F  S GLD=$O(^XTMP("KMPS",SITENUM,H,D,GLO,GLD)) Q:GLD=""  D
 .. N MYGLO ; rm the ^ from the global nam
 .. I $E(GLO)=U S MYGLO=$P(GLO,U,2)
 .. E  S MYGLO=GLO
 .. S ^TMP($J,"KMPVLOG",L)=MYGLO_U_^XTMP("KMPS",SITENUM,H,D,GLO,GLD)
 .. S L=L+1
 D EN^KMPVLOG($NA(^TMP($J,"KMPVLOG")),"KMPS","globals","W",1)
 ;
 ; 2. Export Installed Packages Information
 K ^TMP($J,"KMPVLOG")
 N L S L=1
 S ^TMP($J,"KMPVLOG",L)="PACKAGE NAME^NAMESPACE^CURRENT VERSION^INSTALL VERSION^INSTALL DATE"
 S L=L+1
 N PKGNAME S PKGNAME=""
 F  S PKGNAME=$O(^XTMP("KMPS",SITENUM,H,"@PKG",PKGNAME)) Q:PKGNAME=""  D
 . S ^TMP($J,"KMPVLOG",L)=PKGNAME_U_^XTMP("KMPS",SITENUM,H,"@PKG",PKGNAME)
 . S L=L+1
 D EN^KMPVLOG($NA(^TMP($J,"KMPVLOG")),"KMPS","packages","W",1)
 ;
 ; 3. Export system version
 K ^TMP($J,"KMPVLOG")
 N L S L=1
 S ^TMP($J,"KMPVLOG",L)="MUMPS VIRTUAL MACHINE NAME AND VERSION^WINDOWS VERSION (CACHE ONLY)"
 S L=L+1
 S ^TMP($J,"KMPVLOG",L)=^XTMP("KMPS",SITENUM,H,"@SYS")
 D EN^KMPVLOG($NA(^TMP($J,"KMPVLOG")),"KMPS","version","W",1)
 ;
 ; 4. Volume sets block counts (regions in GTM)
 K ^TMP($J,"KMPVLOG")
 N L S L=1
 S ^TMP($J,"KMPVLOG",L)="VOLUME NAME^BLOCK COUNT"
 S L=L+1
 N VOL S VOL=""
 F  S VOL=$O(^XTMP("KMPS",SITENUM,H,"@VOL",VOL)) Q:VOL=""  D
 . S ^TMP($J,"KMPVLOG",L)=VOL_U_^XTMP("KMPS",SITENUM,H,"@VOL",VOL)
 . S L=L+1
 D EN^KMPVLOG($NA(^TMP($J,"KMPVLOG")),"KMPS","volumes","W",1)
 ;
 ; 5. Fileman files information
 K ^TMP($J,"KMPVLOG")
 N L S L=1
 S ^TMP($J,"KMPVLOG",L)="FILE NAME^# OF ENTRIES^GLOBAL^FILE VERSION^LAST IEN"
 S L=L+1
 N FILE S FILE=""
 ; +FILE'=FILE is intentional. There is a TM sub which I don't want to capture
 ; Also, file 0 is ^DIC, which I want to capture too.
 F  S FILE=$O(^XTMP("KMPS",SITENUM,H,"@ZER",FILE)) Q:+FILE'=FILE  D
 . S ^TMP($J,"KMPVLOG",L)=^XTMP("KMPS",SITENUM,H,"@ZER",FILE)
 . S L=L+1
 D EN^KMPVLOG($NA(^TMP($J,"KMPVLOG")),"KMPS","files","W",1)
 ;
 ; 6. Taskman last entry
 K ^TMP($J,"KMPVLOG")
 N L S L=1
 S ^TMP($J,"KMPVLOG",L)="Last Task #"
 S L=L+1
 S ^TMP($J,"KMPVLOG",L)=^XTMP("KMPS",SITENUM,H,"@ZER","TM")
 D EN^KMPVLOG($NA(^TMP($J,"KMPVLOG")),"KMPS","taskman","W",1)
 ;
 ; Bye!
 K ^TMP($J,"KMPVLOG")
 QUIT
 ;
PACK(SESSNUM,SITENUM) ;
 ;---------------------------------------------------------------------
 ; PackMan ^XTMP global to KMP1-SAGG-SERVER at Albany FO
 ;
 ; SESSNUM..  +$Horolog number of session
 ; SITENUM..  site number
 ;
 ; Return:
 ; RETURN...  number of SAGG data message^completed date-time
 ;---------------------------------------------------------------------
 ;
 N COMPDT,N,NM,RETURN,X,XMSUB,XMTEXT,XMY,XMZ
 S U="^",N=$O(^DIC(4,"D",SITENUM,0))
 S NM=$S($D(^DIC(4,N,0)):$P(^(0),U),1:SITENUM)
 ;
 I '$D(XMDUZ) N XMDUZ S XMDUZ=.5 S:'$D(DUZ) DUZ=.5
 ; PROTECTED VARIABLE -- REMOVING KILL: KMPS*2.0*1
 ; K:$G(IO)="" IO
 ;
 ; set completed date-time
 S COMPDT=$$NOW^XLFDT
 S $P(^XTMP("KMPS",SITENUM,0),U,5)=COMPDT
 ;
 S XMSUB=NM_" (Session #"_SESSNUM_") XTMP(""KMPS"") Global"
 ;
 I SITENUM=+SITENUM S XMTEXT="^XTMP(""KMPS"","_SITENUM_","
 E  S XMTEXT="^XTMP(""KMPS"","""_SITENUM_""","
 S XMY("S.KMP1-SAGG-SERVER@FO-ALBANY.DOMAIN.EXT")=""
 D ENT^XMPG
 ;
 S RETURN=XMZ_U_COMPDT
 ;
 Q RETURN
 ;
WAIT(HANG,MAXJOB)    ;
 ;---------------------------------------------------------------------
 ; Wait here until less than MAXJOB volume sets are running
 ;
 ; HANG....  amount of time to wait
 ; MAXJOB..  maximum number of jobs allowed to run
 ;
 ; Return:
 ; RUN.....  number of currently running jobs
 ;---------------------------------------------------------------------
 ;
 N RUN
 ;
 F  H HANG S RUN=$$RUN Q:(RUN<MAXJOB)!+$G(^XTMP("KMPS","STOP"))
 ;
 Q RUN
 ;
RUN() ;-- number of currently running jobs
 N RUN,VOL
 ;
 S RUN=0,VOL=""
 F  S VOL=$O(^XTMP("KMPS","START",VOL)) Q:VOL=""  S RUN=RUN+1
 ;
 Q RUN
 ;
TOOLNG ;-- job has been running too long
 ;
 N TEXT
 ;
 S QUIT=1
 S TEXT(1)=" The SAGG Project collection routines have been running for more"
 S TEXT(2)=" than 3 days.  No report has been generated."
 D MSG^KMPSLK(NOWDT,SESSNUM,.TEXT)
 Q
 ;
ERR1 ;
 S $ET="D ^%ZTER HALT" ; Emergency trap
 D ^%ZTER
 K TEXT
 S TEXT(1)=" SAGG Project Error: "_$G(KMPSZE)
 S TEXT(2)=" See system error log for more details."
 S ^XTMP("KMPS","STOP")=""
 D MSG^KMPSLK(NOWDT,SESSNUM,.TEXT)
 S $EC="" G ^XUSCLEAN
