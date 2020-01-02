# Unit Tests
## Summary
Unit Tests for GT.M and YottaDB are called using ^ZOSVGUT1. There are six
routines that contain unit tests: ZOSVGUT1-3 and ZOSVGUT5-7. ZOSVGUT4 is for the
Capacity Management Packages and has not been released in a package yet.

Unit Tests use M-Unit 1.6, which is available at https://github.com/ChristopherEdwards/M-Unit/releases.

For Cache, this project contains the "unredaction" of XUSHSH for Cache, NDF
file management support for PSN\*4.0\*10001, support for $$ENV^%ZOSV, and a fix
for $$AVJ^%ZOSV. The unit tests to test these changes are in ZOSVONUT.

They test every single change that was made in this project. Here's a summary
of all the tests.

 | Test Routine       | Mumps Implementation | Tests Patches  |
 | ------------------ | -------------------- | -------------- |
 | ZOSVGUT1           | GT.M & YottaDB       | 10001, 10002, 10004, 10005, 10006 |
 | ZOSVONUT           | Intersystems Cache   | 10002 & 10005  |
 | ZOSVGUT7           | Both                 | 10007          |

Testing Numbers by Operating System:

 | Test Routine       | #   |
 | ------------------ | --- |
 | ZOSVGUT1/Centos 7  | 210 |
 | ZOSVGUT1/Ubuntu 18 | 214 |
 | ZOSVONUT/Linux     | 28  |
 | ZOSVGUT7/All       | 13  |

## Test Setup Notes
The tests need `stat` command, and need access to a writable `PRIMARY HFS
DIRECTORY`. The HFS files used in GT.M/YottaDB tests are those in /usr/include;
in my experience these always exist except in the latest version of macOS,
where they need to be installed manually.

## Test Failure Notes
For GT.M/YottaDB, there are certain tests that may fail. You need to be aware of which ones:

 * TMTRAN - Make sure that Taskman is running. This fails occassionally because
 taskman is given 3 seconds to complete a task and sometimes can't complete it
 in that time.
 * ZSY - It counts processes before stopping them and after. If you didn't have
 any other processes running (i.e. Taskman was also down), you will get a failure
 here. Also, if you have an M process that is zsystemed out into the shell, you
 won't be able to kill them either. If you have M processes running under another
 user that open the same database, you won't be able to kill those either. All
 of these conditions may lead this test to fail.
 * RSAENC - RSA Encryption. This fails on certain versions of openssl. I haven't
 figured out yet which ones; but they ask you for a password when they shouldn't.
 If that happens to you, press CTRL-C, and then type ZC. Your text will be
 repeated, that's okay. To restore sanity, run ZSY "stty sane" when you are done.

The tests have been done on multiple versions of GT.M and YottaDB on Linux x64,
Darwin x64, Cygwin x32, and Arm7v.

## Test Screenscrapes

The number of tests you end up with depends on the data and the operating
system you are running on. Some tests (such as those using openssl) don't work
well in Darwin or Cygwin, so they are skipped. Some tests run only on Linux.
Here are the tests.

### GT.M/YottaDB Unit Tests
Tests ran by `ZOSVGUT1`:
```
[foia@00d278f7050e tmp]$ mumps -r ZOSVGUT1


 ---------------------------------- ZOSVGUT1 ----------------------------------
SETNM - Set Environment Name----------------------------------  [OK]    0.140ms
ZRO1 - $ZROUTINES Parsing Single Object Multiple dirs.--------  [OK]    0.083ms
ZRO2 - $ZROUTINES Parsing 2 Single Object Single dir.---------  [OK]    0.019ms
ZRO3 - $ZROUTINES Parsing Shared Object/Code dir.-------------  [OK]    0.016ms
ZRO4 - $ZROUTINES Parsing Single Directory by itself.---------  [OK]    0.013ms
ZRO5 - $ZROUTINES Parsing Leading Space.----------------------  [OK]    0.015ms
ZRO7 - $ZROUTINES Shared Object Only.-------------------------  [OK]    0.013ms
ZRO8 - $ZROUTINES No shared object.---------------------------  [OK]    0.014ms
ZRO9 - $ZROUTINES Shared Object First.------------------------  [OK]    0.014ms
ZRO10 - $ZROUTINES Shared Object First but multiple rtn dirs.-  [OK]    0.015ms
ZRO99 - $$RTNDIR^%ZOSV Shouldn't be Empty.--------------------  [OK]    0.017ms
ACTJ - Default path through ACTJ^ZOSV.------------------------  [OK]    0.746ms
ACTJ0 - Force ^XUTL("XUSYS","CNT") to 0 to force algorithm to run...
 -------------------------------------------------------------  [OK]    0.085ms
AVJ - Available Jobs.-----------------------------------------  [OK]    0.051ms
DEVOK - Dev Okay..--------------------------------------------  [OK]    0.080ms
DEVOPN - Show open devices.-----------------------------------  [OK]    0.022ms
GETPEER - Get Peer.-------------------------------------------  [OK]    0.015ms
PRGMODE - Prog Mode

.-------------------------------------------------------------  [OK]   25.400ms
JOBPAR - Job Parameter -- Dummy; doesn't do anything useful..-  [OK]    0.137ms
LOGRSRC - Turn on Resource Logging----------------------------  [OK]    0.018ms
ORDER - Order.------------------------------------------------  [OK]    0.384ms
DOLRO - Ensure symbol table is saved correctly.---------------  [OK]    0.555ms
TMTRAN - Make sure that Taskman is running..------------------  [OK] 1254.057ms
GETENV - Test GETENV.-----------------------------------------  [OK]    0.035ms
OS - OS.------------------------------------------------------  [OK]    0.017ms
VERSION - VERSION...------------------------------------------  [OK]    0.021ms
SID - System ID.----------------------------------------------  [OK]    0.019ms
UCI - Get UCI/Vol.--------------------------------------------  [OK]    0.016ms
UCICHECK - Noop.----------------------------------------------  [OK]    0.015ms
PARSIZ - PARSIZE NOOP.----------------------------------------  [OK]    0.029ms
NOLOG - NOLOG NOOP.-------------------------------------------  [OK]    0.029ms
SHARELIC - SHARELIC NOOP.-------------------------------------  [OK]    0.019ms
PRIORITY - PRIORITY NOOP.-------------------------------------  [OK]    0.013ms
PRIINQ - PRIINQ() NOOP.---------------------------------------  [OK]    0.013ms
BAUD - BAUD NOOP.---------------------------------------------  [OK]    0.013ms
SETTRM - Set Terminators.-------------------------------------  [OK]    0.080ms
LGR - Last Global Reference.----------------------------------  [OK]    0.033ms
EC - $$EC.----------------------------------------------------  [OK]    0.068ms
ZTMGRSET - ZTMGRSET Renames Routines on GT.M.-----------------  [OK]   17.348ms
ZHOROLOG - $ZHOROLOG Functions.....---------------------------  [OK]    0.040ms
TEMP - getting temp directory.--------------------------------  [OK]    0.098ms
PASS - PASTHRU and NOPASS.------------------------------------  [OK]    0.047ms
NSLOOKUP - Test DNS Utilities.......--------------------------  [OK]  194.975ms
IPV6 - Test GT.M support for IPV6.----------------------------  [OK]    0.130ms
SSVNJOB - Replacement for ^$JOB in XQ82..---------------------  [OK]   15.194ms
ZSY - Run System Status...
 -------------------------------------------------------------  [OK] 5187.085ms
HALTONE - Test HALTONE^ZSY entry point..----------------------  [OK]  264.377ms

 ---------------------------------- ZOSVGUT2 ----------------------------------
NOOP - Top doesn't do anything..------------------------------  [OK]    0.274ms
SAVE1 - Save a Routine normal......---------------------------  [OK]    1.810ms
SAVE2 - Save a Routine with syntax errors -- should not show..  [OK]   16.403ms
LOAD - Load Routine..-----------------------------------------  [OK]    3.349ms
RSUM - Checksums..--------------------------------------------  [OK]    0.243ms
TESTR - Test existence of routine.----------------------------  [OK]    0.236ms
DELSUPER - Test Super Duper Deleter..-------------------------  [OK]   34.334ms
XUSHSH - Top of XUSHSH.---------------------------------------  [OK]    0.171ms
SHA - SHA-1 and SHA-256 in Hex and Base64....-----------------  [OK]   86.351ms
BASE64 - Base 64 Encode and Decode..--------------------------  [OK]    3.316ms
RSAENC - Test RSA Encryption........--------------------------  [OK]  130.278ms
AESENC - Test AES Encryption.---------------------------------  [OK]   11.603ms
BROKER - Test the new GT.M MTL Broker.....
--------------------------------------------------------------  [OK]  675.206ms
ACTJPEEK - Active Jobs using $$^%PEEKBYNAME("node_local.ref_cnt",...).
 -------------------------------------------------------------  [OK]    0.477ms
ACTJREG - Active Jobs using current API.----------------------  [OK]    0.162ms

 ---------------------------------- ZOSVGUT3 ----------------------------------
OPENH - Read a Text File in w/ Handle
..------------------------------------------------------------  [OK]    7.130ms
OPENNOH - Read a Text File w/o a Handle
..------------------------------------------------------------  [OK]    5.276ms
OPENBLOR - Read a File as a binary device (FIXED WIDTH)
..------------------------------------------------------------  [OK]    0.507ms
OPENBLOW - Write a File as a binary device (Use Capri zip file in 316.18)
.-------------------------------------------------------------  [OK]    0.680ms
OPENBLOV - Write and Read a variable record file
.-------------------------------------------------------------  [OK]    4.444ms
OPENDF - Open File from Default HFS Directory.----------------  [OK]    0.190ms
OPENSUB - Open file with a Specific Subtype....---------------  [OK]    4.656ms
OPENDLM - Forget delimiter in Path..--------------------------  [OK]    3.389ms
OPENAPP - Open with appending.--------------------------------  [OK]    3.227ms
PWD - Get Current Working Directory.--------------------------  [OK]    0.046ms
DEFDIR - Default Directory.....-------------------------------  [OK]    0.452ms
LIST - LIST^%ZISH...------------------------------------------  [OK]    0.352ms
MV - MV^%ZISH..-----------------------------------------------  [OK]    2.504ms
FTGGTF - $$FTG^%ZISH & $$GTF^%ZISH......----------------------  [OK]    8.855ms
GATF - $$GATF^%ZISH......-------------------------------------  [OK]   38.047ms
DEL1 - DEL1^%ZISH......---------------------------------------  [OK]    2.452ms
DEL - Delete files we created in the tests.....---------------  [OK]    7.813ms
DELERR - Delete Error.----------------------------------------  [OK]    0.101ms
OPENRPMS - Test RPMS OPEN^%ZISH (3 arg open)....--------------  [OK]    3.938ms
DELRPMS - Test RPMS DEL^%ZISH (reverse success, pass by value)....
    ----------------------------------------------------------  [OK]    5.973ms
LISTRPMS - Test LIST RPMS Version (2nd par is by value not by name)...
 -------------------------------------------------------------  [OK]    0.381ms
SIZE - $$SIZE^%ZISH.------------------------------------------  [OK]    2.344ms
MKDIR - $$MKDIR^%ZISH..---------------------------------------  [OK]    9.069ms
SEND - Test SEND^%ZISH (NOOP).--------------------------------  [OK]    0.067ms
SENDTO1 - Test SENDTO1^%ZISH (NOOP).--------------------------  [OK]    0.022ms
DF - Test DF^%ZISH (Directory Format).------------------------  [OK]    0.025ms

 ---------------------------------- ZOSVGUT5 ----------------------------------
ZTMGRSET - ZTMGRSET Rename Routines ; *10005*.----------------  [OK]   10.190ms
EC - $$EC^%ZOSV ; *10004*.------------------------------------  [OK]    0.125ms
ZSY - RUN ZSY with lsof in sbin ; *10004*. [OK] 1126.763ms
ACTJ - Use of $T +0 ; *10004*.--------------------------------  [OK]    0.162ms
PATCH - $$PATCH^XPDUTL, which prv accepted only 3 digits (10004 & 10005).
 -------------------------------------------------------------  [OK]    0.059ms
MAXREC - $$MAXREC^%ZISH - $T +0 ; *10004....------------------  [OK]    5.217ms
BL - $$BL^%ZOSV ; 10005.--------------------------------------  [OK]    0.027ms
BE - $$BE^%ZOSV ; 10005.--------------------------------------  [OK]    0.021ms
ENV - $$ENV^%ZOSV ; 10005.------------------------------------  [OK]    0.037ms

 ---------------------------------- ZOSVGUT6 ----------------------------------
ZTMGRSET - ZTMGRSET Rename Routines ; *10006*.----------------  [OK]   14.118ms
ZOSFGUX1 - *10006 NOASK^ZOSFGUX...----------------------------  [OK]    0.134ms
ZOSFGUX2 - *10006 ONE^ZOSFGUX...------------------------------  [OK]    0.033ms
RESJOB - *10006 test ^%ZOSF("RESJOB") & RESJOB^ZSY...---------  [OK]  263.444ms
DELDEV - *10006 DEL^%ZOSV2 does not preserve current device...  [OK]   28.061ms
CNTOLD1 - Test Old Process Counting - No XUTL node....--------  [OK]    6.600ms
CNTOLD2 - Test Old Process Counting - XUTL Node for "CNT" not "SEC"......
 -------------------------------------------------------------  [OK]    8.699ms
CNTOLD3 - Test Old Process Counting - Reset the counter at the tok....
 -------------------------------------------------------------  [OK] 2010.425ms

Ran 5 Routines, 105 Entry Tags
Checked 210 tests, with 0 failures and encountered 0 errors.
```
Tests ran by `ZOSVGUT7`:
```
$ mumps -r ZOSVGUT7


 ---------------------------------- ZOSVGUT7 ----------------------------------
NODE - $$NODE^%ZLMLIB().--------------------------------------  [OK]    0.056ms
VOLUME - $$VOLUME^%ZLMLIB().----------------------------------  [OK]    0.048ms
LOCKQRY - LOCKQRY^%ZLMLIB.....--------------------------------  [OK]    3.991ms
NXTLOCK - NXTLOCK^%ZLMLIB....---------------------------------  [OK]    2.715ms
OSUSER - $$OSUSER^%ZLMLIB(PID).-------------------------------  [OK]    2.408ms
XULMU - $$GETLOCKS^XULMU.-------------------------------------  [OK]    6.944ms

Ran 1 Routine, 6 Entry Tags
Checked 13 tests, with 0 failures and encountered 0 errors.
```

### Cache Tests
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
