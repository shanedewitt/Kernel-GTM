KMPVVHL0 ; OSE/SMH - Continuation of KMPVVHLM;2020-01-10  11:45 AM
 ;;4.0;CAPACITY MANAGEMENT;**10001**;3/1/2018
 ; (c) Sam Habiel 2020
 ; Licnesed under Apache 2.0.
 ;
LOG ; [Private] Log output to file system for HL7 messages
 ; ZEXCEPT: KMPMT
 N H S H="Message Type(Sync/Async/HLO)^Time Slot^Trasmission Type(I/O)^"
 S H=H_"Priority(I/D)^Message Type(M/B/F)^Logical Link^Subscriber^Event Driver^"
 S H=H_"Message Type^Event Type^Sending Application^Receiving Application^"
 S H=H_"Sending Site^Receiving Site^Number of Messages^Message Length^"
 S H=H_"# of HL7 Events^Transmission Time(s)^CATime(s)^AATime(s)"
 D HEAD^KMPVLOG(H,"KMPV","VHLM",1)
 N I S I=6
 N C S C=0
 N OUT
 N L
 F  S I=$O(^KMPTMP("KMPV","VHLM","TRANSMIT",$J,KMPMT,I)) Q:'I  S L=^(I) D
 . N D S D=$P(L,"VHLM DATA=",2)
 . S C=C+1,OUT(C)=KMPMT_U_D
 D EN^KMPVLOG($NA(OUT),"KMPV","VHLM","A",1)
 QUIT
