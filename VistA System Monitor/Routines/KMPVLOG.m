KMPVLOG ; OSE/SMH - Logging Utility for KMP* Packages;2020-01-10  2:03 PM
 ;;3.0;CAPACITY MANAGEMENT;**10001**;
 ;(c) Sam Habiel 2018
 ; Changes licensed under Apache 2.0
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
 n hl7date s hl7date=$$FMTHL7^XLFDT(DT)
 ;
 ; Add date if necessary
 if $get(addDate) set fileName=$p(fileName,".")_"-"_hl7date
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
 n hl7date s hl7date=$$FMTHL7^XLFDT(DT)
 ;
 ; Add date if necessary
 if $get(addDate) set fileName=$p(fileName,".")_"-"_hl7date
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
 I $G(DUZ("AG"))'="" Q DUZ("AG")="V"
 Q $$GET1^DIQ(8989.3,1,9,"I")="V"
 ;
DELLOG(filePath,fileName,days) ; [Public] Delete (Old) Log Files
 ; filePath: Category of file; seperate multiple categories by "/"
 ; fileName: name of file
 ; days: days to keep
 n defDir  s defDir=$$DEFDIR^%ZISH()
 n fullDir s fullDir=defDir_filePath_"/"
 n dayToDeleteAfter s dayToDeleteAfter=$$FMADD^XLFDT(DT,-days)
 n hl7dateDelAfter s hl7dateDelAfter=$$FMTHL7^XLFDT(dayToDeleteAfter)
 n KMPVA,KMPVR ; uppercase for namespaced variables
 s KMPVA(fileName_"*")=""
 n % s %=$$LIST^%ZISH(fullDir,$name(KMPVA),$name(KMPVR))
 i %=0 quit  ; failed to return files.
 n return m return=KMPVR
 k KMPVA,KMPVR
 n file s file=""
 f  s file=$o(return(file)) quit:file=""  do
 . n hl7date s hl7date=+$p(file,"-",2)
 . i hl7date=0 quit
 . i hl7date<hl7dateDelAfter d DEL1^%ZISH(fullDir_file)
 quit
 ;
 ;
 ;
 ; -- Rest is M Unit Code --
 ;
 ;
SETUP    ; M-Unit Startup
 ; ZEXCEPT: hl7date
 N %
 n % s %=$$MKDIR^%ZISH($$DEFDIR^%ZISH_"KMPD/CV")
 I % S $EC=",U-MKDIR-FAILED,"
 s hl7date=$$FMTHL7^XLFDT(DT)
 S %=$$DEL1^%ZISH($$DEFDIR^%ZISH_"KMPD/CV/CV-DAILY.dat")
 S %=$$DEL1^%ZISH($$DEFDIR^%ZISH_"KMPD/CV/CV-DAILY-"_hl7date_".dat")
 QUIT
 ;
SHUTDOWN ; M-Unit Shutdown
 ; ZEXCEPT: hl7date
 N %
 S %=$$DEL1^%ZISH($$DEFDIR^%ZISH_"KMPD/CV/CV-DAILY.dat")
 S %=$$DEL1^%ZISH($$DEFDIR^%ZISH_"KMPD/CV/CV-DAILY-"_hl7date_".dat")
 k hl7date
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
 D CHKTF^%ut($$SIZE^%ZISH($$DEFDIR^%ZISH_"KMPD/CV","CV-DAILY-"_hl7date_".dat"))
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
 D CHKTF^%ut($$SIZE^%ZISH($$DEFDIR^%ZISH_"KMPD/CV","CV-DAILY-"_hl7date_".dat"))
 QUIT
 ;
T5 ; @TEST Delete Log
 ; Create files for 30 days
 N i F i=1:1:30 D
 . n fmdate  s fmdate=$$FMADD^XLFDT(DT,-i)
 . n hl7date s hl7date=$$FMTHL7^XLFDT(fmdate)
 . d T5I("KMPD","cvload",hl7date)
 n KMPVA,KMPVR
 s KMPVA("cvload*")=""
 n % s %=$$LIST^%ZISH($$DEFDIR^%ZISH_"KMPD/",$name(KMPVA),$name(KMPVR))
 n return m return=KMPVR
 k KMPVA,KMPVR
 n cnt s cnt=0
 n file s file=""
 f  s file=$o(return(file)) quit:file=""  s cnt=cnt+1
 d tf^%ut(cnt>29)
 d DELLOG("KMPD","cvload",1) ; Delete (Old) Log Files
 n KMPVA,KMPVR
 s KMPVA("cvload*")=""
 n % s %=$$LIST^%ZISH($$DEFDIR^%ZISH_"KMPD/",$name(KMPVA),$name(KMPVR))
 n return m return=KMPVR
 k KMPVA,KMPVR
 n cnt s cnt=0
 n file s file=""
 f  s file=$o(return(file)) quit:file=""  s cnt=cnt+1
 d tf^%ut(cnt<3) ; could be 2 or 1 for today and yesterday
 quit
 ;
T5I(filePath,fileName,hl7date) ; [Private] Create files
 n defDir s defDir=$$DEFDIR^%ZISH()
 n fullDir s fullDir=defDir_filePath
 n % s %=$$MKDIR^%ZISH(fullDir)
 I % S $EC=",U-MKDIR-FAILED,"
 set fileName=$p(fileName,".")_"-"_hl7date
 if $l(fileName,".")<2 s fileName=fileName_".dat"
 D OPEN^%ZISH("FILE1",fullDir,fileName,"W")
 D USE^%ZISUTL("FILE1")
 W "boo^boo^boo"
 D CLOSE^%ZISH("FILE1")
 QUIT
