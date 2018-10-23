This release adds RPMS entry points to ZISHGUX and $$MKDIR, $$SIZE, and $$WGETSYNC^%ZISH for use by PSN\*4.0\*513. This release also puts the first nail in the coffin of XUSCNT by decommissioning the counting algorithm and using `$$^%PEEKBYNAME("node_local.ref_cnt","DEFAULT")`. Good riddance! This work will need to continue to purge VistA/RPMS from using XUSCNT. Minor bug fixes in ZOSVGUX.

ZSY has gotten a lot of new features, including an option to examine currently running jobs. More details in the change log below.

## Install Instructions
Minimum GT.M Version: 6.1
Minimum Cache Version: 2014.1

See the list of external interfaces first before installing. 

Normal KIDS install. The multibuild installs XU\*8.0\*10001 as well. It's safe to reinstall. Please see the instructions for XU\*8.0\*10001 for warnings, esp regarding the renaming of Taskman Site Parameters.

## Documentation
See the documentation folder for documentation for the new APIs in %ZISH, RETURN^%ZOSV, and on how to use ^ZSY.

## Internal Interfaces
This is a kernel package and it tests a large amount of published and unpublished APIs supplied by the Kernel.

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
### ZISHGUX
`OPEN`, `DEL`, and `LIST` modified to support RPMS variants, which co-exist with the VistA routines.

`DF` (directory format) is a new RPMS entry point that formats slashes in directories and adds a trailing slash. `DF^%ZISH(.directory-to-format)`.

`SEND` and `SENDTO1` are implemented as NO-OPs. They invoke a perl script which is proprietary to IHS.

`$$MKDIR^%ZISH(directory)` will create a new directory using `mkdir -p` on the Unix OS. Returns 0 for success.

`$$SIZE^%ZISH(directory,file)` will show the size of a file using `stat -c%s` on Linux & Cygwin, `stat -f%z` on Mac, @echo %~zI on Cache/Windows. Returns the file size in bytes.

`$$WGETSYNC^%ZISH(server,remoteDir,localDir,filePattern,port,isTLS)` syncs a remote directory via http or https using `wget`. Not using TLS is strongly discouraged, as there is no way to confirm accurate transmission with just http.

### ZOSVGUX
In `$$ACTJ`, if `^%PEEKBYNAME` exists, call it to get the number of processes connected to the current database; otherwise, run the longer algorithm.

In `$$PROGMODE`, which is a no-op, always return 1 (instead of zero) as ^XTER wants 1 for the ^R functionality. Fixes Issue #10.

### XUSCNT
In `CNT` just quit. `^%PEEKBYNAME` is very fast (200-300ns); we do not need to cache the count of processes.

### ZSY
Extensive changes in ZSY thoughout the routine.

* Reorganize columns
* Don't print devices under each row--rather, guess the principal device and display that in the device column. Guessing is done in order to detect background jobs which are socket listeners.
* Process name is now either the user name from the DUZ of the process, or the process name in ^XUTL. Previously, it was just the process name in ^XUTL.
* New columns print that previously didn't print, but only if the screen size if > 80 columns:
  * OP/READ - Operations/Read: Number of global operations per database block read ((DTA+GET+ORD+ZPR+QRY)/DRD)
  * NTR/NTW - Non-transaction reads, non-transaction writes
  * NR0123 - Non-transaction retries, none, one, two or three
  * #L - Number of locks
  * %LSUCC - % Lock Success. Displayed as fraction if total locks attempted is <100, otherwise, displayed as a percentage
  * %CFAIL - % Critical Section Acquisition Failure. Displayed as a fraction if attempts < 9999, otherwise, displayed as a percentage
* New columns print if the screen size is > 130 columns:
  * Read MB as reported by Linux for the current process
  * Write MB as reported by Linux for the current process
  * Heap memory usage as reported by GTM (`$view("spsize")`)
* `TMMGR^ZSY` filters to show only the taskman processes
* `TMSUB^ZSY` filters to show only the submanager processes (the running tasks)
* ZJOB, EXAMJOB, VIEWJOB, JOBVIEW^ZSY(optional pid) - interactive view of jobs. Stack, locks, devices, breakpoints, and global stats & string pool data are displayed. When at the screen, you can choose one the following options
  * Enter to refresh
  * V for variables
  * I for ISVs
  * K to kill the process
  * L to load variables into your process and quit
  * ^ to go back
  * D to debug (broken)
  * Z to zshow all data for debugging
* $$TRIM uses `$$FUNC^%TRIM` rather than implementing the algorithm.

### ZISHONT
Public entry points `$$MKDIR`, `$$SIZE`, and `$$WGETSYNC` have been added to support PSN*4.0*10001.

### ZOSVONT
Controlled entry point $$RETURN added to support PSN*4.0*10001. Used by ZISHONT. 

# Package Components
```
PACKAGE: XU*8.0*10002     Apr 20, 2018 10:57 am                   PAGE 1
-------------------------------------------------------------------------------
TYPE: SINGLE PACKAGE                               TRACK NATIONALLY: YES
NATIONAL PACKAGE: KERNEL                         ALPHA/BETA TESTING: NO

DESCRIPTION:
Kernel Enhancements for better GT.M support. See full release notes 
accompanying this patch.
 
This is the second release.

ENVIRONMENT CHECK:                               DELETE ENV ROUTINE: 
 PRE-INIT ROUTINE: PRE^XU810002             DELETE PRE-INIT ROUTINE: No
POST-INIT ROUTINE: POST^XU810002           DELETE POST-INIT ROUTINE: No
PRE-TRANSPORT RTN: 

ROUTINE:                                       ACTION:
   XUSCNT                                         SEND TO SITE
   ZISHGUX                                        SEND TO SITE
   ZISHONT                                        SEND TO SITE
   ZOSVGUT1                                       SEND TO SITE
   ZOSVGUT2                                       SEND TO SITE
   ZOSVGUT3                                       SEND TO SITE
   ZOSVGUX                                        SEND TO SITE
   ZOSVONT                                        SEND TO SITE
   ZOSVONUT                                       SEND TO SITE
   ZSY                                            SEND TO SITE
```

# Routine Checksums
```
Routine         Old         New        Patch List
XU810002        n/a       1994975    **10002**
XUSCNT          n/a      10554110    **275,10002**
ZISHGUX         n/a      84538989    **275,306,385,524,10001,10002**
ZISHONT         n/a      103215011   **34,65,84,104,191,306,385,440,518,
                                       524,546,599,10002**
ZOSVGUT1        n/a      130237275   **10001,10002**
ZOSVGUT2        n/a      42570307    **10001,10002**
ZOSVGUT3        n/a      182146595   **10002**
ZOSVGUX         n/a      45533042    **275,425,499,10001,10002**
ZOSVONT         n/a      26568303    **34,94,107,118,136,215,293,284,385,
                                       425,440,499,10002**
ZOSVONUT        n/a      31454787    **10001,10002**
ZSY             n/a      420055711   **349,10001,10002**
```

# Unit Tests
On GT.M: `D ^ZOSVGUT1`. You should get 182 tests with 0 failures and 0 errors.
On Cache: `D ^ZOSVONUT`. You should get 25 tests with 0 failures and 0 errors.

# Future Plans
- Decommission XUSCNT
- Port PR's shasum code to be inherently cross-platform (now you have to change the code a tiny bit)
- Port KMPR package
- Coverage for ZSY has dropped. Need to push it back up again.

