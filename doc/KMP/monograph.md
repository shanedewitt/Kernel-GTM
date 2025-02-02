# CM/VSM Monograph
This document will try to be a user-friendly summary of what the Capacity
Management/VistA System Monitor package does. Many of the technical details on
the specs of the log files and what data is actually collected can be found in
the [output-files-description.md](output-files-description.md) file.

Since the software is complex, a separate
[implementation-guide.md](implementation-guide.md) is provided.

## Introduction
Capacity Management (CM) , Statistical Analysis of Global Growth (SAGG)
Project, and VistA System Monitor (VSM) are the three packages internal to
VistA that perform system performance monitoring and capacity expansion
planning. CM has been around in one form or another since 2000; VSM was
released in 2016. SAGG has been around since we first had records of patches
(1997).

CM originally provided statistics for Resource Usage, HL7 messages, and Cover
Sheet load times. The former two by have superceded by functionality in VSM;
however, the HL7 portion of CM has not been turned off yet as of the time of
this writing. Today, in this work, CM only provides Cover Sheet load times.

SAGG provides these 6 reports:

 - Stats on each Fileman file on the system
 - Stats on each global on the system
 - Stats on each package on the system
 - List of volumes and each volume size
 - Last taskman task
 - Mumps Virtual Machine version

VSM includes five (5) reports:

 - System Load Stats every 15 minutes
 - Storage Stats every 2 weeks (daily for GT.M)
 - Resource Usage by VistA Component every day
 - HL7 Message Transmissing stats every 15 minutes
 - HL7 Message Stats every day

These reports are all saved on the file system under the PRIMARY HFS DIRECTORY
(hereafter known as $HFS) in the sub-directories KMPD (CM), KMPS (SAGG), and
KMPV (VSM). The old logs are deleted after 1 (CM), 56 (SAGG), or 7 days (VSM).

## Summary of Output

| Name     | Files          | Description                                     |
| -------- | -------------- | ----------------------------------------------- |
| CM       | KMPD/cvload    | Coversheet Load Times                           |
| SAGG     | KMPS/\*        | Storage stats by File & Global                  |
| VTCM     | KMPV/VTCM      | System Load Statistics                          |
| VSTM     | KMPV/VSTM      | Database and Disk Used/Free Space               |
| VBEM     | KMPV/VBEM      | Resource usage by VistA Component               |
| VMCM     | KMPV/VBEM      | # of messages going through each Logical Link   |
| VHLM     | KMPV/VHLM      | Statistics on each type of HL7 message          |

## Detailed Discussion of Reports
Please note that a detailed list of fields for each report can be found in
[output-files-description.md](output-files-description.md) file.

### CM: Cover Sheet Load Times

File: $HFS/KMPD/cvload-{date}.dat

This report gives you the most important metric in all of the system (possibly
excepting Storage Stats which you may need to know that you won't run out of
disk space): How long does it take to load a cover sheet in CPRS. The cover
sheet in CPRS runs about 3 direct RPCs, and 3 taskman tasks. Getting a total
number gives you an excellent idea on how well your system is performing.

### SAGG: Fileman Files

File: $HFS/KMPS/files-{date}.dat

This report gives you the # of entries for each file, last IEN, and file
version. Graph this to see if a file's growth is faster than expected.

### SAGG: Global Files

File: $HFS/KMPS/globals-{date}.dat

This report gives you the size of each global in blocks and bytes, plus some
information on packing and journaling. On GT.M/YottaDB, the journal file is
probed to see how many sets and kills are happening on each global. Graphing
global sizes and rates of sets and kills will show where are your problem
areas.

### SAGG: Packages

File: $HFS/KMPS/packages-{date}.dat

This report gives you a list of currently installed packages and their version.
This report is of limited utility.

### SAGG: Taskman

File: $HFS/KMPS/taskman-{date}.dat

This report only has one field, the last task number. It is of limited utility.

### SAGG: Version

File: $HFS/KMPS/version-{date}.dat

This report only has one field, the version of the Mumps Virtual Machine. It is
of limited utility.

### SAGG: Volumes

File: $HFS/KMPS/volumes-{date}.dat

This report shows the volumes. It has limited data; use the VSM/Storage
Monitor report instead.

### VSM: Timed Collection Monitor (Vital Stats)

File: $HFS/KMPV/VTCM-{date}.dat

This report gives you a good idea about system load. It tells you how often the
database is accessed, how heavily the disk is being read/written to, and how
well the cache is being used. It also gives you some data regarding resource
contention in the database at the time of sampling. If the coversheet report
indicates a problem, this report may be a good place to look to see what parts
of the system were possibly causing a problem.

### VSM: Volume Storage Statistics

File: $HFS/KMPV/VSTM-{date}.dat

This report gives you the amount of free space on the current database, how
much it is allowed to expand, and the current amount free space on the
partition the disk is on.

### VBEM: VistA Components Execution Statistics (formerly RUM)

File: $HFS/KMPV/VBEM-{date}.dat

This used to be known as the Resource Usage Manager, and it gives you overall
stats by VistA components. You can use this to find which component is taking
too long to execute is that is being run too often. You get data such as number
of times run, CPU Time, number of global references, and real elapsed time.

### VMCM: Vista Message Count Monitor

File: $HFS/KMPV/VMCM-{date}.dat

This continously running process checks the traffic on each HL7 Logical Link
and prints out the number of incoming and outgoing messages on each logical
link.

### VHLM: VistA HL7 Monitor

File: $HFS/KMPV/VHLM-{date}.dat

Unlike VMCM, this does not give you statistics at the link level, but rather
at the level of the HL7 message. You get data such as Type of Message,
Subscriber, Event Driver, how amny messages, and how big the messages were in
aggregaqte. You also get data on aggregate transmission and response times by
message type.

## Reference Tables

### Output Files and Links to Samples

| Output Type   | Frequency     | Output File                   | Retention days | Sample Data                                      |
| -----------   | ------------- | ----------------------------  | -------------- | ------------------------------------------------ |
| KMPD          | Daily         | $HFS/KMPD/cvload-{date}.dat   | 1  | [Sample](KMPD/cvload-20200123.dat) |
| SAGG          | 2 weeks       | $HFS/KMPS/files-{date}.dat    | 56 | [Sample](KMPS/files-20200122.dat) |
| SAGG          | 2 weeks       | $HFS/KMPS/globals-{date}.dat  | 56 | [Cache](KMPS/globals-cache.dat) \| [GT.M](KMPS/globals-gtm.dat) |
| SAGG          | 2 weeks       | $HFS/KMPS/packages-{date}.dat | 56 | [Sample](KMPS/packages-20200122.dat) |
| SAGG          | 2 weeks       | $HFS/KMPS/taskman-{date}.dat  | 56 | [Sample](KMPS/taskman-20200122.dat) |
| SAGG          | 2 weeks       | $HFS/KMPS/version-{date}.dat  | 56 | [Cache](KMPS/version-cache.dat) \| [GT.M](KMPS/version-gtm.dat) |
| SAGG          | 2 weeks       | $HFS/KMPS/volumes-{date}.dat  | 56 | [Cache](KMPS/volumes-cache.dat) \| [GT.M](KMPS/volumes-gtm.dat) |
| VTCM          | Persist q15m  | $HFS/KMPV/VTCM-{date}.dat     | 7  | [Cache](KMPV/VTCM-cache.dat) \| [GT.M](KMPV/VTCM-gtm.dat) |
| VSTM          | Daily         | $HFS/KMPV/VSTM-{date}.dat     | 7  | [Cache](KMPV/VSTM-cache.dat) \| [GT.M](KMPV/VSTM-gtm.dat) |
| VBEM          | Daily         | $HFS/KMPV/VBEM-{date}.dat     | 7  | [Cache](KMPV/VBEM-cache.dat) \| [GT.M](KMPV/VBEM-gtm.dat) |
| VMCM          | Persist q15m  | $HFS/KMPV/VMCM-{date}.dat     | 7  | [Sample](KMPV/VMCM-20200123.dat) |
| VHLM          | Daily         | $HFS/KMPV/VHLM-{date}.dat     | 7  | [Sample](KMPV/VHLM-20200123.dat) |

### Master List of Tasks

| Task/Cron Job Name          | Output generated by which? |
| --------------------------- | -------------------------- |
| KMPS SAGG REPORT            | Taskman                    |
| KMPD BACKGROUND DRIVER      | Taskman                    |
| D RUN^KMPVRUN               | Cron                       |
| → KMPVVTCM                  | Cron                       |
| → KMPVVSTM                  | Cron                       |
| → KMPVBETR                  | Taskman                    |
| → KMPVVMCM                  | Cron                       |
| → KMPVVHLM                  | Taskman                    |

### Jobs: Persistent or Not, TM/Cron?

| Job  | When          | TM/Cron | Periodic/Persistent  | Polling |
| ---- | -------       | ------- | -------------------  | ------- |
| SAGG | q2weeks       | TM      | Periodic             | No      |
| CM   | Daily         | TM      | Periodic             | No      |
| VTCM | Daily@0005    | Cron    | Persistent           | q15min  |
| VSTM | Daily@0015\*  | Cron    | Periodic             | No      |
| VBEM | Daily@0115    | TM      | Periodic             | No      |
| VMCM | Daily@0005    | Cron    | Persistent           | q15min  |
| VHLM | Daily@0200    | TM      | Periodic             | No      |

\* The VSTM job does run daily, but not actually run to completion on Cache
except on the 1st or 15th of the month. On GT.M/YottaDB, it runs daily.

### Taskman Job Name and Routines

| Taskman Job Name            | Routine       | Active Outside VA?\* |
| --------------------------- | ------------- | ------------------ |
| KMPS SAGG REPORT            | KMPSGE        | Yes                |
| KMPD BACKGROUND DRIVER      | KMPDBD01      | Yes                |
| KMPV VTCM DATA TRANSMISSION | SEND^KMPVVTCM | No                 |
| KMPV VSTM DATA TRANSMISSION | SEND^KMPVVSTM | No                 |
| KMPV VBEM DATA TRANSMISSION | EN^KMPVBETR   | Yes                |
| KMPV VMCM DATA TRANSMISSION | SEND^KMPVVMCM | No                 |
| KMPV VHLM DATA TRANSMISSION | SEND^KMPVVHLM | Yes                |

\* If something is active, then the taskman job creates the log files. If not,
then the running the task does nothing outside the VA.
