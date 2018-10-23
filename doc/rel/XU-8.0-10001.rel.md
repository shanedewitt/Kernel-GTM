**Better GT.M support by VistA when running on GT.M systems on Linux, macOS or Cygwin x32.**

_IMPORTANT: THIS PATCH WILL CHANGE YOUR BOX NAME. IT WILL STOP TASKMAN, RENAME THE LAST ENTRY IN 14.7, AND THEN START IT AGAIN. IF YOU HAVE MORE THAN ONE ENTRY, YOU WILL NEED TO CHANGE IT MANUALLY. Box name is now obtained from GT.M environment variable gtm_sysid._

Before you install, you need to know that GT.M uses the following *nix shell utilities: `lsof`, `ps`, `awk` (Cygwin only), `openssl`, `shasum`, `xxd`, `base64`, `dig`, `ipcs` (Linux only), `rm`, `mv`, `wc`, `grep` (Cygwin only), `stat` (Unit Tests only).

Pre-Install does the following: Stop Taskman

Post-Install does the following: Rename % routines, rename ZUGTM to ZU, rename Taskman Site Parameter (14.7), and start Taskman.

There are no end-user facing changes with the exception of ^ZSY: It doesn't print closed or principal devices anymore.

Fixes issues #1, #2, #5, #8.

Cygwin x32 specific notes: Most utilities that look for current processes grab the ones accessing the current database; with Cygwin, since we don't have programs that can do that, we just get every M process on the system.

It's provided in the form of a KIDS build for existing GT.M systems or a zip files of .m files for new installations that can't use KIDS yet.

Here's a transcript of a KIDS install, so that you would know what to expect. The KIDS fie was saved in the /tmp/ directory which was defined as the `PRIMARY HFS DIRECTORY`.
```
[sam@arlington-38-68-237-107 tmp]$ mumps -dir

VXVISTA15.0>S DUZ=1  

VXVISTA15.0>D ^XUP

Setting up programmer environment
This is a TEST account.

Terminal Type set to: C-VT220

You have 59 new messages.
Select OPTION NAME: 
VXVISTA15.0>D ^XPDIL,^XPDI

Enter a Host File: XU_8-0_10001.KID

KIDS Distribution saved on Oct 30, 2017@20:18:25
Comment: XU*8.0*10001 - T11 - Final Version

This Distribution contains Transport Globals for the following Package(s):
   XU*8.0*10001
Distribution OK!

Want to Continue with Load? YES// 
Loading Distribution...

   XU*8.0*10001
Use INSTALL NAME: XU*8.0*10001 to install this Distribution.

Select INSTALL NAME:    XU*8.0*10001     Loaded from Distribution    10/30/17@17
:02:30
     => XU*8.0*10001 - T11 - Final Version  ;Created on Oct 30, 2017@20:18:25

This Distribution was loaded on Oct 30, 2017@17:02:30 with header of 
   XU*8.0*10001 - T11 - Final Version  ;Created on Oct 30, 2017@20:18:25
   It consisted of the following Install(s):
   XU*8.0*10001
Checking Install for Package XU*8.0*10001

Install Questions for XU*8.0*10001



Want KIDS to INHIBIT LOGONs during the install? NO// 
Want to DISABLE Scheduled Options, Menu Options, and Protocols? NO// 

Enter the Device you want to print the Install messages.
You can queue the install by enter a 'Q' at the device prompt.
Enter a '^' to abort the install.

DEVICE: HOME// ;P-OTHER;  Virtual Terminal

 
 Install Started for XU*8.0*10001 : 
               Oct 30, 2017@17:02:40
 
Build Distribution Date: Oct 30, 2017
 
 Installing Routines:..................
               Oct 30, 2017@17:02:40
 
 Running Pre-Install Routine: PRE^XU810001.
Stopping Taskman...
Waiting around until Taskman reports it's stopped..
 
 Running Post-Install Routine: POST^XU810001.
 
Rename the routines in Patch 10001

ZTMGRSET Version 8.0 Patch level **34,36,69,94,121,127,136,191,275,355,446,584,10001**
HELLO! I exist to assist you in correctly initializing the current account.
I think you are using GT.M (Unix)
 
I will now rename a group of routines specific to your operating system.
Routine:  ZOSVGUX Loaded, Saved as    %ZOSV

Routine:  ZIS4GTM
Routine:  ZISFGTM
Routine:  ZISHGUX Loaded, Saved as    %ZISH
Routine:  XUCIGTM
Routine: ZOSV2GTM Loaded, Saved as   %ZOSV2
Routine:  ZISTCPS Loaded, Saved as %ZISTCPS

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
Routine:     ZTM6 Loaded, Saved as    %ZTM6
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
 
ALL DONE
Renaming ZUGTM...
Starting Taskman...
 
 Updating Routine file......
 
 Updating KIDS files.......
 
 XU*8.0*10001 Installed. 
               Oct 30, 2017@17:02:42
 
 Not a VA primary domain
 
 NO Install Message sent 
```

# Developer Notes
The build suppresses compilation warnings by default. If you wish to see compilation warnings when developing or installing KIDS builds when routines are saved using ^%ZOSF("SAVE"), set ^%ZOSF("COMPILEWARNING") to 1.

# Change Log

PLEASE NOTE: UNLESS OTHERWISE SPECIFIED, ALL NEW FEATURES REQUIRE GT.M 6.0-000 OR HIGHER! GT.M 6.0-000 was released on 27 October 2014. No bug fixes will be provided for those running an older version of GT.M. Authors are noted in parentheses.

## XLFIPV (C Edwards)

GT.M IPv6 Support (mainly checks GT.M version and env var gtm_ipv4_only).
Previously, only Cache. GT.M added IPv6 support in version 6.0-003.

## XLFNSLK (C Edwards)

GT.M IPv6 Lookup implmementation using `dig`. Previously, only Cache.

## XQ82 (S Habiel)

Replacement of M95 ^$JOB with $ZGETJPI(%J,"ISPROCALIVE) for GT.M. Cache still
checks $D(^$JOB(%J)). Previously, the ^$J code wasn't even checked for GT.M
as it was recognized that GT.M does not have it.

## XUSHSH (S Habiel)

Implementation of redacted code, but only for GT.M. I don't have access
to the Cache source code from the VA. Previously, all entry points were empty.
- SHAHASH implemented for GT.M using `shasum`. Conversion to base64 done using
  `xxd` to get the binary from the hex value and then `base64` to encode it.
- B64ENCD & B64DECD implemented using `base64`
- RSAENCR & RSADECR implemented using `openssl pkeyutl`
- AESENCR & AESDECR implemented using `openssl enc -e/-d -aes-256-cbc`

## ZISHGUX (%ZISH) (previously ZISHGTM) (S Habiel)

Many changes throughout routine.

OPEN re-implemented:
- Default is now STREAM:NOWRAP, not VARIABLE:WRAP, which was the previous default. (Actually, it's the GT.M default; and thus inherited.)
- GT.M does not support WIDTH as a open time parameter. Only with Use. WIDTH uses replaced with RECORDSIZE.
- Reads with Width specified that would normally be STREAM:NOWRAP are changed to VARIABLE:NOWRAP:RECORDSIZE=#.
- Binary reads are still FIXED:NOWRAP:RECORDSIZE=#. That has not changed, 
  except for removing the hardcoded recordsize if width is specified.
  If WIDTH isn't specified, then the default RECORDSIZE for binary reads will be
  512 bytes.

$$DEL1 entry point added. Previously it only existed in ZISHONT. Used by KIDS.

$$MV uses a pipe rather than ZSY, which was used previously.

CD PEP/SR added.

$$PWD now works. It previously never worked.

$$DEFDIR now will crash if given a bad directory. Previously, it returned '/'
when given a bad directory, which was a bad bug, as that means the root
directory. We can't return an empty string, because that will be interpreted
by GT.M as no directory, and therefore, a write/read will happen in the current
directory, which is not what a programmer will want. Crashing is the best option
here.

$$QS^DDBRAP and $$QL^DDBRAP (!!!) replaced with $QS and $QL

$$READNXT will not apply global overflows during reads unless the read line
overflows the global's maximum record size. Previously, overflows happened on
any line longer than 255 character. Record size is determined using $VIEW on
the specific global following by a call to ^%DSEWRAP.

$$GTF had a bug where it stopped early if a global wasn't strictly following
an ascending cardinal numeric orders (1, 2, 3, 4). This is now fixed. I have
some concerns that the new algorithm may be slower, but this remains to be seen.

## ZISTCPS (%ZISTCP) (S Habiel)

Implementation of a Multi-process Server in GT.M. Requires GT.M 6.1.

## ZOSV2GTM (%ZOSV2) (S Habiel, KS Bhaskar)

SAVE:
- Open parameters are now NEWVERSION:NOWRAP:STREAM; previously they were
  newversion:noreadonly:blocksize=2048:recordsize=2044.
- No tabs are added if they are not in the original source code. Previously,
  tabs were always added, in violation of all M standards.
- ZLINK suppresses compilation errors now. Previously, it didn't.

DEL: Completely rewritten to recursively delete all routines with the specified
name from all GT.M directories. Object files are deleted too; and the current
process is given a fake empty routine in order to evict the one in the current
process's image. Previous version was much more primitive.

LOAD and LOAD2: Avoid using $INCREMENT as using it with globals results in
unpredictable subscripts upon multiple invocation. Previously used $INCREMENT.

TEST: Reimplemented to use SILENT^%RSEL(RN). Previously used a different 
algorithm that doesn't account for multiple directories.

## ZOSVGUX (%ZOSV) (C Edwards, KS Bhaskar, S Habiel)

$$ACTJ on Linux uses ipcs -mi on the output of mupip ftok to return the number
of processes attached to the shared memory segment accessed by the default
segment of the database. On macOS, since ipcs doesn't support similar
functionality, it uses lsof -t to count the number of processes accessing the
default segment. Cygwin uses ps due to the lack of any other methods.
The result is cached for one hour. In that hour, we rely on
VistA's XUSCNT mechanism to keep track of the number of processes. Previously;
ZSYSTEM with "ps cef -C mumps|wc" onto a file on disk, which was then read back;
was used.

$$RTNDIR is very reliable now. Previously, a whole host of conditions can make
it fail.

$$TEMP has not been updated with a Kernel Patch released a few years ago that
changed the "DEV" node in KSP (8989.3) to be 2 pieced. Now this is fixed.

JOBPAR reads from /proc/$J/comm rather than use ps. NB: Won't work on macOS.

DOLRO was optimized by removing the $DATA check, which is not necessary when
the system just told you that a local variable exists. Another faster algorithm,
which has not been extensively tested, is in the comments after DOLRO. Experiments
show that the difference between the two algorithms is about 6ms.

GETENV %HOST (Box Name) is now obtained from the environment variable gtm_sysid.
Previously, it got the hostname from the operating system. This caused several
problems: many machines change their hostnames dynamically; and making a 
hostname call is expensive for this frequently called API.

$$VERSION API was fixed to correctly return the version number if 0 or nothing
is passed in, and the operating system if 1 is passed in. Like this:

```
GTM>W $$VERSION^%ZOSV(0)
6.3-000A
GTM>W $$VERSION^%ZOSV(1)
Linux x86_64
```

T0, T1, ZHDIF are implemented if you have GT.M greater than v6.2 or you have
the GT.M POSIX plug-in installed. To be honest, I never tested that logic with
the plugin.

DEVOPN was modified to remove CLOSED devices, which ZSHOW "D" keeps.

$$RETURN is now a public API, and it uses a pipe rather than ZSY and then a
read back. A crucial bug that hit multiple users, where the device was closed,
did not return control to the last opened device in IO, resulting in some CPRS
crashes when code won't write to the NULL device anymore. $$RETURN also allows
you to ask whether the command succeeded, rather than what the output is, by
passing in a second parameter: Passing this in, you will get the output of
$ZCLOSE. $ZCLOSE was added to GT.M 6.1. The $ZCLOSE is not guarded by a version
check, since I am hoping that people who use it will specify the minimum
version of their software. $$RETURN is called by %ZISH, XLFNSLK, and XUSHSH.

STRIPCR has been removed. It was not a public API, and was not used in my time
in the VistA community--which prefers the Utility dos2unix. And in any case,
GT.M will support CR's in routines in the next release.

## ZSY & ZUGTM (ZU) (KS Bhaskar, S Habiel)

ZSY was extensively modified:
- New JOBEXAM section called by ZU; in order to make maintenance of the
  code easier.
- All VMS entry points removed.
- Support for $ZMODE (Interactive process vs Background Process)
- CLOSED devices, $PRINCIPAL, and the ps command are not shown as open devices
  in the process listing. Previously all devices showed up.
- Removal of Paging. I am sure most people today don't use dumb terminal
  emulators.
- Now, only processes accessing the current database are shown; rather than
  every single M process on the system in which we are running.
- Interrupt is done using signal 10 (Linux) or signal 30 (macOS, Cygwin) against all
  processes reported by lsof to be accessing the current default segment of the
  database. Previously, all mumps processes were interrupted. Cygwin interrupts all
  processes since we don't have the ability to grab the ones that are accessing the
  current database.
- Calls to ps with pids to get other process' information are chunked together in order
  to provide speed when calling ps. The chucks are not larger than 970 characters
  each, in order to accomodate the maximum GT.M pipe length of 1023.
- Interrupts were done while collecting and printing the data. They have now
  been moved to INTRPT(%J) and INTRPTALL(.procs). The latter returns to you
  the list of processes interrupted, and as such is killing two birds with one
  stone.
- HALTALL is a new entry point that gracefully exits VistA processes by calling
  a cleanup routine in XUSCLEAN and then calling HALT^ZU.
- HALTONE is a new entry point that does the same thing but just for one job.

ZUGTM: JOBEXAM calls NTRUPT^ZSY (Lloyd Milligan's ZSY), or if not, tries 
JOBEXAM^ZSY. If neither of these are present, it will run a default interrupt.

## ZTLOAD1 (C Edwards)

TSTART and TCOMMIT do not comply with the M standard; and have been removed
as GT.M, which implements the M standard in Transaction Processing, did not
accept them.

## ZTM6 (C Edwards)

Same as ZTLOAD1.

## ZTMGRSET (C Edwards and S Habiel)

Maximum patch number changed from 999 to 9999999.

%ZISH routine is now ZISHGUX; previously it was ZISHGTM.

COPY uses OPEN, ZPRINT, and CLOSE, rather than the "cp" command. ZLINK in COPY
suppresses compilation errors. ZLINK's effect on $ZSOURCE is undone so that
your previous $ZSOURCE stays as it is.

$$R fixed for GT.M.

# Unit Tests (C Edwards and S Habiel)

EVERY SINGLE CHANGE HAS A UNIT TEST, except ZTM6, which deals with load
balancers, which GT.M cannot use.

Routines are ZOSVGUT1 and ZOSVGUT2. D ^ZOSVGUT1 is the entry point. Coverage calculations
can be done by running COV^ZOSVGUT1. Note that it uses a modified M-Unit that
can accommodate a passed by reference list of routines.

See separate document for Unit Tests.

