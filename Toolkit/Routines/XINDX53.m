XINDX53 ;SF-ISC/RWF - LOAD ROUTINE FILE ;03/17/98  14:33
 ;;7.3;TOOLKIT;**20,140**;Apr 25, 1995;Build 40
 ; Per VHA Directive 2004-038, this routine should not be modified.
A S RTN="$",DLAYGO=9.8 W !!," Loading the ROUTINE file now.",!
B S RTN=$O(^UTILITY($J,1,RTN)) I RTN'?1U.UN&(RTN'?1"%".UN) G C
 D GETDA G B:DA'>0 W:$X>70 ! W $J(RTN,10)
 F %IN1=19,20,21,"T" F J=0:0 S J=$O(^DIC(9.8,DA,%IN1,J)) Q:J'>0  S $P(^DIC(9.8,DA,%IN1,J,0),U,3)="n"
 S DIE=DIC,DR="1.2///"_(+^UTILITY($J,1,RTN,0))_";1.4////"_DT D ^DIE
 ;E errors and warnings.
 S LOC="L",IND=21 D P ;LOCAL VARIABLES
 S LOC="G",IND=22 D P ;GLOBAL VARIABLES
 ;"NAKED GLOBALS",! S LOC="N",SYM="^(" D P
 S LOC="T",IND="T" D P ;LINE TAGS
 S LOC="X",IND=19 D P ;EXTERNAL REFERENCES
 ;SAVE COMMAND LIST FOR LATER WORK
 K ^DIC(9.8,DA,"CMD") F %IN1=1:1 Q:'$D(^UTILITY($J,1,RTN,"COM",%IN1))  S ^DIC(9.8,DA,"CMD",%IN1,0)=^UTILITY($J,1,RTN,"COM",%IN1)
 G B
P S %IN2=-1,PC=0
 F %IN1=0:0 S %IN2=$O(^UTILITY($J,1,RTN,LOC,%IN2)) Q:%IN2=""  D S
 K DR,DIE Q
S S %IN3=$S("G"[LOC:$E(%IN2,2,99),1:%IN2),%IN3=$TR(%IN3,$C(34),$C(39)),Y=$O(^DIC(9.8,DA,IND,"B",%IN3,0)) G S2:Y>0 ;Translate " to '
 S DIC="^DIC(9.8,DA(1),"_$C(34)_IND_$C(34)_",",DA(1)=DA,X=%IN3,DIC("P")=+$P(^DD(9.8,$S(LOC="L":21,LOC="G":22,LOC="T":5,LOC="X":19),0),U,2) D FILE^DICN
S2 S $P(^DIC(9.8,DA,IND,+Y,0),U,3)="y"
 Q
C S ROU="$" K DLAYGO,DR,DIC,DIE
C1 S ROU=$O(^UTILITY($J,1,ROU)) I ROU'?1U.UN&(ROU'?1"%".UN) G END
 S RTN=ROU D GETDA G C1:DA'>0 S %IN1=DA F %I1=0:0 S %I1=$O(^DIC(9.8,%IN1,19,%I1)) Q:%I1'>0  S %IN2=^(%I1,0),TAG=$P(%IN2," ",2),RTN=$P(%IN2," ",1) D ETAG
 G C1
GETDA S Y=0,DIC="^DIC(9.8,",DIC(0)="MXZL"
GET1 S Y=$O(^DIC(9.8,"B",RTN,Y)) I Y>0 G GOT:"R"[$P(^DIC(9.8,Y,0),U,2),GET1
GET2 S X=""""_RTN_"""",DIC("DR")="1///R" D ^DIC K DIC("DR")
GOT S DA=+Y I $P(^DIC(9.8,DA,0),U,2)="" S $P(^(0),U,2)="R"
 Q
ETAG S DA=0 Q:'$D(^UTILITY($J,1,RTN))
E2 S DA=$O(^DIC(9.8,"B",RTN,DA)) I DA>0,$P(^DIC(9.8,DA,0),U,2)'="R" G E2
 Q:DA'>0  S Y=$O(^DIC(9.8,DA,20,"B",ROU,0)) I Y>0 S $P(^DIC(9.8,DA,20,Y,0),"^",3)="y" Q
 S DIE="^DIC(9.8,",DR="20///"_ROU,DR(2,9.804)="3///y" D ^DIE
 Q
END K DIC,DIE,DIR,DR,ROU,%IN1,LOC,TAG
 Q
