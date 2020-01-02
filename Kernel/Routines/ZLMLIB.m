%ZLMLIB ; OSE/SMH - Lock Manager M VM Specific Calls ;2019-12-31  11:26 AM
 ;;8.0;KERNEL;**10007**;
 ;
 ; (c) 2019 Sam Habiel
 ; Licensed under Apache 2.0
CACHE() Q ^%ZOSF("OS")["OpenM"
GTM()   Q ^%ZOSF("OS")["GT.M"
 
KILL(PID) ; [$$ Private to Package] Kill Process by ID
 I $$CACHE Q $ZU(4,PID)
 I $$GTM D KILL^ZSY(PID) Q '$zgetjpi(PID,"isprocalive")
 QUIT 0
 ;
OSUSER(PID) ; [$$ Private to Package] Get OS User by PID
 I $$CACHE N X S X=##CLASS(%SYS.ProcessQuery).Open(PID) Q X.OSUserName
 I $$GTM N X D  Q X
 . I '$zgetjpi(PID,"isprocalive") S X="" Q
 . S X=$$RETURN^%ZOSV("id -nu </proc/"_PID_"/loginuid") Q
 QUIT 0
 ;
LOCKQRY(RSET) ; [Private to Package} Get List of Locks into RSET
 ; Output
 ; RSET(lock)=pid
 I $$CACHE D  QUIT
 . N % S %="" F  S %=$O(^$L(%)) Q:%=""  S RSET(%)=^$L(%,"OWNER")
 I $$GTM D GTMLKE(.RSET)
 QUIT
 ;
GTMLKE(RSET) ; [Private] LKE in GT.M/YDB to get Locks
 I '$D(IO) S IO=$IO ; For VistA, define IO so we can go back to it
 ;
 ; read lke output & merge lines if pid is on a separate line from lock name
 ; if line is empty, or starts with %YDB or %GTM, ignore it.
 open "lke":(shell="/bin/sh":command="$gtm_dist/lke show -all":readonly)::"pipe"
 use "lke"
 new lkeout,i,line
 for  read line quit:$zeof  do
 . if line="" quit
 . if $e(line,1,4)="%YDB" quit
 . if $e(line,1,4)="%GTM" quit
 . if 2=$find(line," ") set lkeout(i)=lkeout(i)_" Owned"_$piece(line,"Owned",2)
 . else  set lkeout($increment(i))=line
 use IO close "lke"
 ;
 ; Remove REGION names
 new line set line=""
 for  set line=$order(lkeout(line)) quit:line=""  if lkeout(line)'["PID=" kill lkeout(line)
 ;
 ; Extract that data into RSET
 new line set line=""
 for  set line=$order(lkeout(line)) quit:line=""  do
 . new lock set lock=$piece(lkeout(line)," Owned by PID= ",1)
 . new pid  set pid=+$piece(lkeout(line)," Owned by PID= ",2)
 . set RSET(lock)=pid
 quit
 ;
NXTLOCK(RSET,LOCK) ; [$$ Private to Package] Loop through locks and get information
 S LOCK=$G(RSET) ; Yuck. But LOCK is newed in the external loop.
 S LOCK=$O(RSET(LOCK))
 I $L(LOCK) D  Q 1
 . S LOCK(LOCK)=LOCK ; Yuck again. Doesn't make sense.
 . S LOCK(LOCK,"PID")=RSET(LOCK)
 . S RSET=LOCK ; Yuck yuck
 E  Q 0
 ;
NODE() ; [$$ Private to Package] Node on which we are running
 I $$CACHE Q ##class(%SYS.System).GetInstanceName()
 I $$GTM   Q $P($SY,",",2)
 QUIT
 ;
VOLUME() ; [$$ Private to Package] Volume on which we are running, adapated to the Cache/GTM
 I $$CACHE Q $SYSTEM.SYS.NameSpace()
 I $$GTM   Q $ZGBLDIR
 QUIT
 ;
