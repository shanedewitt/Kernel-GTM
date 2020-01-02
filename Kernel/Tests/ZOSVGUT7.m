ZOSVGUT7 ; OSE/SMH - Patch *10007 Tests: Lock Manager;2019-12-31  1:17 PM
 ;;8.0;KERNEL;**10007**;
 ;
 ; (c) 2019 Sam Habiel
 ; Licensed under Apache 2.0
 I $T(EN^%ut)'="" D EN^%ut($T(+0),3)
 QUIT
 ;
STARTUP  ; M-Unit Startup
 ; ZEXCEPT: CHILDPID
 ; ZEXCEPT: JOB1,ERR,IN
 N IOP S IOP="NULL" D ^%ZIS U IO
 D PATCH^ZTMGRSET(10007)
 D ^%ZISC
 I $$GTM^%ZLMLIB D
 . J JOB1:(IN="/dev/null":OUT="/dev/null":ERR="/dev/null")
 . S CHILDPID=$ZJOB
 I $$CACHE^%ZLMLIB D
 . J JOB1
 . S CHILDPID=$ZCHILD
 H .01 ; This must be big enough to let your computer start the job
 I $ZV["CYGWIN" H 1 ; Wish I knew why...
 I $ZV["arm" H 1 ; Arm chips too slow...
 QUIT
 ;
JOB1 ; [Private] Helper for JOBOFF
 ; ZEXCEPT: ZOSVJOB
 L +^ZOSVJOB:0
 L +ZOSVJOB:0
 K ^TMP($J)
 S ^TMP($J,"SAM")=1
 S ^TMP($J,"CHRISTOPHER")=2
 H 5
 QUIT
 ;
SHUTDOWN ; M-Unit Shutdown
 ; ZEXCEPT: CHILDPID
 N % S %=$$KILL^%ZLMLIB(CHILDPID)
 K CHILDPID
 I $$GTM^%ZLMLIB S $ZSOURCE=$T(+0)
 QUIT
 ;
NODE ; @TEST $$NODE^%ZLMLIB()
 N NODE S NODE=$$NODE^%ZLMLIB
 D SUCCEED^%ut
 QUIT
 ;
VOLUME ; @TEST $$VOLUME^%ZLMLIB()
 N VOL S VOL=$$VOLUME^%ZLMLIB
 D SUCCEED^%ut
 QUIT
 ;
LOCKQRY ; @TEST LOCKQRY^%ZLMLIB
 D CHKTF^%ut($D(^TMP(CHILDPID)))
 N RSET D LOCKQRY^%ZLMLIB(.RSET)
 do tf^%ut($data(RSET("ZOSVJOB")))
 do tf^%ut($data(RSET("^ZOSVJOB")))
 do eq^%ut(RSET("ZOSVJOB"),CHILDPID)
 do eq^%ut(RSET("^ZOSVJOB"),CHILDPID)
 QUIT
 ;
NXTLOCK ; @TEST NXTLOCK^%ZLMLIB
 N RSET D LOCKQRY^%ZLMLIB(.RSET)
 N LOCK
 N LOCKS
 N CONT
 F  S CONT=$$NXTLOCK^%ZLMLIB(.RSET,.LOCK) QUIT:'CONT  D
 . S LOCKS(LOCK)=LOCK(LOCK,"PID")
 do tf^%ut($data(LOCKS("ZOSVJOB")))
 do tf^%ut($data(LOCKS("^ZOSVJOB")))
 do eq^%ut(LOCKS("ZOSVJOB"),CHILDPID)
 do eq^%ut(LOCKS("^ZOSVJOB"),CHILDPID)
 QUIT
 ;
OSUSER ; @TEST $$OSUSER^%ZLMLIB(PID)
 ; ZEXCEPT: CHILDPID
 N % S %=$$OSUSER^%ZLMLIB(CHILDPID)
 d tf^%ut(%'="")
 QUIT
 ;
XULMU ; @TEST $$GETLOCKS^XULMU
 N BOO D GETLOCKS^XULMU("BOO")
 D tf^%ut($data(BOO))
 QUIT
 ;
