XINDX8 ;ISC/GRK - STRUCTURED INDEX ;01/04/2000  14:29
 ;;7.3;TOOLKIT;**20,27,61,140**;Apr 25, 1995;Build 40
 ; Per VHA Directive 2004-038, this routine should not be modified.
 S Q="""",(DDOT,LO)=0,PG=+$G(PG) D HDR
 F LC=1:1 Q:'$D(^UTILITY($J,1,RTN,0,LC))  S LIN=^(LC,0),ML=0,IDT=10 D CD
 K AGR,EOC,IDT,JJ,LO,ML,OLD,SAV,TY
 Q
CD S LAB=$P(LIN," ",1),LIN=$P(LIN," ",2,999),LO=$S(LAB="":LO+1,1:0)
 I INP(5)["L",$G(OPT("NUM")) S OPT("NUM")=OPT("NUM")+1 W $J(OPT("NUM"),3)_"| "
 W $S('LO:LAB,INP(5)'["N":" +"_LO,1:"")_" "
 G:LIN'[";" EE S STR=1,L=";",ARG=LIN D LOOP I CH'=";" G EE
 W ?10,$E(LIN,I,999),! Q:I<2  S LIN=$E(LIN,1,I-2)
EE I LIN="" Q
 I $E(LIN)=" " S LIN=$E(LIN,2,9999) G EE ;Skip blanks
 D SEP S EOC=0,COM=$$CASE^XINDX52($P(ARG,":")),CM=$P($G(IND("CMD",COM)),"^") I CM="" G ERR
 I ARG[":" S OLD=CM,COM="if",ARG=$P(ARG,":",2) D GRB S IDT=IDT+4,CM=OLD,EOC=4
 S COM=CM D SEP
 S:$E(COM)="H"&(ARG'="") COM="HANG" S X=$E(COM,1)
 D @$S("BCHKLMNOPQRUVWZ"[X:"GRB",X="S":"SET","DGX"[X:"DGX","IE"[X:"IFE",X="F":"FOR",1:"GRB") S:EOC IDT=IDT-EOC G EE
 ;
GRB I ARG["$" F I=1:1 S CH=$E(ARG,I) Q:CH=""  D QUOTE:CH=Q I CH="$" D FUN
 I $Y+2>IOSL D HDR
 W ?IDT," ",$S(ML:"...",1:COM)," ",ARG,! S ML=0 Q
FUN I " $$ $& $% "[(" "_$E(ARG,I,I+1)_" ") D  S I=J-1 Q  ;Handle Extrinsics
 . F J=I+2:1 Q:"(,"[$E(ARG,J)
 . Q
 F J=I+1:1 Q:$E(ARG,J)'?1A
 S X=$E(ARG,I+1,J-1),L=$L(X),CH=$E(ARG,I+1),TY=$S($E(ARG,J)="(":"FNC",1:"SVN")
 Q:CH="Z"  S X=$P($G(IND(TY,X)),"^")
 G:'$L(X) ERR Q:L=$L(X)
 D:$L(ARG)>245 LEN S ARG=$E(ARG,1,I)_X_$E(ARG,J,999),I=I+$L(X)-L
 Q
ERR W !,"*** ERROR ***",! Q
IFE I ARG=""!(X="E") W ?IDT,"IF " W:X="E" "'" W "$TEST",! S IDT=IDT+4 Q
SET S STR=1,L="," D LOOP S SAV=ARG,ARG=$E(ARG,1,I-1),IP=I+1
 D GRB S ARG=$E(SAV,IP,999) S:COM="IF"!(COM="if") IDT=IDT+4 Q:ARG=""  G SET
FOR D GRB S IDT=IDT+4 Q
DGX I ARG="",$E(COM)="D" D DDOT Q
 S STR=1,L=":," D LOOP I CH="" G GRB
 I CH="," S SAV=ARG,ARG=$E(ARG,1,I-1),IP=I+1 D GRB G D1
 S SAV=ARG,STR=I+1,L="," D LOOP S IP=I+1
 S OLD=COM,ARG=$E(ARG,STR,I-1),COM="if" D GRB
 S IDT=IDT+4,ARG=$E(SAV,1,STR-2),COM=OLD D GRB S IDT=IDT-4
D1 S ARG=$E(SAV,IP,999) Q:ARG=""  G DGX
DDOT S DDOT=DDOT+1 W ?IDT," Begin DoDot:",DDOT,! S IDT(DDOT)=IDT+4
 N LIN,I,COM,EOC,Y
 F LC=LC+1:1 S LIN=$G(^UTILITY($J,1,RTN,0,LC,0)),IDT=IDT(DDOT) Q:LIN=""  D  Q:X<DDOT  D CD
 . S Y=$P(LIN," "),LIN=$P(LIN," ",2,999)
 . F I=1:1:254 Q:". "'[$E(LIN,I)
 . S X=$L($E(LIN,1,I),".")-1,LIN=Y_" "_$E(LIN,I,999)
 S IDT=IDT-4,LC=LC-1 W ?IDT," End DoDot:",DDOT,! S DDOT=DDOT-1
 Q
LOOP F I=STR:1 S CH=$E(ARG,I) D QUOTE:CH=Q,PAREN:CH="(" Q:L[CH
 Q
PAREN S PC=1
 F I=I+1:1 S CH=$E(ARG,I) Q:PC=0!(CH="")  I "()"""[CH D QUOTE:CH=Q S:"()"[CH PC=PC+$S(CH="(":1,1:-1)
 Q
QUOTE F I=I+1:1 S CH=$E(ARG,I) Q:CH=""!(CH=Q)
 Q
SEP F I=1:1 S CH=$E(LIN,I) D SEPQ:CH=Q Q:"; "[CH
 S ARG=$E(LIN,1,I-1) S:CH=" " I=I+1 S LIN=$E(LIN,I,999) Q
SEPQ S I=I+1,CH=$E(LIN,I) I CH="" G ERR Q
 G SEPQ:CH'=Q S I=I+1,CH=$E(LIN,I) G:CH=Q SEPQ Q
LEN S AGR=$E(ARG,1,I-1) W ?IDT,COM," ",AGR_"...",! S ARG=$E(ARG,I)_$E(ARG,J-1,999),I=1,J=3,ML=1 K AGR
 Q
HDR S PG=PG+1
 W @IOF,RTN,"   ",+^UTILITY($J,1,RTN,0),"     printed  ",INDXDT,?(IOM-10)," Page ",PG,!!
 Q
 ;
UC(%) Q $TR(%,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ;
XCR ;Option entry point
 K ^UTILITY($J) D ASKRTN^XINDX6 G EXIT:NRO<1 S %ZIS="M" D ^%ZIS Q:POP  U IO(0)
 I $D(IO("Q")) S ZTRTN="XC2^XINDX8",ZTSAVE("^UTILITY($J,")="",ZTDESC="Structured print" D ^%ZTLOAD G EXIT
XC2 U IO I '$D(INDXDT) D NOW^%DTC S INDXDT=$E(%,2,3)_"/"_$E(%,4,5)_"/"_$E(%,6,7)
 D BUILD^XINDX7
 S RTN="" F  S RTN=$O(^UTILITY($J,RTN)) Q:RTN=""  D  D XINDX8
 . D LOAD^XINDEX
 . S CCN=0 F I=1:1:+^UTILITY($J,1,RTN,0,0) S CCN=CCN+$L(^UTILITY($J,1,RTN,0,I,0))+2
 . S ^UTILITY($J,1,RTN,0)=CCN
 . Q
EXIT D ^%ZISC K ^UTILITY($J),RTN,T,CCN,I,PG,INDXDT
