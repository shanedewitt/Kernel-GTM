%ZOSVKSE ;YDB/CJE&OSE/SMH - ZOSVKSGE - Global data (GT.M) ;Sep 17, 2018@17:56
 ;;8.0;KERNEL;**10003**;Jul 26, 2004;Build 48
 ;
 Q
 ;
START(KMPSTEMP) ;-- called by routine ^KMPSGE
 ;------------------------------------------------------------------------
 ; KMPSTEMP... ^ piece 1: SiteNumber
 ;               piece 2: SessionNumber
 ;               piece 3: XTMP Global Location
 ;               piece 4: Current Date/Time
 ;               piece 5: Production UCI
 ;               piece 6: Volume set
 ;-------------------------------------------------------------------------
 ;
 Q:$G(KMPSTEMP)=""
 ;
 N KMPSDT,KMPSERR,KMPSERR1,KMPSERR2,KMPSERR3,KMPSERR4
 N KMPSLOC,KMPSPROD,KMPSSITE,KMPSVOL,KMPSZU,NUM,X
 ;
 S U="^",KMPSSITE=$P(KMPSTEMP,U),NUM=$P(KMPSTEMP,U,2),KMPSLOC=$P(KMPSTEMP,U,3)
 S KMPSDT=$P(KMPSTEMP,U,4),KMPSPROD=$P(KMPSTEMP,U,5),KMPSVOL=KMPSPROD
 K KMPSTEMP
 ;
 S KMPSZU=$ZGLD ; use $ZGLD
 S ^XTMP("KMPS","START",KMPSVOL,NUM)=$H
 ;
 D ALLOS
 ;
DONE ; normal exit
 ;
 K ^XTMP("KMPS","START",KMPSVOL)
 ;
 Q
 ;
ALLOS ;-- entry point now for all OS's
 ;
 N GLOARRAY
 ;
 ; set up GLOARRAY array indexed by global name
 i $d(^%) s GLOARRAY("^%")=""
 n g s g="^%" f  s g=$o(@g) q:g=""  s GLOARRAY(g)=""
 ;
 I '$D(GLOARRAY) S ^XTMP("KMPS",KMPSSITE,NUM," NO GLOBALS ",KMPSVOL)="" Q
 ;
 ; Extract the journal
 n jExtractFile s jExtractFile=$$DUMPJOUR()
 ;
 ; Run the global analysis
 D ALLGLO(jExtractFile)
 ;
 ; Delete the journal
 N % S %=$$RETURN^%ZOSV("rm -f "_jExtractFile,1)
 S ^XTMP("KMPS",KMPSSITE,NUM,KMPSDT,"KEY")="blocks_U_blockSize_U_bytes_U_adj_U_reg_U_acc_U_jourstr_U_jourfile_U_sets_U_kills"
 ;
 Q
 ;
DUMPJOUR() ; [$$ Private] Dump default current journal file for grepping (only DEFAULT region)
 ; Output: File containing the extract
 n reg s reg=$view("region","^DD")
 ;
 ; Journaling on? Check; if not quit.
 n jour s jour=$view("JNLACTIVE",reg)
 n jourstr
 i jour<2 s jourstr="off" ; (2 active, 1 enabled but off; 0 disabled; -1 error)
 e  s jourstr="on"
 if jourstr'="on" quit
 ;
 ; Get Journal File
 n jourfile s jourfile=$view("JNLFILE",reg)
 ;
 ; Extract Journal File Name; delete old
 n outfile s outfile=jourfile_".extract."_DT
 N % S %=$$RETURN^%ZOSV("rm -f "_outfile,1)
 ;
 ; Extract
 n comm s comm="mupip journal -extract="_outfile_" -forward -detail "_jourfile
 o "pipe":(shell="/bin/sh":command=comm)::"pipe"
 u "pipe"
 n x f  r x:1  q:$zeof
 c "pipe"
 ;
 ; quit with file name
 q outfile
 ;
ALLGLO(jExtractFile) ;- collect global info
 N GLO S GLO=""
 ;
 F  S GLO=$O(GLOARRAY(GLO)) Q:GLO=""  D  Q:+$G(^XTMP("KMPS","STOP"))
 . o "pipe":(shell="/bin/sh":command="$gtm_dist/mupip size -sel="_GLO)::"pipe"
 . u "pipe"
 . n out
 . n x f  r x:1 q:$zeof  i x["Total" s out=x
 . c "pipe"
 . ;
 . ;out: Total               2               0               0 ~   0% 4096
 . ;
 . ; strip "Total" out
 . n str s str=$p(out,"Total",2)
 . ; scan to next nonspace char, which is blocks
 . n startpos s startpos=1
 . n i f i=startpos:1:$l(str) i $e(str,i)'=" " quit
 . n blocks s blocks=+$e(str,i,$l(str))
 . ;
 . ; scan to next nonspace char, which is adjacent blocks (w/i 10 blocks)
 . s startpos=i+$l(blocks) ; jump ahead
 . n i f i=startpos:1:$l(str) i $e(str,i)'=" " quit
 . n adj s adj=+$e(str,i,$l(str))
 . ;
 . ; At this point, we don't need the rest of the output
 . ; get region name and block size
 . n reg s reg=$view("region",GLO)
 . n blockSize s blockSize=$$^%PEEKBYNAME("sgmnt_data.blk_size",reg)
 . n bytes s bytes=blocks*blockSize
 . ;
 . ; Region access method
 . n acc s acc=$view("GVACCESS_METHOD",reg)
 . ;
 . ; Journaling on?
 . n jour s jour=$view("JNLACTIVE",reg)
 . n jourstr
 . i jour<2 s jourstr="off" ; (2 active, 1 enabled but off; 0 disabled; -1 error)
 . e  s jourstr="on"
 . ;
 . ; Journal file
 . n jourfile s jourfile=""
 . i jourstr="on" s jourfile=$view("JNLFILE",reg)
 . ;
 . ; If we have a journal file, get the # of sets/kills for the global
 . n sets,kills s (sets,kills)=0
 . i jourstr="on" do
 .. s sets=$$RETURN^%ZOSV("grep -c ""SET.*"_GLO_"("" "_jExtractFile)
 .. s kills=$$RETURN^%ZOSV("grep -c ""KILL.*"_GLO_"("" "_jExtractFile)
 . ; 
 . ; Set info into global
 . S ^XTMP("KMPS",KMPSSITE,NUM,KMPSDT,GLO,KMPSZU)=blocks_U_blockSize_U_bytes_U_adj_U_reg_U_acc_U_jourstr_U_jourfile_U_sets_U_kills
 QUIT
