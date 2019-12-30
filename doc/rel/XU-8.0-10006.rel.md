## Introduction
This release fixes two critical bugs found by David Whitten, plus various
miscelaneous bugs. There are two enhancements: Addition of KILLJOB^ZSY, an
interactive way to kill jobs from ZSY, and update of ZOSFGUX to mirror the
updates of ZOSFONT in patch *661.

The two critical bugs were found after deployment in production, and are:
- When mupip interrupt interrupts a mupip replication process, replication
hangs. ZSY will now only interrupt mumps processes.
- $$ACTJ^%ZOSV has an old job counting algorithm for GT.M versions less than
6.3 (released 2016-03-29). The algorithm didn't work properly. It's now fixed.

Authored on 2019-12-30 by Sam Habiel; licensed under Apache 2.0.

## Download Location
https://github.com/shabiel/Kernel-GTM/releases/tag/XU-8.0-10006. You can either
get the unified build that installs 10001, 10002, 10004, 10005 & 10006; or just
10006, if you are keeping up to date; or `virgin_install.zip` zip file to
install in instances where KIDS is not operational yet. The
`virgin_install.zip` file is cumulative of all the Kernel Changes.

## Install Instructions
Minimum GT.M Version: 6.1
Minimum Cache Version: 2014.1

See the list of external dependencies first before installing. 

No pre-install; no post-install instructions.

Normal KIDS install. The multibuild installs XU\*8.0\*10001, 10002, 10004,
10005, 10006.  It's safe to reinstall. Please see the instructions for
XU\*8.0\*10001 for warnings, esp regarding the renaming of Taskman Site
Parameters.

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
- XPDCOMF: Remove infinite loop. When an entry has a name in the B cross-index
longer than 30 characters, and it has two values for that indexed value, (a
very rare situation) the broken code skips that value and goes to the next one,
but doesn't update the DIN2 value to the right value, and thus loops forever.
[Conributed by David Whitten].
- LIST^%ZISH error trap: Due to fixes in YottaDB stack handling, it was found
that the stack did not completely unwind when $ZPARSE of a directory fails from
$$LIST. This is now fixed.
- AESENC^ZOSVGUT2 test bandaid fix. Newer versions of openssl now warn you if
you don't specify a full hex key. Rather than fix the implementation to do
error checks or do hex-encoding etc., I just fixed the test to specify proper
keys. If I ever go and finish the openssl plugin, that will be the way to go.
Not worth fixing right now as nobody that I know uses this on GTM right now.
- XLFIPV & XLFNSLK. Change +$SY=47 to $P($SY,",")=47 to prevent + error on
Cache on Docker
- ZSY fixes
  - Only issue interrups to mumps processes. When issued to mupip, it caused
  replication to hang. (Contributed by David Whitten).
  - Preserve $test during interrups (Contributed by David Whitten).
  - Add space for columns that contain data that may run into the next column
  so that you can read it (Contributed by David Whitten).
  - Exit prompts using Q/q in addition to ^ (Contributed by David Whitten).
  - RESJOB/KILLJOB entry points to interactively kill a job. Used by
  ^%ZOSF("RESJOB").
  - IO Cleanup: Don't switch to $P. Always use $IO.
- Updates to ZOSFGUX to mirror *661 updates to ZOSFONT.
  - NOASK entry point for silent setting of nodes
  - ONE(X) to set a single node
  - Short description for each node
  - Remove code in INIT not found in Cache version
  - Nodes: Remove $INC, add GSEL, fix RESJOB, remove commented text
- DEL^%ZOSV2: Did not restore the current device prior to closing files, and as
a result, always made $P the current device.
- $$ACTJ^%ZOSV: Old job counting algorithm did not work. Due to the fact that
I could not test it as I do not run a GT.M version <6.3, the bug stayed in the
code. It should be fixed now. There were two issues:
  - Code would not run if it did not run before (a catch 22 situation).
  - Clock comparison was incorrect, and the code never ran.

## Unit Tests: ZOSVGUT6 (& ZOSVGUT5 continuation added)
Unit Tests for the changes are in ZOSVGUT6. 

## Package Components
```
PACKAGE: XU*8.0*10006     Dec 30, 2019 4:27 pm                    PAGE 1
-------------------------------------------------------------------------------
TYPE: SINGLE PACKAGE                               TRACK NATIONALLY: YES
NATIONAL PACKAGE: KERNEL                         ALPHA/BETA TESTING: NO

DESCRIPTION:
See https://github.com/shabiel/Kernel-GTM/releases for release notes.

ENVIRONMENT CHECK:                               DELETE ENV ROUTINE:
 PRE-INIT ROUTINE:                          DELETE PRE-INIT ROUTINE:
POST-INIT ROUTINE: POST^XU810006           DELETE POST-INIT ROUTINE: No
PRE-TRANSPORT RTN:

ROUTINE:                                       ACTION:
   XLFIPV                                         SEND TO SITE
   XLFNSLK                                        SEND TO SITE
   XPDCOMF                                        SEND TO SITE
   ZISHGUX                                        SEND TO SITE
   ZOSFGUX                                        SEND TO SITE
   ZOSV2GTM                                       SEND TO SITE
   ZOSVGUT2                                       SEND TO SITE
   ZOSVGUT5                                       SEND TO SITE
   ZOSVGUT6                                       SEND TO SITE
   ZOSVGUX                                        SEND TO SITE
   ZSY                                            SEND TO SITE
```

## Routine Checksums
```
XLFIPV    value = 98894515
XLFNSLK   value = 45468707
XPDCOMF   value = 114363666
XU810006  value = 34423
ZISHGUX   value = 87874571
ZOSFGUX   value = 36985461
ZOSV2GTM  value = 13189023
ZOSVGUT2  value = 43609432
ZOSVGUT5  value = 4209221
ZOSVGUT6  value = 35851854
ZOSVGUX   value = 50734003
ZSY       value = 458965184
```

## Unit Tests for this build only (GT.M/YDB)
```
$ mumps -r ZOSVGUT6


 ---------------------------------- ZOSVGUT6 ----------------------------------
ZTMGRSET - ZTMGRSET Rename Routines ; *10006*.----------------  [OK]   15.724ms
ZOSFGUX1 - *10006 NOASK^ZOSFGUX...----------------------------  [OK]    2.867ms
ZOSFGUX2 - *10006 ONE^ZOSFGUX...------------------------------  [OK]    0.067ms
RESJOB - *10006 test ^%ZOSF("RESJOB") & RESJOB^ZSY...---------  [OK]  263.169ms
DELDEV - *10006 DEL^%ZOSV2 does not preserve current device...  [OK]   27.768ms
CNTOLD1 - Test Old Process Counting - No XUTL node....--------  [OK]    8.147ms
CNTOLD2 - Test Old Process Counting - XUTL Node for "CNT" not "SEC"......
 -------------------------------------------------------------  [OK]    8.876ms
CNTOLD3 - Test Old Process Counting - Reset the counter at the tok....
 -------------------------------------------------------------  [OK] 2015.547ms

Ran 1 Routine, 8 Entry Tags
Checked 27 tests, with 0 failures and encountered 0 errors.
```

## Test Sites
None.

## Future Plans
Development continues on KMP Port and TLS support for VistA; client HTTPS was
added in `XT*7.3*10002` but has many bugs and needs to be fixed. Lock manager
(XU*8.0*607 & XU*8.0*608) will be started soon.
