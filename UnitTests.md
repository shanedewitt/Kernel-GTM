# Unit Tests
## Summary
Unit Tests for GT.M and YottaDB are called using ^ZOSVGUT1. There are four
routines that contain unit tests: ZOSVGUT1-3 and ZOSVGUT5. ZOSVGUT4 is for the
Capacity Management Packages and has not been released in a package yet.

For Cache, this project contains the "unredaction" of XUSHSH for Cache, NDF
file management support for PSN\*4.0\*10001, support for $$ENV^%ZOSV, and a fix
for $$AVJ^%ZOSV. The unit tests to test these changes are in ZOSVONUT.

They test every single change that was made in this project. Here's a summary
of all the tests.

 | Test Routine       | Mumps Implementation | Tests Patches  |
 | ------------------ | -------------------- | -------------- |
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

In the screenshots belows, any extra output in the tests is mostly elided. The
number of tests you end up with depends on the data and the operating system
you are running on. Some tests (such as those using openssl) don't work well
in Darwin or Cygwin, so they are skipped. Some tests run only on Linux.
Here are the tests.

### GT.M/YottaDB Unit Tests
Tests ran by `ZOSVGUT1`:
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
