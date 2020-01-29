# CM/VSM Monograph
This document will try to be a user-friendly summary of what the Capacity
Management/VistA System Monitor package does. Many of the technical details on
what data is actually collected can be found in the
[output-files-description.md](output-files-description.md) file.

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

 - Vital Stats every 15 minutes
 - Storage Stats every 2 weeks (daily for GT.M)
 - Resource Usage by VistA Component every day
 - HL7 Message Transmissing stats every 15 minutes
 - HL7 Message Stats every day

These reports are all saved on the file system under the PRIMARY HFS DIRECTORY
(hereafter known as $HFS) in the sub-directories KMPD (CM), KMPS (SAGG), and
KMPV (VSM). The old logs are deleted after 1 (CM), 56 (SAGG), or 7 days (VSM).

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

This report is like taking vital signs on a human. It tells you how often the
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
