## Introduction
This is a port of Kernel Lock Manager (`XU*8.0*607` and `XU*8.0*608`) to GT.M
and YottaDB; and provides an implementation of %ZLMLIB code for Cache as well.

Currently, this code is for testing only. Try it and let me know how it works.

Authored on 2020-01-02 by Sam Habiel; licensed under Apache 2.0.

## Download Location
https://github.com/shabiel/Kernel-GTM/releases/tag/XU-8.0-10007-alpha.

## Install Instructions
Minimum GT.M Version: 6.1
Minimum Cache Version: 2014.1

No external dependencies.

Normal KIDS install. You need `XU*8.0*607` and `XU*8.0*608` installed first;
this patch makes some tiny fixes only.

No pre-install.

Post-install instructions can be found in the Kernel Lock Manager supplement
on https://www.va.gov/vdl/documents/Infrastructure/Kernel/xu_8_0_608_sp.pdf.

Build is safe to reinstall.

## Special Notes
None

## Options Affected
None

## Package Usage
See https://www.va.gov/vdl/documents/Infrastructure/Kernel/xu_8_0_608_sp.pdf.

## Documentation
See https://www.va.gov/vdl/documents/Infrastructure/Kernel/xu_8_0_608_sp.pdf.

## Error Codes
None.

## Internal Interfaces
None. This package does not expose any APIs.

## External Interfaces
On GT.M and YottaDB, use of the bundled `lke` utility on the command line.

None for InterSystems Cache.

## Change Log
XULM: Remove check to run only on cache
XULMU: Move platform dependent code to %ZLMLIB in $$NODE and $$VERSION
XULMUI: Add missing QUIT at the end of OPTIONS
Create %ZLMLIB; Update ZTMGRSET to rename ZLMLIB to %ZLMLIB
ZOSVGUT7 contains Unit Tests for %ZLMLIB

## Unit Tests: ZOSVGUT7
Unit Tests for the changes are in ZOSVGUT7. There are expected failures in
Cache as the ^$LOCK SSVN does not return local variable locks. This will be
remedied in a future iteration of this build (see the section on Future Plans
below).

YottaDB:

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

Cache:
```
$ csession CACHE -U FOIA ZOSVGUT7


 ---------------------------------- ZOSVGUT7 ----------------------------------
NODE - $$NODE^%ZLMLIB().--------------------------------------  [OK]    0.069ms
VOLUME - $$VOLUME^%ZLMLIB().----------------------------------  [OK]    0.044ms
LOCKQRY - LOCKQRY^%ZLMLIB.
LOCKQRY^ZOSVGUT7 - LOCKQRY^%ZLMLIB - no failure message provided
.
LOCKQRY^ZOSVGUT7 - LOCKQRY^%ZLMLIB - Error: <UNDEFINED>LOCKQRY+5^ZOSVGUT7 *RSET("ZOSVJOB")
--------------------------------------------------------------  [FAIL]   21.867ms
NXTLOCK - NXTLOCK^%ZLMLIB
NXTLOCK^ZOSVGUT7 - NXTLOCK^%ZLMLIB - no failure message provided
.
NXTLOCK^ZOSVGUT7 - NXTLOCK^%ZLMLIB - Error: <UNDEFINED>NXTLOCK+9^ZOSVGUT7 *LOCKS("ZOSVJOB")
--------------------------------------------------------------  [FAIL]   21.970ms
OSUSER - $$OSUSER^%ZLMLIB(PID).-------------------------------  [OK]    1.312ms
XULMU - $$GETLOCKS^XULMU.-------------------------------------  [OK]   24.334ms

Ran 1 Routine, 6 Entry Tags
Checked 11 tests, with 2 failures and encountered 2 errors.
```

## Package Components
```
PACKAGE: XU*8.0*10007     Jan 02, 2020 10:16 am                          PAGE 1
-------------------------------------------------------------------------------
TYPE: SINGLE PACKAGE                               TRACK NATIONALLY: YES
NATIONAL PACKAGE: KERNEL                         ALPHA/BETA TESTING: NO

DESCRIPTION:
Lock Manager Port to GT.M/YottaDB plus missing code for Cache.

ENVIRONMENT CHECK:                               DELETE ENV ROUTINE:
 PRE-INIT ROUTINE:                          DELETE PRE-INIT ROUTINE:
POST-INIT ROUTINE: POST^XU810007           DELETE POST-INIT ROUTINE: No
PRE-TRANSPORT RTN:

ROUTINE:                                       ACTION:
   XULM                                           SEND TO SITE
   XULMU                                          SEND TO SITE
   XULMUI                                         SEND TO SITE
   ZLMLIB                                         SEND TO SITE
   ZOSVGUT7                                       SEND TO SITE
   ZTMGRSET                                       SEND TO SITE

REQUIRED BUILDS:                               ACTION:
   XU*8.0*607                                     Don't install, leave global
   XU*8.0*608                                     Don't install, leave global
```

## Routine Checksums
```
XU810007  value = 34460
XULM      value = 81074019
XULMU     value = 43445231
XULMUI    value = 170711923
ZLMLIB    value = 8088251
ZOSVGUT7  value = 5838845
ZTMGRSET  value = 57259340
```

## Test Sites
None.

## Future Plans
There is a forthcoming patch XU*8.0*722 that makes some fixes to the Lock
Manager.

I am trying to get a copy via FOIA of the actual %ZLMLIB code so that I can
implement YottaDB/GTM code around it. The current version doesn't work for
Cache for local locks.
