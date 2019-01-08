## Introduction
This release adds a few new features and fixes a bug; and provides an overlay
for XPDUTL which was updated with XU\*8.0\*672.

Authored on 2019-01-07 by Sam Habiel; licensed under Apache 2.0.

## Download Location
https://github.com/shabiel/Kernel-GTM/releases/tag/XU-8.0-10005. You can either
get the unified build that installs 10001, 10002, 10004 & 10005; or just 10005
if you are keeping up to date; or `virgin_install.zip` zip file to install in
instances where KIDS is not operational yet. The zip file is cumulative of all
the Kernel Changes.

## Install Instructions
Minimum GT.M Version: 6.1
Minimum Cache Version: 2014.1

NB: This is the last version that will support GT.M 6.1. All the next versions
will require V6.3-001A as the mimimum version.

See the list of external dependencies first before installing. 

No pre-install; no post-install instructions.

Normal KIDS install. The multibuild installs XU\*8.0\*10001, 10002 & 10004 as
well.  It's safe to reinstall. Please see the instructions for XU\*8.0\*10001
for warnings, esp regarding the renaming of Taskman Site Parameters.

## Special Notes
None

## Options Affected
None

## Package Usage
This just updates the infrastructure. Users do not interact with this package
per se, except for using ZSY (see Documentation section).

## Documentation
See the documentation folder for documentation for the new APIs in %ZISH,
%ZOSV, and on how to use ^ZSY. The rest of the APIs are documented in
the VA manual found on the VDL
(https://www.va.gov/vdl/documents/Infrastructure/Kernel/krn8_0dg.pdf)

## Error Codes
### %ZISH 
* `,U-INVALID-DIRECTORY,` - Default directory does not exist. Fix Kernel Primary HFS Directory.
* `,U-ERROR,` - If GTM/YDB says region doesn't exist for a global. Should never happen.
### %ZOSV
* ",U255," - $$RTNDIR^%ZOSV failed to find a routine directory. Check your $gtmroutines variable.

## Internal Interfaces
This is a kernel package and it has a large amount of published and unpublished
APIs supplied by the Kernel.

## External Interfaces
The following system utilities must be present.

* `lsof` (GT.M only)
* `ps` (GT.M only)
* `awk` (GT.M/Cygwin Only)
* `openssl` (all)
* `shasum` (GT.M only)
* `xxd` (GT.M only)
* `base64` (GT.M only)
* `dig` (GT.M only)
* `ipcs` (GT.M/Linux Only)
* `rm/del` (all)
* `mv` (all)
* `wc` (GT.M/Cygwin)
* `grep` (GT.M/Cygwin)
* `stat` (all except Cache/Windows)
* `mkdir` (all)
* `wget` (all)
* `file` (all except Cache/Windows)
* `gzip` (all except Cache/Windows)
* `cut` (GT.M/Cygwin)
* `dos2unix` (all except Cache/Windows)

ON Cache/WINDOWS (not Cygwin), you need to install the latest products from here:
* Openssl for Windows: https://slproweb.com/products/Win32OpenSSL.html
* Wget for Windows: https://eternallybored.org/misc/wget/

## Change Log
### ZOSVGUX & ZOSVONT
New APIs:

* $$BL for byte length of a string
* $$BE for byte extract of a string
* $$ENV to get an environment variable from the OS

See the documentation folder for documentation for the new APIs in %ZISH.

### ZOSVONT
If you have have < 6 licenses, say that you have 15. Helps run VistA with
Cache w/o license (e.g. trail version).

### ZISHGUX
Fix error trap. Popping the stack using $ES was not happening often enough.

### XPDUTL
Overlay XU\*8.0\*672.

### Unit Tests: ZOSVONUT & ZOSVGUT5 (& ZOSVGUT3 continuation repointed)
Unit Tests for the changes are in ZOSVONUT & ZOSVGUT5. ZOSVGUT3's continuation
now points to ZOSVGUT5 since ZOSVGUT4 was never released.

## Package Components
```
PACKAGE: XU*8.0*10005     2019-01-08 3:22 pm                        PAGE 1
-------------------------------------------------------------------------------
TYPE: SINGLE PACKAGE                               TRACK NATIONALLY: YES
NATIONAL PACKAGE: KERNEL                         ALPHA/BETA TESTING: NO

DESCRIPTION:
Authored on 2019-01-07 by Sam Habiel; licensed under Apache 2.0

Kernel Enhancements for VistA Internationlization; XPDUTL overlay for
patch XU*8.0*672; ZISHGUX error trap fix.

Enhancements/Fixes:
- ZOSVGUX & ZOSVONT:
-- $$BL for byte length of a string
-- $$BE for byte extract of a string
-- $$ENV to get an environment variable from the OS

- ZOSVONT:
If you have have < 6 licenses, say that you have 15. Helps run VistA with
Cache w/o license (e.g. trail version). Previously users were instructed to
manually edit the routine.

- XPDUTL
$$PATCH^XPDUTL used to be limited up to a max patch number of
9999 as part of *672, restored back to 10 digits.

- ZISHGUX
Fix error trap. Popping the stack using $ES was not happening often
enough.

Unit test for Cache are all in ZOSVONUT; GTM/YDB are in ZOSVGUT5.
ZOSVGUT3 fixed so that it will run ZOSVGUT5 next. To run all GTM/YDB
tests, run ^ZOSVGUT1 first. It will run 1, 2, 3, and then 5 (4 is
reservered for a future release).

ENVIRONMENT CHECK:                               DELETE ENV ROUTINE:
 PRE-INIT ROUTINE:                          DELETE PRE-INIT ROUTINE:
POST-INIT ROUTINE: POST^XU810005           DELETE POST-INIT ROUTINE: No
PRE-TRANSPORT RTN:

ROUTINE:                                       ACTION:
   XPDUTL                                         SEND TO SITE
   ZISHGUX                                        SEND TO SITE
   ZOSVGUT3                                       SEND TO SITE
   ZOSVGUT5                                       SEND TO SITE
   ZOSVGUX                                        SEND TO SITE
   ZOSVONT                                        SEND TO SITE
   ZOSVONUT                                       SEND TO SITE
```

## Routine Checksums
```
XPDUTL    Calculated   24675755
ZISHGUX   Calculated   87435646
ZOSVGUT3  Calculated  188829925
ZOSVGUT5  Calculated   11458515
ZOSVGUX   Calculated   49353198
ZOSVONT   Calculated   28513292
ZOSVONUT  Calculated   48638310
```

## Unit Tests
While we expect all tests to pass; some of the tests launch processes and some
kill all processes and then count how many processes are left, and some of the
tests use Taskman to run tasks. Due to that, some of the tests may fail due to
how your system is configured. The tests expect a single VistA Unix user. If
you have processes lanuched by different Unix users, the tests may fail. Most
often these are either the Taskman tests (Taskman is either not running; or
rarely, overloaded); or the ZSY tests (tasks cannot be killed because they are
running as different users).

In the screenshots belows, any extra output in the tests is mostly elided. The
number of tests you end up with depends on the data and the operating system
you are running on. Some tests (such as those using openssl) don't work well
in Darwin or Cygwin, so they are skipped. Some tests run only on Linux.
Here are the tests:

 | Test Routine       | Mumps Implementation | Tests Patches  |
 | ------------------ | -------------------- | -------------- |
 | ZOSVGUT5           | GT.M & YottaDB       | 10004 & 10005  |
 | ZOSVGUT1           | GT.M & YottaDB       | (ALL) 10001, 10002, 10004, 10005 |
 | ZOSVONUT           | Intersystems Cache   | (ALL) 10002 & 10005  |

Testing Numbers by Operating System:

 | Test Routine       | #   |
 | ------------------ | --- |
 | ZOSVGUT5 (ALL)     | 12  |
 | ZOSVGUT1/Cygwin    | 177 |
 | ZOSVGUT1/Darwin    | 182 |
 | ZOSVGUT1/Linux     | 183 |
 | ZOSVONUT/Linux     | 28  |


### Running Unit Tests for this build only (GT.M/YDB)
```
$ mumps -r ZOSVGUT5


 ---------------------------------- ZOSVGUT5 ----------------------------------
ZTMGRSET - ZTMGRSET Rename Routines ; *10005*

Rename the routines in Patch 10005

ZTMGRSET Version 8.0 Patch level **34,36,69,94,121,127,136,191,275,355,446,584,1
0001,10003**
HELLO! I exist to assist you in correctly initializing the current account.
I think you are using GT.M (Unix)

I will now rename a group of routines specific to your operating system.
Routine:  ZOSVGUX Loaded, Saved as    %ZOSV

Routine:  ZIS4GTM
Routine:  ZISFGTM
Routine:  ZISHGUX Loaded, Saved as    %ZISH
Routine:  XUCIGTM
Routine: ZOSV2GTM
Routine:  ZISTCPS
Routine:  ZOSVKRG
Routine: ZOSVKSGE
Routine: ZOSVKSGS
Routine: ZOSVKSGD

Now to load routines common to all systems.
Routine:   ZTLOAD
Routine:  ZTLOAD1
Routine:  ZTLOAD2
Routine:  ZTLOAD3
Routine:  ZTLOAD4
Routine:  ZTLOAD5
Routine:  ZTLOAD6
Routine:  ZTLOAD7
Routine:      ZTM
Routine:     ZTM0
Routine:     ZTM1
Routine:     ZTM2
Routine:     ZTM3
Routine:     ZTM4
Routine:     ZTM5
Routine:     ZTM6
Routine:     ZTMS
Routine:    ZTMS0
Routine:    ZTMS1
Routine:    ZTMS2
Routine:    ZTMS3
Routine:    ZTMS4
Routine:    ZTMS5
Routine:    ZTMS7
Routine:    ZTMSH
Routine:     ZTER
Routine:    ZTER1
Routine:      ZIS
Routine:     ZIS1
Routine:     ZIS2
Routine:     ZIS3
Routine:     ZIS5
Routine:     ZIS6
Routine:     ZIS7
Routine:     ZISC
Routine:     ZISP
Routine:     ZISS
Routine:    ZISS1
Routine:    ZISS2
Routine:   ZISTCP
Routine:   ZISUTL
Routine:     ZTPP
Routine:     ZTP1
Routine:   ZTPTCH
Routine:   ZTRDEL
Routine:   ZTMOVE
Routine:    ZTBKC

ALL DONE.-----------------------------------------------------  [OK]  221.742ms
EC - $$EC^%ZOSV ; *10004*.------------------------------------  [OK]    2.740ms
ZSY - RUN ZSY with lsof in sbin ; *10004*

GT.M System Status users on 08-JAN-19 13:18:13
PID   PName   Device       Routine            Name                CPU Time
2932  mumps   BG-S9000     LGTM+25^%ZISTCPS   POSTMASTER          09:46:22
3136  mumps   BG-0         LOOP+2^HLCSMM1     POSTMASTER          09:46:21
5528  mumps   BG-0         LOOP+7^HLCSLM      POSTMASTER          09:46:18
7772  mumps   BG-0         GETTASK+3^%ZTMS1                       12:50:11
9376  mumps   BG-0         LOOP+2^HLCSMM1     POSTMASTER          09:46:18
9980  mumps   BG-0         GO+12^XMTDT        POSTMASTER          09:46:18
10920 mumps   BG-0         STARTIN+28^HLCSIN  POSTMASTER          09:46:18
11568 mumps   BG-0         STARTOUT+17^HLCSOUTPOSTMASTER          09:46:18
11592 mumps   BG-0         LOOP+2^HLCSMM1     POSTMASTER          09:46:20
13496 mumps   BG-0         IDLE+3^%ZTM        Taskman ROU 1       09:46:16
16976 mumps   BG-0         GO+26^XMKPLQ       POSTMASTER          09:46:18
17676 mumps   /dev/pty4    INTRPTALL+8^ZSY                        13:18:12

Total 12 users.
.-------------------------------------------------------------  [OK]  929.230ms
ACTJ - Use of $T +0 ; *10004*.--------------------------------  [OK]   25.913ms
PATCH - $$PATCH^XPDUTL, which prv accepted only 3 digits (10004 & 10005).
 -------------------------------------------------------------  [OK]    0.170ms
MAXREC - $$MAXREC^%ZISH - $T +0 ; *10004....------------------  [OK]   18.616ms
BL - $$BL^%ZOSV ; 10005.--------------------------------------  [OK]    0.041ms
BE - $$BE^%ZOSV ; 10005.--------------------------------------  [OK]    0.026ms
ENV - $$ENV^%ZOSV ; 10005.------------------------------------  [OK]    0.026ms

Ran 1 Routine, 9 Entry Tags
Checked 12 tests, with 0 failures and encountered 0 errors.
```
### Running Unit Tests for all the GT.M/YDB changes
```
$ mumps -r ZOSVGUT1


 ---------------------------------- ZOSVGUT1 ----------------------------------
SETNM - Set Environment Name----------------------------------  [OK]    0.957ms
ZRO1 - $ZROUTINES Parsing Single Object Multiple dirs.--------  [OK]    0.547ms
ZRO2 - $ZROUTINES Parsing 2 Single Object Single dir.---------  [OK]    0.109ms
ZRO3 - $ZROUTINES Parsing Shared Object/Code dir.-------------  [OK]    0.066ms
ZRO4 - $ZROUTINES Parsing Single Directory by itself.---------  [OK]    0.033ms
ZRO5 - $ZROUTINES Parsing Leading Space.----------------------  [OK]    0.044ms
ZRO7 - $ZROUTINES Shared Object Only.-------------------------  [OK]    0.031ms
ZRO8 - $ZROUTINES No shared object.---------------------------  [OK]    0.052ms
ZRO9 - $ZROUTINES Shared Object First.------------------------  [OK]    0.039ms
ZRO10 - $ZROUTINES Shared Object First but multiple rtn dirs.-  [OK]    0.045ms
ZRO99 - $$RTNDIR^%ZOSV Shouldn't be Empty.--------------------  [OK]    0.039ms
ACTJ - Default path through ACTJ^ZOSV.------------------------  [OK]   19.107ms
ACTJ0 - Force ^XUTL("XUSYS","CNT") to 0 to force algorithm to run...
 -------------------------------------------------------------  [OK]    0.579ms
AVJ - Available Jobs.-----------------------------------------  [OK]    0.211ms
DEVOK - Dev Okay..--------------------------------------------  [OK]    0.553ms
DEVOPN - Show open devices.-----------------------------------  [OK]    0.062ms
GETPEER - Get Peer.-------------------------------------------  [OK]    0.035ms
PRGMODE - Prog Mode

.-------------------------------------------------------------  [OK]   13.677ms
JOBPAR - Job Parameter -- Dummy; doesn't do anything useful..-  [OK]    0.667ms
LOGRSRC - Turn on Resource Logging----------------------------  [OK]    3.445ms
ORDER - Order.------------------------------------------------  [OK]    0.921ms
DOLRO - Ensure symbol table is saved correctly.---------------  [OK]    1.251ms
TMTRAN - Make sure that Taskman is running..------------------  [OK]  962.013ms
GETENV - Test GETENV.-----------------------------------------  [OK]    0.063ms
OS - OS.------------------------------------------------------  [OK]    0.039ms
VERSION - VERSION...------------------------------------------  [OK]    0.040ms
SID - System ID.----------------------------------------------  [OK]    0.036ms
UCI - Get UCI/Vol.--------------------------------------------  [OK]    0.027ms
UCICHECK - Noop.----------------------------------------------  [OK]    0.025ms
PARSIZ - PARSIZE NOOP.----------------------------------------  [OK]    0.022ms
NOLOG - NOLOG NOOP.-------------------------------------------  [OK]    0.028ms
SHARELIC - SHARELIC NOOP.-------------------------------------  [OK]    0.021ms
PRIORITY - PRIORITY NOOP.-------------------------------------  [OK]    0.021ms
PRIINQ - PRIINQ() NOOP.---------------------------------------  [OK]    0.022ms
BAUD - BAUD NOOP.---------------------------------------------  [OK]    0.021ms
SETTRM - Set Terminators.-------------------------------------  [OK]    0.159ms
LGR - Last Global Reference.----------------------------------  [OK]    0.066ms
EC - $$EC.----------------------------------------------------  [OK]    0.080ms
ZTMGRSET - ZTMGRSET Renames Routines on GT.M.-----------------  [OK]  207.533ms
ZHOROLOG - $ZHOROLOG Functions.....---------------------------  [OK]    0.064ms
TEMP - getting temp directory.--------------------------------  [OK]    2.931ms
PASS - PASTHRU and NOPASS.------------------------------------  [OK]    0.177ms
NSLOOKUP - Test DNS Utilities.......--------------------------  [OK] 1469.343ms
IPV6 - Test GT.M support for IPV6-----------------------------  [OK]    0.037ms
SSVNJOB - Replacement for ^$JOB in XQ82..---------------------  [OK] 1067.956ms
ZSY - Run System Status
.
--------------------------------------------------------------  [OK] 7371.469ms
HALTONE - Test HALTONE^ZSY entry point..----------------------  [OK]  386.590ms

 ---------------------------------- ZOSVGUT2 ----------------------------------
NOOP - Top doesn't do anything..------------------------------  [OK]    0.467ms
SAVE1 - Save a Routine normal......---------------------------  [OK]    7.258ms
SAVE2 - Save a Routine with syntax errors -- should not show..  [OK]  253.821ms
LOAD - Load Routine..-----------------------------------------  [OK]    7.048ms
RSUM - Checksums..--------------------------------------------  [OK]    0.894ms
TESTR - Test existence of routine.----------------------------  [OK]    1.037ms
DELSUPER - Test Super Duper Deleter..-------------------------  [OK]  170.227ms
XUSHSH - Top of XUSHSH.---------------------------------------  [OK]    0.474ms
SHA - SHA-1 and SHA-256 in Hex and Base64....-----------------  [OK]  616.426ms
BASE64 - Base 64 Encode and Decode..--------------------------  [OK]  275.770ms
RSAENC - Test RSA Encryption...-------------------------------  [OK] 1105.836ms
AESENC - Test AES Encryption.---------------------------------  [OK]  128.139ms
BROKER - Test the new GT.M MTL Broker.....
--------------------------------------------------------------  [OK] 1584.162ms
ACTJPEEK - Active Jobs using $$^%PEEKBYNAME("node_local.ref_cnt",...).
 -------------------------------------------------------------  [OK]    0.351ms
ACTJREG - Active Jobs using current API.----------------------  [OK]    0.229ms

 ---------------------------------- ZOSVGUT3 ----------------------------------
OPENH - Read a Text File in w/ Handle
..------------------------------------------------------------  [OK]   10.929ms
OPENNOH - Read a Text File w/o a Handle
..------------------------------------------------------------  [OK]    9.515ms
OPENBLOR - Read a File as a binary device (FIXED WIDTH)
..------------------------------------------------------------  [OK]    2.658ms
OPENBLOW - Write a File as a binary device (Use Capri zip file in 316.18)
.-------------------------------------------------------------  [OK]    4.804ms
OPENBLOV - Write and Read a variable record file
.-------------------------------------------------------------  [OK]   23.425ms
OPENDF - Open File from Default HFS Directory.----------------  [OK]    0.780ms
OPENSUB - Open file with a Specific Subtype....---------------  [OK]   17.680ms
OPENDLM - Forget delimiter in Path..--------------------------  [OK]   10.891ms
OPENAPP - Open with appending.--------------------------------  [OK]  145.535ms
PWD - Get Current Working Directory.--------------------------  [OK]    0.070ms
DEFDIR - Default Directory.....-------------------------------  [OK]    2.847ms
LIST - LIST^%ZISH...------------------------------------------  [OK]    3.093ms
MV - MV^%ZISH..-----------------------------------------------  [OK]   69.421ms
FTGGTF - $$FTG^%ZISH & $$GTF^%ZISH......----------------------  [OK]   94.450ms
GATF - $$GATF^%ZISH......-------------------------------------  [OK]  162.335ms
DEL1 - DEL1^%ZISH......---------------------------------------  [OK]   89.983ms
DEL - Delete files we created in the tests.....---------------  [OK]  280.052ms
DELERR - Delete Error.----------------------------------------  [OK]    0.157ms
OPENRPMS - Test RPMS OPEN^%ZISH (3 arg open)....--------------  [OK]   12.714ms
DELRPMS - Test RPMS DEL^%ZISH (reverse success, pass by value)....
    ----------------------------------------------------------  [OK]  132.515ms
LISTRPMS - Test LIST RPMS Version (2nd par is by value not by name)...
 -------------------------------------------------------------  [OK]    2.709ms
SIZE - $$SIZE^%ZISH.------------------------------------------  [OK]   66.498ms
MKDIR - $$MKDIR^%ZISH..---------------------------------------  [OK]  206.923ms
SEND - Test SEND^%ZISH (NOOP).--------------------------------  [OK]    0.051ms
SENDTO1 - Test SENDTO1^%ZISH (NOOP).--------------------------  [OK]    0.023ms
DF - Test DF^%ZISH (Directory Format).------------------------  [OK]    0.044ms

 ---------------------------------- ZOSVGUT5 ----------------------------------
ZTMGRSET - ZTMGRSET Rename Routines ; *10005*

ALL DONE.-----------------------------------------------------  [OK]   53.781ms
EC - $$EC^%ZOSV ; *10004*.------------------------------------  [OK]    0.407ms
ZSY - RUN ZSY with lsof in sbin ; *10004*
.-------------------------------------------------------------  [OK]  796.536ms
ACTJ - Use of $T +0 ; *10004*.--------------------------------  [OK]    0.350ms
PATCH - $$PATCH^XPDUTL, which prv accepted only 3 digits (10004 & 10005).
 -------------------------------------------------------------  [OK]    0.165ms
MAXREC - $$MAXREC^%ZISH - $T +0 ; *10004*....------------------  [OK]    6.812ms
BL - $$BL^%ZOSV ; 10005.--------------------------------------  [OK]    0.035ms
BE - $$BE^%ZOSV ; 10005.--------------------------------------  [OK]    0.030ms
ENV - $$ENV^%ZOSV ; 10005.------------------------------------  [OK]    0.054ms

Ran 4 Routines, 97 Entry Tags
Checked 177 tests, with 0 failures and encountered 0 errors.
```

### Cache Tests (all included)
I couldn't test $$BL and $$BE on Cache as Cache runs on UTF-16 (ehh.. almost)
and I couldn't think of an easy way to make a UTF-8 string to test in a KIDS
build.

```
$ csession CACHE -U CACHEVISTA ZOSVONUT


 ---------------------------------- ZOSVONUT ----------------------------------
XUSHSH - Top of XUSHSH.---------------------------------------  [OK]    0.041ms
SHA - SHA-1 and SHA-256 in Hex and Base64....-----------------  [OK]    0.092ms
BASE64 - Base 64 Encode and Decode..--------------------------  [OK]    0.029ms
RSAENC - Test RSA EncryptionGenerating a 2048 bit RSA private key
                               .....--------------------------  [OK]  144.947ms
AESENC - Test AES Encryption.---------------------------------  [OK]    0.059ms
SIZE - $$SIZE^%ZISH.------------------------------------------  [OK]    4.281ms
MKDIR - $$MKDIR^%ZISH for Unix...-----------------------------  [OK]   38.829ms
MDWIN - $$MKDIR^%ZISH for Windows-----------------------------  [OK]    0.039ms
WGETSYNC - $$WGETSYNC^%ZISH on NDF DAT files for Unix and Windows..
 -------------------------------------------------------------  [OK] 32391.497ms
ENV - $$ENV^%ZOSV ; 10005.------------------------------------  [OK]    0.038ms
AVJ - $$AVJ^%ZOSV ; 10005.------------------------------------  [OK]    0.036ms

Ran 1 Routine, 11 Entry Tags
Checked 28 tests, with 0 failures and encountered 0 errors. 
```

## Test Sites
None.

## Future Plans
Development continues on KMP Port and TLS support for VistA; client HTTPS was
added in `XT*7.3*10002`.
