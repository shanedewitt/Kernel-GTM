## Introduction
This is a major release that provides new functionality to the VistA Community.
This patch provides a port of Capacity Management (CM), Statistical Analysis of
Global Growth (SAGG), and VistA System Monitor to work (a) On GT.M or YottaDB
and (b) on Cache (c) and to produce usable output outside of the VA.

Software authored by Chirstopher Edwards and Sam Habiel in 2018-2020. This
document was written in February 2020. All software and documentation licensed
under Apache 2.0.

This is a multibuild that contains the following builds:

 - `XU*8.0*10003`
 - `KMPD*3.0*10001`
 - `KMPS*2.0*10001`
 - `KMPV*1.0*10001`

## Download Location
https://github.com/shabiel/Kernel-GTM/releases/tag/XU-8.0-10003. You can use
a KIDS build to update an existing system; or you can use `virgin_install.zip`
to put the correct routines in a system where KIDS is not operational yet.

## Install Instructions
Minimum GT.M Version: 6.3
Minimum Cache Version: 2014.1

Patch XU\*8.0\*10004 is required before installing this patch.

See the list of external dependencies first before installing. 

No pre-install; no post-install instructions.

## Special Notes
None

## Options Affected
These menu options mainly did not work for GT.M at all. Now they all work.
```
   TLS    CP Tools Manager Menu ... [KMPD CM TOOLS MANAGER MENU]
   VSM    VSM MANAGEMENT [KMPV VSM MANAGEMENT]
```

The following taskman jobs do most of the work, and all have been modified to
produce file output:

```
KMPS SAGG REPORT           
KMPD BACKGROUND DRIVER     
KMPV VTCM DATA TRANSMISSION
KMPV VSTM DATA TRANSMISSION
KMPV VBEM DATA TRANSMISSION
KMPV VMCM DATA TRANSMISSION
KMPV VHLM DATA TRANSMISSION
```

The Capacity Management GUI almost all works.

## Package Usage
See the [implementation-guide](../KMP/implementation-guide.md) for discussion
on how to use this package. It's complex, and needs a lot of planning of how to
use the data that is produced.

## Documentation
The following documentation is provided for this code:

 - This document.
 - [Monograph](../KMP/monograph.md), providing a bird's eye view of all the
   packages.
 - [Output Files Description](../KMP/output-files-description.md), which
   provides technical details on the meaning of each field that is logged and
   how it is obtained.
 - [Implementation Guide](../KMP/implementation-guide.md), which discusses how
   to work on putting this package into production.

## Error Codes
### ZOSVKSGD
* `,U-UNIMPLEMENTED,` - GT.M/YottaDB underlying OS not supported. Now we
  support Linux, Cygwin and Darwin.
### KMPDUTL5
* ",U-NOT-SUPPORTED," - CPU Info only supported for Cache On Linux for Unix
  systems. No other unixes are supported.
### KMPVLOG
* ",U-MKDIR-FAILED," - `mkdir` command failed to create log files. Check your
  permissions on the directory obtained by `$$DEFDIR^%ZISH`.
* ",U-POP," - opening a file failed. Check your permissions.

## Internal Interfaces
In the list below, note that $$^%PEEKBYNAME are GT.M specific calls; and 
calls to ^%SYS.DATABASE are Cache specific calls.

```
   XU810003     PATCH^ZTMGRSET
   ZOSVKRG      $$DEFREG^%ZOSV,$$VERSION^%ZOSV,GETENV^%ZOSV,$$GETVAL^KMPVCCFG
   ZOSVKSGD     $$^%PEEKBYNAME,$$DEFREG^%ZOSV,$$RETURN^%ZOSV,$$SEC^XLFDT
   ZOSVKSGE     $$^%PEEKBYNAME,$$RETURN^%ZOSV
   ZOSVKSOE     DecomposeStatus^%SYS.DATABASE,$$EC^%ZOSV,$$VERSION^%ZOSV,%ZTER
                $$NEWERR^%ZTER,UNWIND^%ZTER
   ZTMGRSET     init^%RSEL,$$VERSION^%ZOSV,BMES^XPDUTL,MES^XPDUTL,ZTEDIT
   KMPDRDAT     $$SITEINFO^KMPVCCFG,$$SYSCFG^KMPVCCFG,$$VA^KMPVLOG
                DELLOG^KMPVLOG,EN^KMPVLOG,$$HDIFF^XLFDT,$$HTFM^XLFDT,XMD
                $$WORKDAY^XUWORKDY
   KMPDTP1      %ZIS,%ZISC,%ZTLOAD,DATERNG^KMPDTU10,$$PTNPSEL^KMPDUTL4
                CONTINUE^KMPDUTL4,HDR^KMPDUTL4,$$FMTE^XLFDT,$$REPEAT^XLFSTR
   KMPDTU01     FILE^DIE,$$PTNP^KMPDHU03,$$TESTLAB^KMPDUT1,$$VERSION^KMPDUTL
                $$SYSINFO^KMPDUTL1,CPU^KMPDUTL5,TRANSTO^KMPDUTL7,$$VA^KMPVLOG
                $$SITE^VASITE,$$FMTE^XLFDT,XMD,$$WORKDAY^XUWORKDY
   KMPDU2       SILENT^%RSEL,KILL^KMPDU,$$ROULABEL^KMPDU2,$$LJ^XLFSTR
                $$UP^XLFSTR
   KMPDUTL      MSG^DIALOG,UPDATE^DIE,DIK,FMDTI^KMPDU,KMPDUTL,$$DT^XLFDT
                MES^XPDUTL
   KMPDUTL1     $$RETURN^%ZOSV,DIR,$$CVMSVER^KMPDUTL5,$$CWNTVER^KMPDUTL5
                $$DOW^XLFDT,$$FMTE^XLFDT,$$ACTIVE^XUSER
   KMPDUTL5     $$DEL^%ZISH,$$STATUS^%ZISH,CLOSE^%ZISH,OPEN^%ZISH
                $$RETURN^%ZOSV,$$MPLTF^KMPDUTL1,$$COMMA^KMPDUTL4
                $$STRIP^KMPDUTL4,$$TRIM^XLFSTR
   KMPSGE       START^%ZOSVKSE,%ZTER,$$OUT^KMPSLK,EN^KMPSLK,END^KMPSLK
                MSG^KMPSLK,KMPSUTL,$$MPLTF^KMPSUTL1,$$VA^KMPVLOG,DELLOG^KMPVLOG
                EN^KMPVLOG,$$SITE^VASITE,$$DT^XLFDT,$$FMADD^XLFDT,$$NOW^XLFDT
                ENT^XMPG,XUSCLEAN
   KMPSLK       EN^%ZOSVKSD,$$DOW^XLFDT,$$FMTE^XLFDT,XMD
   KMPSUTL      DIE,DIR,KMPSUTL,$$MPLTF^KMPSUTL1
   KMPSUTL1     $$OS^%ZOSV,$$DOW^XLFDT,$$FMTE^XLFDT,$$ACTIVE^XUSER
   KMPVBETR     H^%DTC,$$S^%ZTLOAD,CANMESS^KMPVCBG,PURGEDLY^KMPVCBG
                $$CFGSTR^KMPVCCFG,$$GETVAL^KMPVCCFG,$$SITEINFO^KMPVCCFG
                $$SYSCFG^KMPVCCFG,STRSTP^KMPVCCFG,$$VA^KMPVLOG,EN^KMPVLOG
                HEAD^KMPVLOG,$$SITE^VASITE,$$HTFM^XLFDT,XMD,$$WORKDAY^XUWORKDY
   KMPVCBG      DisplayError^%apiOBJ,DIE,DIR,$$CFGSTR^KMPVCCFG
                $$GETVAL^KMPVCCFG,$$PROD^KMPVCCFG,$$SETONE^KMPVCCFG
                $$SITEINFO^KMPVCCFG,$$SYSCFG^KMPVCCFG,$$USERNAME^KMPVCCFG
                $$VA^KMPVLOG,DELLOG^KMPVLOG,$$SITE^VASITE,XMD,$$NETNAME^XMXUTIL
                RESCH^XUTMOPT
   KMPVCCFG     DD^%DT,H^%DTC,YMD^%DTC,$$OS^%ZOSV,$$VERSION^%ZOSV,GETENV^%ZOSV
                FIND^DIC,FILE^DIE,$$FLDNUM^DILFD,$$GET1^DIQ,CFGMSG^KMPVCBG
                MONLIST^KMPVCBG,$$GETVAL^KMPVCCFG,$$PROD^KMPVCCFG,$$SITE^VASITE
                $$FMDIFF^XLFDT,$$NETNAME^XMXUTIL,$$PROD^XUPROD
                OPTSTAT^XUTMOPT
   KMPVLOG      $$DEFDIR^%ZISH,$$DEL1^%ZISH,$$LIST^%ZISH,$$MKDIR^%ZISH
                $$SIZE^%ZISH,CLOSE^%ZISH,DEL1^%ZISH,OPEN^%ZISH,USE^%ZISUTL
                CHKTF^%ut,EN^%ut,tf^%ut,$$GET1^DIQ,$$SITEINFO^KMPVCCFG
                $$SYSCFG^KMPVCCFG,$$FMADD^XLFDT,$$FMTHL7^XLFDT,$$HTFM^XLFDT
                $$UP^XLFSTR
                $$WORKDAY^XUWORKDY
   KMPVVHL0     EN^KMPVLOG,HEAD^KMPVLOG
   KMPVVHLM     H^%DTC,GETENV^%ZOSV,$$GET1^DIQ,CANMESS^KMPVCBG,PURGEDLY^KMPVCBG
                $$CFGSTR^KMPVCCFG,$$GETVAL^KMPVCCFG,$$ISBENODE^KMPVCCFG
                $$PROD^KMPVCCFG,$$SITEINFO^KMPVCCFG,$$SLOT^KMPVCCFG
                $$SYSCFG^KMPVCCFG,STRSTP^KMPVCCFG,$$VA^KMPVLOG,LOG^KMPVVHL0
                $$SITE^VASITE,$$DT^XLFDT,$$FMDIFF^XLFDT,$$HTFM^XLFDT,XMD
                $$WORKDAY^XUWORKDY
   KMPVVMCM     H^%DTC,GETENV^%ZOSV,SETNM^%ZOSV,CANMESS^KMPVCBG
                PURGEDLY^KMPVCBG,$$CFGSTR^KMPVCCFG,$$GETVAL^KMPVCCFG
                $$ISBENODE^KMPVCCFG,$$PROD^KMPVCCFG,$$SITEINFO^KMPVCCFG
                $$SLOT^KMPVCCFG,$$SYSCFG^KMPVCCFG,STRSTP^KMPVCCFG,$$VA^KMPVLOG
                EN^KMPVLOG
                HEAD^KMPVLOG,$$SITE^VASITE,$$DT^XLFDT,$$HTFM^XLFDT,XMD
                $$WORKDAY^XUWORKDY
   KMPVVSTM     H^%DTC,YX^%DTC,GETENV^%ZOSV,KMPVVSTM^%ZOSVKSD,CANMESS^KMPVCBG
                PURGEDLY^KMPVCBG,$$CFGSTR^KMPVCCFG,$$GETVAL^KMPVCCFG
                $$PROD^KMPVCCFG,$$SITEINFO^KMPVCCFG,$$SYSCFG^KMPVCCFG
                STRSTP^KMPVCCFG,$$VA^KMPVLOG,EN^KMPVLOG,HEAD^KMPVLOG
                $$SITE^VASITE
                $$DT^XLFDT,$$HTFM^XLFDT,XMD,$$WORKDAY^XUWORKDY
   KMPVVTCM     H^%DTC,GETENV^%ZOSV,SETNM^%ZOSV,BLKCOL^%ZOSVKSD
                KMPVVTCM^%ZOSVKSD,CANMESS^KMPVCBG,PURGEDLY^KMPVCBG
                $$CFGSTR^KMPVCCFG,$$GETVAL^KMPVCCFG,$$PROD^KMPVCCFG
                $$SITEINFO^KMPVCCFG,$$SLOT^KMPVCCFG,$$SYSCFG^KMPVCCFG
                STRSTP^KMPVCCFG,$$VA^KMPVLOG
                EN^KMPVLOG,HEAD^KMPVLOG,$$SITE^VASITE,$$HTFM^XLFDT,XMD
                $$WORKDAY^XUWORKDY
```

## External Interfaces
The following system utilities must be present.

 - cron (GT.M)
 - df (GT.M)
 - awk (GT.M)
 - ipcs (GT.M)
 - grep (Both GT.M and Cache)
 - sysctl (GT.M)
 - rm (Both)
 - uname (Both)
 - /proc/cpuinfo on Linux (Both)
 - uniq (Both)
 - cut (Both)
 - wc (Both)

## Change Log
### ZOSVKSD
 - Move Cache class data into array format so that caller won't have Cache
   class code as caller is not a Z routine.

### ZOSVKRG
 - New Routine for RUM for GTM/YDB.

### ZOSVKSGE
 - New Routine for SAGG for GTM/YDB.

### ZOSVKSGS
 - New Empty Routine for Integrity Checks for GTM/YDB. Not called.

### ZOSVKSGD
 - New Routine for SAGG/VSTM/VTCM for GTM/YDB.

### ZTMGRSET
 - Rename RUM Routines to % version for GTM/YDB.

### ZOSVKSOE
 - Change output format for Cache. Previously, the code did not export the
   actual storage used; only packing information. 
 - Output has been reformatted as well to go into a single line per global.

### KMPDRDAT
 - Log output if agency isn't VA

### KMPDUTL
 - Upgrade patch information

### KMPDUTL1
 - Check for GTM as a supported OS
 - Add support for % routines for different OSs. Previously, patch information
   for percent routines was assumed to be the same. This change now allows
   different patch levels for % routines for differnt OSs (i.e. Cache vs GTM)
 - Replace usage of ZLOAD with $TEXT

### KMPDUTL5
 - CPU info for Cache/Linux and GT.M/Linux,Darwin,Cygwin

### KMPDU2
 - Multiple changes to add code to support GT.M (calls to emulate ^$ROUTINE,
 ^ROUTINE); remove ZLOAD and replace with $TEXT
 - Change supported routine length to 16 characters

### KMPDTU01
 - Suppress email outside of VA

### KMPDTP
 - Add missing QUIT to prevent a fallthrough error

### KMPSGE
 - Remove requirement for ZTQUEUED. Code runs quickly enough in foreground.
 - Replace usage of ZLOAD with $TEXT
 - Use $ET not $ZT
 - Dump output to log file outside VA
 - Set HANG to 1 second from 300 seconds as code really runs quickly

### KMPSUTL
 - Update Checksums

### KMPSLK
 - GTM support

### KMPSUTL1
 - GTM support

### KMPVCBG
 - Remove usage for $ZNSPACE, as non-VA systems do not have that configured
 - Print message out for GT.M on how to configure a scheduled task in cron

### KMPVCCFG
 - Make $$ISBENODE a not-op for GT.M

### KMPVLOG
 - New routine for logging

### KMPVVSTM
 - On GT.M, okay to run daily. On Cache, it runs on the 15th or last day of
   the month
 - Log output outside of the VA
 - Don't send email in tasked process outside of the VA

### KMPVVTCM
 - Added code to set Process Name
 - Log output outside of the VA
 - Don't send email in tasked process outside of the VA
 - Add Critical Section Latch time for GT.M as the last column

### KMPVVMCM
 - Added code to set Process Name
 - Log output outside of the VA
 - Don't send email in tasked process outside of the VA

### KMPVBETR
 - Log output outside of the VA

### KMPVVHLM
 - Log output outside of the VA

### KMPVVHL0
 - New routine. Called from KMPVVHLM. Latter was getting too big for XINDEX.

## Package Components
### XU\*8.0\*10003
```
PACKAGE: XU*8.0*10003     Feb 06, 2020 8:43 am                           PAGE 1
-------------------------------------------------------------------------------
TYPE: SINGLE PACKAGE                               TRACK NATIONALLY: YES
NATIONAL PACKAGE: KERNEL                         ALPHA/BETA TESTING: NO

DESCRIPTION:
Capacity Management Package Port.

See Releases notes on https://github.com/shabiel/Kernel-GTM.

ENVIRONMENT CHECK:                               DELETE ENV ROUTINE:
 PRE-INIT ROUTINE:                          DELETE PRE-INIT ROUTINE:
POST-INIT ROUTINE: POST^XU810003           DELETE POST-INIT ROUTINE: No
PRE-TRANSPORT RTN:

ROUTINE:                                       ACTION:
   ZOSVGUT4                                       SEND TO SITE
   ZOSVKRG                                        SEND TO SITE
   ZOSVKSD                                        SEND TO SITE
   ZOSVKSGD                                       SEND TO SITE
   ZOSVKSGE                                       SEND TO SITE
   ZOSVKSGS                                       SEND TO SITE
   ZOSVKSOE                                       SEND TO SITE
   ZTMGRSET                                       SEND TO SITE

REQUIRED BUILDS:                               ACTION:
   XU*8.0*568                                     Don't install, leave global
   XU*8.0*670                                     Don't install, leave global
   XU*8.0*10004                                   Don't install, leave global
```

### KMPD\*3.0\*10001
```
PACKAGE: KMPD*3.0*10001     Feb 06, 2020 8:48 am                         PAGE 1
-------------------------------------------------------------------------------
TYPE: SINGLE PACKAGE                               TRACK NATIONALLY: YES
NATIONAL PACKAGE: CAPACITY MANAGEMENT TOOLS      ALPHA/BETA TESTING: NO

DESCRIPTION:
Capacity Management Package Port.

See Releases notes on https://github.com/shabiel/Kernel-GTM.

ENVIRONMENT CHECK:                               DELETE ENV ROUTINE:
 PRE-INIT ROUTINE:                          DELETE PRE-INIT ROUTINE:
POST-INIT ROUTINE:                         DELETE POST-INIT ROUTINE:
PRE-TRANSPORT RTN:

ROUTINE:                                       ACTION:
   KMPDRDAT                                       SEND TO SITE
   KMPDTP1                                        SEND TO SITE
   KMPDTU01                                       SEND TO SITE
   KMPDU2                                         SEND TO SITE
   KMPDUTL                                        SEND TO SITE
   KMPDUTL1                                       SEND TO SITE
   KMPDUTL5                                       SEND TO SITE
```

### KMPS\*2.0\*10001
```
PACKAGE: KMPS*2.0*10001     Feb 06, 2020 8:49 am                         PAGE 1
-------------------------------------------------------------------------------
TYPE: SINGLE PACKAGE                               TRACK NATIONALLY: YES
NATIONAL PACKAGE: SAGG PROJECT                   ALPHA/BETA TESTING: NO

DESCRIPTION:
Capacity Management Package Port.

See Releases notes on https://github.com/shabiel/Kernel-GTM.

ENVIRONMENT CHECK:                               DELETE ENV ROUTINE:
 PRE-INIT ROUTINE:                          DELETE PRE-INIT ROUTINE:
POST-INIT ROUTINE:                         DELETE POST-INIT ROUTINE:
PRE-TRANSPORT RTN:

ROUTINE:                                       ACTION:
   KMPSGE                                         SEND TO SITE
   KMPSLK                                         SEND TO SITE
   KMPSUTL                                        SEND TO SITE
   KMPSUTL1                                       SEND TO SITE
```

### KMPV\*1.0\*10001
```
PACKAGE: KMPV*1.0*10001     Feb 06, 2020 8:58 am                         PAGE 1
-------------------------------------------------------------------------------
TYPE: SINGLE PACKAGE                               TRACK NATIONALLY: YES
NATIONAL PACKAGE: VISTA SYSTEM MONITOR           ALPHA/BETA TESTING: NO

DESCRIPTION:
Capacity Management Package Port.

See Releases notes on https://github.com/shabiel/Kernel-GTM.

ENVIRONMENT CHECK:                               DELETE ENV ROUTINE:
 PRE-INIT ROUTINE:                          DELETE PRE-INIT ROUTINE:
POST-INIT ROUTINE:                         DELETE POST-INIT ROUTINE:
PRE-TRANSPORT RTN:

ROUTINE:                                       ACTION:
   KMPVBETR                                       SEND TO SITE
   KMPVCBG                                        SEND TO SITE
   KMPVCCFG                                       SEND TO SITE
   KMPVLOG                                        SEND TO SITE
   KMPVVHL0                                       SEND TO SITE
   KMPVVHLM                                       SEND TO SITE
   KMPVVMCM                                       SEND TO SITE
   KMPVVSTM                                       SEND TO SITE
   KMPVVTCM                                       SEND TO SITE
```


## Routine Checksums
```
XU810003  value = 34312
ZOSVGUT4  value = 105305043
ZOSVKRG   value = 31282024
ZOSVKSD   value = 33065339
ZOSVKSGD  value = 53307477
ZOSVKSGE  value = 35325092
ZOSVKSGS  value = 3527
ZOSVKSOE  value = 35429783
ZTMGRSET  value = 58713905
KMPDRDAT  value = 26227495
KMPDTP1   value = 38889938
KMPDTU01  value = 22784956
KMPDU2    value = 64593395
KMPDUTL   value = 12852869
KMPDUTL1  value = 35066682
KMPDUTL5  value = 102050245
KMPSGE    value = 82374092
KMPSLK    value = 25224151
KMPSUTL   value = 16326428
KMPSUTL1  value = 6501482
KMPVBETR  value = 35597542
KMPVCBG   value = 136451250
KMPVCCFG  value = 58493318
KMPVLOG   value = 71037567
KMPVVHL0  value = 2129001
KMPVVHLM  value = 203067955
KMPVVMCM  value = 54748909
KMPVVSTM  value = 32751079
KMPVVTCM  value = 52789858
```

## Unit Tests
```
FOIATEST>D ^ZOSVGUT4

 ---------------------------------- ZOSVGUT4 ----------------------------------
RUMSET - ZTMGRSET RUM Rename GTM/Cache Routines.--------------  [OK]   17.394ms
LOGRSRC - LOGRSRC^%ZOSV Resource Logger.----------------------  [OK]    3.629ms
SYSINFO - $$SYSINFO^KMPDUTL1 System Information.--------------  [OK]    1.957ms
CPUINFO - D CPU^KMPDUTL5 CPU Information.---------------------  [OK]   30.192ms
ROUFIND - ROUFIND^KMPDU2 Routine Find..-----------------------  [OK]   58.179ms
COVER - Cover Sheet Statistics Calculations
Gathering HL7 data... no data to report
Compiling Timing data...
20 records filed!
Compressing data into daily format...

Updating records to reflect transmission...

Finished!.----------------------------------------------------  [OK] 18905.342ms
SAGG - SAGG Data Collection......-----------------------------  [OK] 20183.231ms
VSTM - VSM Storage Monitor..----------------------------------  [OK]   13.349ms
VSTM2 - VSM Storage Monitor w/o DUZ("AG")..-------------------  [OK]   16.781ms
VBEM - VSM Business Event Monitor (replaces old CM task)..----  [OK]   31.118ms
VHLM - VSM Section HL7 mointor.-------------------------------  [OK]  116.375ms
VMCM - VSM Message Count Monitor..----------------------------  [OK] 1255.623ms
VTCM - VSM Timed Collection Monitor..-------------------------  [OK] 1758.910ms
TASK - Task Creator.------------------------------------------  [OK]    2.678ms
PATCHS - Test SAGG Patch Listing that they are correct.-------  [OK]    0.185ms
PATCHD - Test CM Patch Listing that they are correct.---------  [OK]    0.674ms
```
# Test Sites
None

# Future Plans
For this specific release, just bug fixes and output format improvements.
