%ZISTCPS ;ISF/RWF - DEVICE HANDLER TCP/IP SERVER CALLS ;Oct 02, 2018@14:05
 ;;8.0;KERNEL;**78,118,127,225,275,388,10001,10003**;Jul 10, 1995
 ; Original Routine authored by Department of Veterans Affairs
 ; *10001* -> EPs LGTM and GTMLNCH authored by Sam Habiel 2016.
 ; *10003* -> TLS Config (passim... see markers for specific lines changed)
 ; (c) 2016-2018 Sam Habiel
 ; See repository for license terms.
 Q
 ;
CLOSE ;Close and reset
 G CLOSE^%ZISTCP
 Q
 ;
 ;In ZRULE, set ZISQUIT=1 to quit
LISTEN(SOCK,RTN,ZRULE,TLSCONFIG) ;Listen on socket, start routine ; *10003*
 N %A,ZISOS,X,NIO,EXIT
 N $ES,$ET S $ETRAP="D OPNERR^%ZISTCPS"
 S ZISOS=^%ZOSF("OS"),ZRULE=$G(ZRULE)
 S TLSCONFIG=$G(TLSCONFIG) ; *10003*
 S POP=1
 D GETENV^%ZOSV S U="^",XUENV=Y,XQVOL=$P(Y,U,2)
 S POP=1 D LONT:ZISOS["OpenM",LGTM:ZISOS["GT.M"
 I 'POP C NIO ;Close port
 Q
 ;
 ;
LONT ;Open port in Accept mode with standard terminators.
 N %ZA,NEWCHAR
 S NIO="|TCP|"_SOCK,EXIT=0
 ;(adr:sock:term:ibuf:obuf:queue)
 O NIO:(:SOCK:"AT"::512:512:10):30 Q:'$T  S POP=0 U NIO
 ;Wait on read for a connect
LONT2 F  U NIO R *NEWCHAR:30 S EXIT=$$EXIT Q:$T!EXIT
 I EXIT C NIO Q
 ;JOB params (:Concurrent Server bit:principal input:principal output)
 J CHILDONT^%ZISTCPS(NIO,RTN,TLSCONFIG):(:16::):10 S %ZA=$ZA
 I %ZA\8196#2=1 W *-2 ;Job failed to clear bit
 G LONT2
 ;
CHILDONT(IO,RTN,TLSCONFIG) ;Child process for OpenM
 S $ETRAP="D ^%ZTER L  HALT",IO=$ZU(53)
 I TLSCONFIG="" U IO:(::"-M") ;Work like DSM ; *10003*
 E  U IO:(::"-M":/SSL=TLSCONFIG)             ; *10003*
 S NEWJOB=$$NEWOK
 I 'NEWJOB W "421 Service temporarily down.",$C(13,10),!
 I NEWJOB K NEWJOB D VAR,@RTN
 HALT
 ;
VAR ;Setup IO variables
 S IO(0)=IO,IO(1,IO)="",POP=0
 S IOT="TCP",IOST="P-TCP",IOST(0)=0
 S IOF=$$FLUSHCHR^%ZISTCP
 S ^XUTL("XQ",$J,0)=$$DT^XLFDT
 Q
NEWOK() ;Is it OK to start a new process
 I $G(^%ZIS(14.5,"LOGON",^%ZOSF("VOL"))) Q 0
 I $$AVJ^%ZOSV()<3 Q 0
 Q 1
OPNERR ;
 S POP=1,EXIT=1,IO("ERROR")=$ECODE,$ECODE=""
 Q
EXIT() ;See if time to exit
 I $$S^%ZTLOAD Q 1
 N ZISQUIT S ZISQUIT=0
 I $L(ZRULE) X ZRULE I $G(ZISQUIT) Q 1
 Q 0
 ;
LGTM ;GT.M multi-threaded server
 S $ZINT="I $$JOBEXAM^ZU($ZPOSITION)"
 K ^TMP("ZISTCP",$J)
 ;
 I +$P($ZV,"V",2)<6.1 D  QUIT  ; Not supported under 6.1 of GT.M
 . D LOG("Multi-threaded listener doesn't work in GT.M < 6.1")
 ;
 S NIO="SCK$"_SOCK
 D LOG("Open for Listen "_NIO)
 ;
 ; Open the device
 O NIO:(LISTEN=SOCK_":TCP":ATTACH="server"):2:"SOCKET"
 I '$T D LOG("Can't Open Socket: "_SOCK) QUIT
 ;
 ; Use Device
 U NIO S NIO("ZISTCP",0)=$KEY D LOG("Have port.")
 ;
 ;Start Listening
 W /LISTEN(5) S NIO("ZISTCP",1)=$KEY D LOG("Start Listening. "_NIO("ZISTCP",1))
 ;
 ;Wait for connection
 S POP=0
 F  D  Q:POP
 . S POP=$$EXIT ; Exit?
 . Q:POP        ; oh okay, exit.
 . W /WAIT(5)   ; Wait for connect
 . Q:$KEY=""    ; no connection; loop around, and check if we need to shut down.
 . N CHILDSOCK S CHILDSOCK=$P($KEY,"|",2) ; child socket from server.
 . U NIO:(detach=CHILDSOCK) ; detach it so that we can job it off.
 . S NIO("ZISTCP",2)=$KEY
 . S NIO("SOCK")=$P($G(NIO("ZISTCP",2)),"|",2)
 . D LOG("Got connection on "_NIO("SOCK"))
 . I '$$NEWOK D  QUIT
 . . U NIO:(SOCKET=NIO("SOCK")) W "421 Service temporarily down.",$C(13,10),#
 . . C NIO:(SOCKET=NIO("SOCK")) K NIO("ZISTCP",2)
 . N Q S Q="""" ; next three lines build job command's argument.
 . N ARG S ARG=Q_"SOCKET:"_CHILDSOCK_Q ; ditto
 . N C S C=","
 . N J S J="GTMLNCH("_Q_RTN_Q_C_Q_TLSCONFIG_Q_"):(input="_ARG_":output="_ARG_":error="_Q_"/dev/null"_Q_")" ; ditto 
 . J @J
 I POP C NIO Q
 Q
 ;
GTMLNCH(RTN,TLSCONFIG) ;Run gt.m job for this conncetion.
 N NIO,SOCK,ZISOS,EXIT,XQVOL,$ETRAP
 S U="^",$ETRAP="D ^%ZTER L  HALT"
 S IO=$P
 U IO:(nowrap:nodelimiter:IOERROR="TRAP":CHSET="M") ; *10003* Add Character Set for UTF-8 support
 I TLSCONFIG]"" W /TLS("server",1,TLSCONFIG) ; *10003* Add TLS Server support
 S IO(0)=IO,IO(1,IO)=""
 D VAR,@RTN
 Q $D(IO("C")) ;Use IO("C") to quit server
 ;
LOG(MSG) ;LOG STATUS
 N CNT
 S CNT=$G(^TMP("ZISTCP",$J))+1,^TMP("ZISTCP",$J)=CNT,^($J,CNT)=MSG
 Q
 ;
