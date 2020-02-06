# Implementation Guide
The Capacity Management/Statistical Analysis of Global Growth/VistA System
Monitor package contains 7 monitors. Before turning on a specific monitor (and
this document tells you how to do that), there are a few considerations:
 
 - All data monitored is stored in ^KMPTMP. Make sure that that the global is
   not journalled and that you have enough free space in your unjournalled data
   region to handle that global. It shouldn't need more than 1 GB as data is
   regularly purged.
 - Much of the monitoring code is new. That means crashes and bugs are likely.
 - You need to decide what to do with the output. If you don't plan to use the
   output, there is no reason to implement the package.
 - All data is written your the default directory designated by $$DEFDIR^%ZISH.
   Ensure that your default directory is writable and has enough space. You
   shouldn't need more than 1 GB, as data is regularly purged. In the following
   documentation, this directory is referred to as $HFS.

Detailed technical specs on each of the produced files can be found in 
[output-files-description.md](output-files-description.md). In addition, there
are links to samples there.

Please get in contact with me (sam dot habiel at gmail dit com) if you plan to
implement.

## Preparatory Steps
 - The package logs files only if the Agency Code isn't VA. To ensure proper
   system operation outside of the VA, make sure that the Agency Code in the
   KERNEL SYSTEM PARAMETERS file is not set to "VA". If you are testing on
   a FOIA VistA copy, that is a change you will need to make.
 - Allocate key KMPVOPS in order to access the VistA System Monitoring menu.
 - Ensure access to menu "Capacity Planning [XUCM MAIN]", normally accessed
   from EVE.

## The Monitors
There are seven monitors that need to be turned on individually:

 - Cover sheet load times (KMPD)
 - Global Growth Data (KMPS or SAGG)
 - System Load (KMPV/VTCM)
 - Disk Space Monitoring (KMPV/VSTM)
 - VistA Component Monitoring (KMPV/VBEM)
 - HL7 Link Traffic Monitoring (KMPV/VMCM)
 - HL7 Message Level Aggregate Statistics (KMPV/VHLM)

You should turn each of these on individually, and only the ones you need.

Three of the VistA System Monitors (VTCM, VSTM, and VMCM) are started by
a process that is outside of VistA. On Cache, the task is scheduled
automatically at 5 minutes past midnight by calling `D KMPVTSK^KMPVCBG`. On
GT.M/YottaDB, you need to set-up a cron job that sources your environment
variables and then calls `mumps -run RUN^KMPVRUN`.

### Cover Sheet Load Times (KMPD)
This produces the file `$HFS/KMPD/cvload-{date}.dat`.

Cover Sheet load times give you a good idea about the system's performance for
end users.

To produce this log file, you need to turn on timing collection and then
schedule a task.

Timing collection can be turned on using Capacity Planning > TLS > SST
Start/Stop Timing Collection [KMPD TMG START/STOP]. Once you do that, data will
be collected in ^KMPTMP regarding cover sheet load times.

To export data, schedule [KMPD BACKGROUND DRIVER] to run nightly using Taskman
utilities.

Both collection and output are very simple operations that should take no cpu
power to process.

### Global Growth Data (SAGG)
This produces the following files under $HFS/KMPS:

 - files-{date}.dat
 - globals-{date}.dat
 - packages-{date}.dat
 - taskman-{date}.dat
 - version-{date}.dat
 - volumes-{date}.dat

SAGG data produces a snapshot of the sizes of the current files and globals
plus global activity in order to give you an idea of which ones of your
globals/files are growing the fastest; which ones need to be repacked in the
database, and which ones have too much journal activity.

To produce these files, simply schedule [KMPS SAGG REPORT] to run every
2 weeks. You make choose to run it nightly if you wish.

The job is intensive and may take up to an hour to run, but I would like
reports on how long it really takes to run on a heavily trafficked VistA
database at night. On GT.M/YottaDB, in addition, the journal file is extracted
in the same folder as the journal file for counting the number of sets and
kills for each global.

### System Load (VTCM)
This produces the log file $HFS/KMPV/VTCM-{date}.dat. This file is continously
updated every 15 minutes.

The data produced give you an idea of how heavily the VistA database is being
used right now. It is a good idea to pair this data with cover sheet load times
to investigate performance problems.

Turning this one requires two steps:
 
 - Capacity Planning > VSM Management (protected by the key KMPVOPS, which you
   should have already allocated to yourself earlier in the document).
   A Listman form appears. Type STRT for Start Monitor. Choose VTCM. If you are
   on a test system, it may refuse to start the monitor until you use EDIT and
   set ALLOW TEST SYSTEM to true.
 - Cron job that runs nightly. This actually starts the continously running
   monitor.

The data collection every 15 minutes should be light on the system. It would be
ironic if it wasn't.

### Disk Space Monitoring (VSTM)
This produces the log file $HFS/KMPV/VSTM-{date}.dat. The file is produced
daily for GT.M/YottaDB; or on the 15th and the last day of the month for Cache.

The file give you storage capacity data & expansion configuration for your
database file plus disk partition free space.

Turning this one requires two steps:

 - Capacity Planning > VSM Management (protected by the key KMPVOPS, which you
   should have already allocated to yourself earlier in the document).
   A Listman form appears. Type STRT for Start Monitor. Choose VSTM. If you are
   on a test system, it may refuse to start the monitor until you use EDIT and
   set ALLOW TEST SYSTEM to true.
 - Cron job that runs nightly. The output file is produced when it runs. Unlike
   VTCM and VMCM, it is not continously updated.

### VistA Components Monitoring (VBEM)
This produces the log file $HFS/KMPV/VBEM-{date}.dat. 

The file consists of aggregated data by VistA component (Option, RPC, HL7).The
data has # of times invoked, cpu time spent, and actual time elapsed. This is
useful data in combination with other reports to narrow down the cause of
performance problems in a VistA system.

Turning this one requires a single step:

 - Capacity Planning > VSM Management (protected by the key KMPVOPS, which you
   should have already allocated to yourself earlier in the document).
   A Listman form appears. Type STRT for Start Monitor. Choose VBEM. If you are
   on a test system, it may refuse to start the monitor until you use EDIT and
   set ALLOW TEST SYSTEM to true.


### HL7 Link Traffic Monitor (VMCM)
This produces the log file $HFS/KMPV/VMCM-{date}.dat. 

This file gives you the number of pending and processed HL7 messages for
incoming and outgoing queues for each logical link every 15 minutes.

Turning this one requires two steps:

 - Capacity Planning > VSM Management (protected by the key KMPVOPS, which you
   should have already allocated to yourself earlier in the document).
   A Listman form appears. Type STRT for Start Monitor. Choose VMCM. If you are
   on a test system, it may refuse to start the monitor until you use EDIT and
   set ALLOW TEST SYSTEM to true.
 - Cron job that runs nightly. Output file updated every 15 minutes as it is
   a continously running monitor.

### HL7 Message Level Aggregate Statistics
This produces the log file $HFS/KMPV/VHLM-{date}.dat. 

This file give you aggregate statistics grouped by message type, event driver,
and destination. The aggregated statistics are:

 - # of messages
 - Total length of messages
 - # of HL7 events (as there can be multiple events per message)
 - Total transmission time
 - Total CA time
 - Total AA time

Turning this on requires a single step:

 - Capacity Planning > VSM Management (protected by the key KMPVOPS, which you
   should have already allocated to yourself earlier in the document).
   A Listman form appears. Type STRT for Start Monitor. Choose VHLM. If you are
   on a test system, it may refuse to start the monitor until you use EDIT and
   set ALLOW TEST SYSTEM to true.


