KMPLOG ; OSE/SMH - Logging Utility for KMP* Packages;2020-01-06  3:45 PM
 ;;3.0;CAPACITY MANAGEMENT;**10003**;
 ;
 I $T(^%ut)]"" D EN^%ut($t(+0),3) quit
 ;
HEAD(string,filePath,fileName,addDate) ; [Public] Add header
 ;
 ; Create directory
 n defDir s defDir=$$DEFDIR^%ZISH()
 n fullDir s fullDir=defDir_filePath
 n % s %=$$MKDIR^%ZISH(fullDir)
 I % S $EC=",U-MKDIR-FAILED,"
 ;
 ; Add date if necessary
 if $get(addDate) set fileName=$p(fileName,".")_"-"_DT
 ;
 ; Add ext
 if $l(fileName,".")<2 s fileName=fileName_".dat"
 ;
 ; Open - Read only - check if file exists
 N POP
 D OPEN^%ZISH("FILE1",fullDir,fileName,"R")
 I 'POP D CLOSE^%ZISH("FILE1") QUIT  ; ! Quit if the file already exists
 ;
 ; Open - write mode
 D OPEN^%ZISH("FILE1",fullDir,fileName,"W")
 I POP S $EC=",U-POP,"
 D USE^%ZISUTL("FILE1")
 w string,!
 D CLOSE^%ZISH("FILE1")
 quit
 ;
EN(arrayName,filePath,fileName,flag,addDate) ; [Public] Main Entry Point
 ; arrayName: Closed Root $NAME of the array
 ; filePath: Category of file; seperate multiple categories by "/"
 ; fileName: name of file
 ; flag: "A" or "W", default "A" for append
 ; addDate?: Should the date of the file creation be added to the name? (optional)
 ;
 ; Create directory
 n defDir s defDir=$$DEFDIR^%ZISH()
 n fullDir s fullDir=defDir_filePath
 n % s %=$$MKDIR^%ZISH(fullDir)
 I % S $EC=",U-MKDIR-FAILED,"
 ;
 ; Get flag
 s flag=$$UP^XLFSTR($g(flag,"A"))
 i "^A^W^"'[U_flag_U s flag="A"
 ;
 ; Add date if necessary
 if $get(addDate) set fileName=$p(fileName,".")_"-"_DT
 ;
 ; Add ext
 if $l(fileName,".")<2 s fileName=fileName_".dat"
 ;
 ; Open
 N POP
 D OPEN^%ZISH("FILE1",fullDir,fileName,flag)
 I POP S $EC=",U-POP,"
 ;
 D USE^%ZISUTL("FILE1")
 ;
 ; Write out the data
 i $d(@arrayName)#2 w @arrayName,!
 n i s i="" f  s i=$o(@arrayName@(i)) q:i=""  w @arrayName@(i),!
 ;
 ; Close
 D CLOSE^%ZISH("FILE1")
 quit
 ;
VA() ; [Public] Are we running inside of the VA?
 I $G(DUZ("AG"))="V" Q 1
 Q 0
 ;
SETUP ; Startup
 N %
 S %=$$DEL1^%ZISH($$DEFDIR^%ZISH_"KMPD/CV/CV-DAILY.dat")
 S %=$$DEL1^%ZISH($$DEFDIR^%ZISH_"KMPD/CV/CV-DAILY-"_DT_".dat")
 QUIT
 ;
T1 ; @TEST Simple Case no date
 N KMPDFMDAY,KMPDHDAY,KMPDLN,KMPDWD
 K ^KMPTMP("KMPD","RDAT")
 S KMPDHDAY=+$H-1
 S KMPDFMDAY=+$$HTFM^XLFDT(KMPDHDAY,1)
 S KMPDWD=$$WORKDAY^XUWORKDY(KMPDFMDAY) ; IA#10046
 ;
 ; SET HEADER LINES
 S KMPDLN=1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="SYSTEM ID="_$$SITEINFO^KMPVCCFG(),KMPDLN=KMPDLN+1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="UPDATE CONFIG="_KMPDHDAY_U_KMPDWD_"^DAILY",KMPDLN=KMPDLN+1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="SYSTEM CONFIG="_$$SYSCFG^KMPVCCFG(),KMPDLN=KMPDLN+1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="boo^boo^boo^boo^boo^boo"
 ;
 D EN($na(^KMPTMP("KMPD","RDAT")),"KMPD/CV","CV-DAILY","W") ; [Public] Main Entry Point
 D CHKTF^%ut($$SIZE^%ZISH($$DEFDIR^%ZISH_"KMPD/CV","CV-DAILY.dat"))
 QUIT
 ;
T2 ; @TEST Simple Case w/ date
 N KMPDFMDAY,KMPDHDAY,KMPDLN,KMPDWD
 K ^KMPTMP("KMPD","RDAT")
 S KMPDHDAY=+$H-1
 S KMPDFMDAY=+$$HTFM^XLFDT(KMPDHDAY,1)
 S KMPDWD=$$WORKDAY^XUWORKDY(KMPDFMDAY) ; IA#10046
 ;
 ; SET HEADER LINES
 S KMPDLN=1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="SYSTEM ID="_$$SITEINFO^KMPVCCFG(),KMPDLN=KMPDLN+1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="UPDATE CONFIG="_KMPDHDAY_U_KMPDWD_"^DAILY",KMPDLN=KMPDLN+1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="SYSTEM CONFIG="_$$SYSCFG^KMPVCCFG(),KMPDLN=KMPDLN+1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="boo^boo^boo^boo^boo^boo"
 ;
 D EN($na(^KMPTMP("KMPD","RDAT")),"KMPD/CV","CV-DAILY","W",1) ; [Public] Main Entry Point
 D CHKTF^%ut($$SIZE^%ZISH($$DEFDIR^%ZISH_"KMPD/CV","CV-DAILY-"_DT_".dat"))
 QUIT
 ;
T3 ; @TEST Simple Case w/ ext no date
 N KMPDFMDAY,KMPDHDAY,KMPDLN,KMPDWD
 K ^KMPTMP("KMPD","RDAT")
 S KMPDHDAY=+$H-1
 S KMPDFMDAY=+$$HTFM^XLFDT(KMPDHDAY,1)
 S KMPDWD=$$WORKDAY^XUWORKDY(KMPDFMDAY) ; IA#10046
 ;
 ; SET HEADER LINES
 S KMPDLN=1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="SYSTEM ID="_$$SITEINFO^KMPVCCFG(),KMPDLN=KMPDLN+1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="UPDATE CONFIG="_KMPDHDAY_U_KMPDWD_"^DAILY",KMPDLN=KMPDLN+1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="SYSTEM CONFIG="_$$SYSCFG^KMPVCCFG(),KMPDLN=KMPDLN+1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="boo^boo^boo^boo^boo^boo"
 ;
 D EN($na(^KMPTMP("KMPD","RDAT")),"KMPD/CV","CV-DAILY.dat","A") ; [Public] Main Entry Point
 D CHKTF^%ut($$SIZE^%ZISH($$DEFDIR^%ZISH_"KMPD/CV","CV-DAILY.dat"))
 QUIT
 ;
T4 ; @TEST Simple Case w/ ext w/ date
 N KMPDFMDAY,KMPDHDAY,KMPDLN,KMPDWD
 K ^KMPTMP("KMPD","RDAT")
 S KMPDHDAY=+$H-1
 S KMPDFMDAY=+$$HTFM^XLFDT(KMPDHDAY,1)
 S KMPDWD=$$WORKDAY^XUWORKDY(KMPDFMDAY) ; IA#10046
 ;
 ; SET HEADER LINES
 S KMPDLN=1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="SYSTEM ID="_$$SITEINFO^KMPVCCFG(),KMPDLN=KMPDLN+1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="UPDATE CONFIG="_KMPDHDAY_U_KMPDWD_"^DAILY",KMPDLN=KMPDLN+1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="SYSTEM CONFIG="_$$SYSCFG^KMPVCCFG(),KMPDLN=KMPDLN+1
 S ^KMPTMP("KMPD","RDAT",KMPDLN)="boo^boo^boo^boo^boo^boo"
 ;
 D EN($na(^KMPTMP("KMPD","RDAT")),"KMPD/CV","CV-DAILY.DAT","A",1) ; [Public] Main Entry Point
 D CHKTF^%ut($$SIZE^%ZISH($$DEFDIR^%ZISH_"KMPD/CV","CV-DAILY-"_DT_".dat"))
 QUIT
 ;
