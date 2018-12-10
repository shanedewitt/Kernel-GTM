# Toolkit v7.3 Patch 10002
## Introduction
This patch provides optimized HTTPS transport for VistA. It does that by
using the `libcurl` binding for GT.M/YDB (https://github.com/shabiel/fis-gtm-plugins/tree/master/libcurl)
or using the `%Net.HttpRequest` Cache Class to perform HTTP communication.

Authored on 2018/12/10 by Sam Habiel; licensed under Apache 2.0.

## Download
https://github.com/shabiel/Kernel-GTM/releases/download/XT-7.3-10002/XT-7p3-10002T1.KID

## Install Instructions
Minimum GT.M Version: Unknown  - should work in all recent versions
Minimum Cache Version: Unknown - should work in all recent versions

This is a normal KIDS build install. There are some non-VistA pre-requisites
that need to be performed before or after the KIDS build install:

 * GTM/YDB: Install libcurl and set environment variable variable `GTMXC_libcurl`
   to the path of the .xc file for libcurl.
 * Intersystems Cache: While HTTP communication works out of the box, HTTPS
   requires adding the `encrypt_only` SSL configuration. This is added by
   `XOBW*1.0*4` (https://foia-vista.osehra.org/Patches_By_Application/XOBW-WEB%20SERVICES%20CLIENT/XOBW-1_SEQ-4_PAT-4.TXT), but it can be turned using this code:

```
CACHETLS ; Create a client SSL/TLS config on Cache
 ;
 ; Create the configuration
 N NMSP S NMSP=$ZU(5)
 ZN "%SYS"
 n config,status
 n % s %=##class(Security.SSLConfigs).Exists("encrypt_only",.config,.status) ; check if config exists
 i '% d
 . n prop s prop("Name")="encrypt_only"
 . s %=##class(Security.SSLConfigs).Create("encrypt_only",.prop) ; create a default ssl config
 . i '% w $SYSTEM.Status.GetErrorText(%) s $ec=",u-cache-error,"
 . s %=##class(Security.SSLConfigs).Exists("encrypt_only",.config,.status) ; get config
 e  s %=config.Activate()
 ZN NMSP
 QUIT
```

## Special Notes
None

## Options Affected
None

## Package Usage
This just updates the infrastructure. Users do not interact with this package
per se.

## Documentation
This package does not alter the API distributed in VistA; but adds two helper
APIS. It's just a single API: $$GETURL^XTHC10. This API is documented in the VA
manual on the VDL (https://www.va.gov/vdl/documents/Infrastructure/Kernel/krn8_0dg.pdf)
as well as on the hardhats.org website (http://hardhats.org/kernel/html/x-geturl%5Exthc10.shtml).

### Extra APIS
The original code was written with the idea that a connection would be opened
and then closed for each API call. That is very expensive to do, especially when
TLS is involved, as every call will need to perform TLS negotiation again. While
this mode is still supported, you now have the option to keep the connection
option for multiple HTTP requests. To do that, you need to call `D INIT^XTHC10(0)`,
then call `$$GETURL^XTCH10` multiple times. Once you are done doing all your
calls, call `D CLEANUP^XTHC10`.

### Error Codes
No new error codes are introduced.

## Internal Interfaces
 * Unit testing is done using ^%ut (M-Unit).
 * HOME^%ZIS (IA #10086)

## External Interfaces
 * None on Intersystems Cache
 * libcurl on GT.M/YDB

## Change Log
 * First release December 2018

## Package Components
```
PACKAGE: XT*7.3*10002     2018-12-10 2:04:50 pm                     PAGE 1
-------------------------------------------------------------------------------
TYPE: SINGLE PACKAGE                               TRACK NATIONALLY: YES
NATIONAL PACKAGE: TOOLKIT                        ALPHA/BETA TESTING: NO

DESCRIPTION:
Optimized HTTP Communication for GT.M/YDB and Cache.

ENVIRONMENT CHECK:                               DELETE ENV ROUTINE:
 PRE-INIT ROUTINE:                          DELETE PRE-INIT ROUTINE:
POST-INIT ROUTINE:                         DELETE POST-INIT ROUTINE:
PRE-TRANSPORT RTN:

ROUTINE:                                       ACTION:
   XTHC                                           SEND TO SITE
   XTHC10                                         SEND TO SITE
```

## Routine Checksums
```
XTHC      value = 15335318
XTHC10    value = 63240687
```

## Unit Tests
Please note that in my version of Cache (2014; and likely 2018 as wel), unit
tests that call httpbin.org (TGET1, TPOST, TESTH) fail due to lack of support
for Server Name Indication, a TLS extension. Also, Cache seems to renegotiate
TLS on the same connection; not providing as much speed improvements as
libcurl.

Tests can be invoked by `D TEST^XTHC`:

Sample results from GT.M/YDB:
```
 ------------------------------------ XTHC ------------------------------------
TGET1 - GET via TLS..-----------------------------------------  [OK]  218.347ms
TGET2 - GET example.com.--------------------------------------  [OK]  116.526ms
TPOST - Test Post..-------------------------------------------  [OK]  147.324ms
TESTH - Unit Test with headers..------------------------------  [OK]  144.434ms
TMI - Multiple GETs from Single Domain - Init-----------------  [OK]   26.976ms
TM1 - Multiple GETs from Single Domain - First.---------------  [OK]  273.652ms
TM2 - Multiple GETs from Single Domain - Second.--------------  [OK]   23.795ms
TM3 - Multiple GETs from Single Domain - Third.---------------  [OK]   17.213ms
TM4 - Multiple GETs from Single Domain - Fourth.--------------  [OK]   34.880ms
TM5 - Multiple GETs from Single Domain - Fifth.---------------  [OK]   18.092ms
TM6 - Mulitple GETs from Single Domain - Sixth.---------------  [OK]   74.498ms
TMC - Multiple GETs from Single Domain - Cleanup--------------  [OK]    2.826ms

Ran 1 Routine, 12 Entry Tags
Checked 13 tests, with 0 failures and encountered 0 errors.
```

Sample results from Intersystems Cache:
```
 ------------------------------------ XTHC ------------------------------------
TGET1 - GET via TLS
TGET1^XTHC - GET via TLS - no failure message provided

TGET1^XTHC - GET via TLS - no failure message provided
--------------------------------------------------------------  [FAIL]   35.262ms
TGET2 - GET example.com.--------------------------------------  [OK]   58.338ms
TPOST - Test Post
TPOST^XTHC - Test Post - no failure message provided

TPOST^XTHC - Test Post - no failure message provided
--------------------------------------------------------------  [FAIL]   51.021ms
TESTH - Unit Test with headers
TESTH^XTHC - Unit Test with headers - Status code is supposed to be 200

TESTH^XTHC - Unit Test with headers - Couldn't get the sent header back
--------------------------------------------------------------  [FAIL]   40.615ms
TMI - Multiple GETs from Single Domain - Init-----------------  [OK]    0.091ms
TM1 - Multiple GETs from Single Domain - First.---------------  [OK]  243.239ms
TM2 - Multiple GETs from Single Domain - Second.--------------  [OK]  207.419ms
TM3 - Multiple GETs from Single Domain - Third.---------------  [OK]   96.826ms
TM4 - Multiple GETs from Single Domain - Fourth.--------------  [OK]  120.842ms
TM5 - Multiple GETs from Single Domain - Fifth.---------------  [OK]  193.952ms
TM6 - Mulitple GETs from Single Domain - Sixth.---------------  [OK]  164.627ms
TMC - Multiple GETs from Single Domain - Cleanup--------------  [OK]    0.172ms

Ran 1 Routine, 12 Entry Tags
Checked 13 tests, with 6 failures and encountered 0 errors.
```
## Test Sites
None.

## Future Plans
`$$GETURL^XTHC10` only provides a small amount of functionality compared with
all the capabilities that the libcurl plugin or the Cache HTTP library. Future
development will depend if these extra features are needed for VistA code.
There is also the issue of having two different HTTP APIs in VistA, one here
and one in the XOBW namespace.
