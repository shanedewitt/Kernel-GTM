## Introduction
The Capacity Management/VistA System Monitor Community Edition produces output
in these files as follows and with the following frequency:

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

All files are ^ delimited.

$HFS = Output of $$DEFDIR^%ZISH, the primary HFS directory in your Kernel
System Parameters. VTCM and VMCM are persistent files that are continoustly
being written to during the duration of the day.

In the following data, there are some abbreviations used:

 - : means traverse through a global from 0 to " ", exclusive.
 - pN means ^ piece numbered N
 - NpN means N node ^ piece numbered N.

So, for example, ^DIC(5,:) 0p2 means 2nd ^ piece of zero nodes.

### KMPD - $HFS/KMPD/cvload-{date}.dat
Cover Sheet Load Times

Output once a day using taskman process KMPD BACKGROUND DRIVER.

| Column            | How Extracted? | Comments |
| ----------------- | -------------- | -------- |
| Start Time        | $HOROLOG       |          |
| FG Delta          | $HOROLOG       | Foreground Load Time for Cover Sheet |
| BG Delta          | $HOROLOG       | Taskman tasks Load Time for Cover Sheet |
| Total Delta       | FG + BG        |          |
| Client DUZ        | DUZ variable   |          |
| Client Name       | TCPConnect XWB Message |  |
| KMPTMP Subscript Key |             | Ignore this one |
| Application Title | TCPConnect XWB Message |  |
| IP                | TCPConnect XWB Message |  |
| DFN               | DFN variable   |          |

### SAGG - $HFS/KMPS/files-{date}.dat
File Sizing

Output every 2 weeks using taskman process KMPS SAGG REPORT.

| Column       | How         |
| ------------ | ----------- |
| File Name    | ^DIC(:,0) p1 |
| # of Entires | @^DIC(:,0,"GL") 0p4 |
| Global       | ^DIC(:,0,"GL") |
| File Version | ^DD(:,0,"VR") |
| Last IEN     | @^DIC(:,0,"GL") 0p3 |

### SAGG - $HFS/KMPS/globals-{date}.dat
Global Sizing 

Output every 2 weeks using taskman process KMPS SAGG REPORT.

The output here differs if on GT.M or Cache.

#### GT.M

| Column        | How         |
| ------------- | ----------- |
| Global Name   | $Order on ^ |
| Blocks        | mupip size  |
| Block Size    | $$^%PEEKBYNAME("sgmnt_data.blk_size") |
| Bytes         | Blocks * Block Size |
| Adjacency     | mupip size  |
| Region        | $view("region") |
| Access Method | $view("gvaccess_method") |
| Journaling State | $view("jnlactive") |
| Journal File  | $view("jnlfile") |
| Journal Sets  | mupip journal -extract={} -forward -detail {}, search for sets  |
| Journal Kills | mupip journal -extract={} -forward -detail {}, search for kills |

#### Cache
Cache Size data includes ALL mounted databases, not just VistA. That includes
for example the docbook database.

| Column         | How         |
| -------------  | ----------- |
| Global Name    | $$GetDirGlobals^%SYS.DATABASE |
| BLOCKS         | $$CheckGlobalIntegrity^%SYS.DATABASE |
| POINTER BLOCKS | $$CheckGlobalIntegrity^%SYS.DATABASE |
| TOTAL BYTES    | $$CheckGlobalIntegrity^%SYS.DATABASE |
| POINTER BYTES  | $$CheckGlobalIntegrity^%SYS.DATABASE |
| BIG BLOCKS     | $$CheckGlobalIntegrity^%SYS.DATABASE |
| BIG BYTES      | $$CheckGlobalIntegrity^%SYS.DATABASE |
| BIG STRINGS    | $$CheckGlobalIntegrity^%SYS.DATABASE |
| DATA SIZE      | $$CheckGlobalIntegrity^%SYS.DATABASE |
| TOP POINTER BLOCK   | $$CheckGlobalIntegrity^%SYS.DATABASE, DecomposeStatus^%SYS.DATABASE |
| TOP POINTER EFF%   | $$CheckGlobalIntegrity^%SYS.DATABASE, DecomposeStatus^%SYS.DATABASE |
| BOTTOM POINTER BLOCK | $$CheckGlobalIntegrity^%SYS.DATABASE, DecomposeStatus^%SYS.DATABASE |
| BOTTOM POINTER EFF% | $$CheckGlobalIntegrity^%SYS.DATABASE, DecomposeStatus^%SYS.DATABASE |
| POINTER DATA | $$CheckGlobalIntegrity^%SYS.DATABASE, DecomposeStatus^%SYS.DATABASE |
| DATA BLOCK | $$CheckGlobalIntegrity^%SYS.DATABASE, DecomposeStatus^%SYS.DATABASE |
| DATA EFF% | $$CheckGlobalIntegrity^%SYS.DATABASE, DecomposeStatus^%SYS.DATABASE |
| BIG STRINGS BLOCK | $$CheckGlobalIntegrity^%SYS.DATABASE, DecomposeStatus^%SYS.DATABASE |
| BIG STRINGS EFF% | $$CheckGlobalIntegrity^%SYS.DATABASE, DecomposeStatus^%SYS.DATABASE |

### SAGG - $HFS/KMPS/packages-{date}.dat
Packages, Versions, and Installs

Output every 2 weeks using taskman process KMPS SAGG REPORT.

| Column          | How         |
| -------------   | ----------- |
| Package Name    | ^DIC(9.4,:,0) p1 |
| Namespace       | ^DIC(9.4,:,0) p2 |
| Current Version | ^DIC(9.4,:,"VERSION") |
| Install Version | Last entry in ^DIC(9.4,:,22,:,0) p4 |
| Install Date    | Last entry in ^DIC(9.4,:,22,:,0) p3 |

### SAGG - $HFS/KMPS/taskman-{date}.dat
Taskman: Last Task Number

Output every 2 weeks using taskman process KMPS SAGG REPORT.

| Column           | How         |
| -------------    | ----------- |
| Last Task Number | ^%ZTSK(-1)  |

### SAGG - $HFS/KMPS/version-{date}.dat
M Version

Output every 2 weeks using taskman process KMPS SAGG REPORT.

| Column           | How         |
| -------------    | ----------- |
| System Version   | $ZV         |
| Windows Version  | $ZU(100) [Cache Windows Only] |

### SAGG - $HFS/KMPS/volumes-{date}.dat
Volume Sizes

Output every 2 weeks using taskman process KMPS SAGG REPORT.

| Column           | Cache       | GTM |
| -------------    | ----------- | --- |
| Volume           | ^["%SYS"]SYS("UCI",:) | $view("gvnext",:) |
| Block Count      | ##class(SYS.Database).%OpenId(Volume).Blocks | $view("totalsblocks") |

### VTCM - $HFS/KMPV/VTCM-{date}.dat
Vital Stats every 15 minutes

Continous output started by an external to VistA process that start
RUN^KMPVRUN.

In the following listing, a few abbreviations will be used, as follows

 - shm = ##class(%SYSTEM.Config.SharedMemoryHeap).GetHeapSummary()
 - mem = ##class(%SYSTEM.Config.SharedMemoryHeap).FreeCount()
 - d   = ##class(SYS.Stats.Dashboard).Sample()
 - r   = ##class(SYS.Stats.Routine).Sample()
 - g   = $view("gvstat",$$DEFREG^%ZOSV())
 - p   = $view("probecrit")
 - ns  = nanoseconds

| Column             | Cache                | GTM                      |
| ----------------   | -------------------- | ------------------------ |
| Glorefs            | d.Glorefs            | g.(set+kil+dta+get+ord+zpr+qry) |
| GlorefsPerSec      | d.GlorefsPerSec      | Glorefs/$ZUT time diff   |
| Glosets            | d.GloSets            | g.set                    |
| LogicalReads       | d.LogicalReads       | g.(nbr+tbr)              |
| DiskReads          | d.DiskReads          | g.drd                    |
| DiskWrites         | d.DiskWrites         | g.dwt                    |
| Processes          | d.Processes          | $$^%PEEKBYNAME("node_local.ref_cnt",$$DEFREG^%ZOSV()) |
| RtnCommands        | r.RtnCommands        | n/a                      |
| RtnLines           | r.RtnLines           | n/a                      |
| RouRefs            | d.RouRefs            | n/a                      |
| CSPSessions        | d.CSPSessions        | n/a                      |
| CacheEfficency     | d.CacheEfficency     | Glorefs/DiskReads        |
| ECPAppSrvRate      | d.ECPAppSrvRate      | n/a                      |
| ECPDataSrvRate     | d.ECPDataSrvRate     | n/a                      |
| JournalEntries     | d.JournalEntries     | g.jrl                    |
| ApplicationErrors  | d.ApplicationErrors  | n/a                      |
| TotalSHMMemUsed    | $piece(shm,",",1)    | ipcs -mb 5th column      |
| SHMPagesUsed       | $piece(shm,",",2)    | n/a                      |
| ConfiguedSHMMemory | $piece(shm,",",3)    | sysctl -n kernel.shmmax  |
| SHMHeapAvail       | $piece(mem,",",1)    | n/a                      |
| SHMHeapPages       | $piece(mem,",",2)    | n/a                      |
| SHMMemTotal        | $piece(mem,",",3)    | n/a                      |
| strtabTotal        | $piece(mem,",",4)    | n/a                      |
| blksamples/CS Total | 1000                | p.(cat+cfn)              |
| blkcoll/CS fails   | Count of $ZU(190,17) in 1 second | p.cfn        |
| CS latch (ns)      | n/a                  | p.cpt                    |

### VSTM - $HFS/KMPV/VSTM-{date}.dat
Overall Volume Storage Statistics

Runs once a day on GT.M or once every 2 weeks on Cache. Started by an external
process outside of VistA that runs RUN^KMPVRUN.

In the following listing, a few abbreviations will be used, as follows

 - MB  = Megabytes (1024^2)
 - int = Integer
 - db  = ##class(SYS.Database).%OpenId(:)
 - tb  = $view("totalblocks")
 - fb  = $view("freeblocks")

| Column             | Cache                 | GTM                      |
| ----------------   | --------------------- | ------------------------ |
| Region/Volume      | ^["%SYS"]SYS("UCI",:) | $view("gvnext",:)        |
| MaxSize(MB)        | db.MaxSize            | tb * BlockSize           |
| CurrentSize(MB)    | db.Size               | (tb - fb) * BlockSize    |
| BlockSize(int)     | db.BlockSize          | $$^%PEEKBYNAME("sgmt_data.blk_size") |
| Blocks per Map     | db.BlocksPerMap       | n/a                      |
| FreeSpace(MB)      | db.GetFreeSpace()     | fb * BlockSize           |
| FreeSpaceBlocks    | db.GetFreeSpace()     | fb                       |
| SystemDir(bool)    | db.isSystemDB         | n/a                      |
| ExpansionSize(MB)  | db.ExpansionSize      | $$^%PEEKBYNAME("sgmt_data.extension_size") |
| DiskFreeSpace(MB)  | SYS.Database:FreeSpace.Data("DiskFreeSpace") | df -m $view("gvfile") |

### VBEM - $HFS/KMPV/VBEM-{date}.dat
VistA Components Execution Statistics (formerly RUM)

Runs once a day using taskman process KMPV VBEM DATA TRANSMISSION.

This used to be known as the Resource Usage Manager, and it gives you overall
stats by VistA components. You can use this to find which component is taking
too long to execute. VistA Components are annotated as follows:

[$!`&]Object***Protocol

 - No annotation = Option
 - $ = Major event (e.g. Taskman start, User Log-on)
 - ! = Option running through Taskman
 - ` = RPC
 - & = HL7
 - \*\*\* Protocol after the object

File is output once a day.

For below, q = ##class(%SYS.ProcessQuery).%OpenId($J)

| Column              | Cache                 | GTM                      |
| ----------------    | --------------------- | ------------------------ |
| node                | D GETENV^%ZOSV        | D GETENV^%ZOSV           |
| vista object        | See above             | See above                |
| Time Slot (seconds) | $H                    | $H                       |
| Times Invoked       | Simple Counter        | Simple Counter           |
| cputime(ms)         | q.GetCPUTime()        | $zgetjpi("","cputime")   |
| lines               | q.LinesExecuted       | n/a                      |
| commands            | q.CommandsExecuted    | n/a                      |
| global references   | q.GlobalReferences    | ZSHOW "G": set+kil+dta+get+ord+zpr+qry |
| elapsed time(ms)    | $ZTIMESTAMP           | $ZHOROLOG                |

### VMCM - $HFS/KMPV/VMCM-{date}.dat
Vista Message Count Monitor

Continous output started by an external to VistA process that start
RUN^KMPVRUN.

This counts the number of messages on each logical link on the system. This is
a continous running process that outputs the results every 15 minutes. The
originator of this process is outside of VistA (Cron or Cache TASKMGR).

| Column              | How         |
| ------------        | ----------- |
| Time Slot (seconds) | $H          |
| Node                | D GETENV^%ZOSV |
| Logical Link        | ^HLCS(870,:,0) p1 concat p4 |
| Last Incoming Mess  | ^HLCS(870,:,"IN QUEUE BACK POINTER") |
| First Incoming Mess | ^HLCS(870,:,"IN QUEUE FRONT POINTER") |
| Last Outgoing Mess  | ^HLCS(870,:,"OUT QUEUE BACK POINTER") |
| First Outgoing Mess | ^HLCS(870,:,"OUT QUEUE FRONT POINTER") |
| Link State          | ^HLCS(870,:,0) p5 |

### VHLM - $HFS/KMPV/VHLM-{date}.dat
Vista HL7 Message Types Monitor

Runs once a day using taskman process KMPV VHLM DATA TRANSMISSION.

Unlike VMCM, this does not provide statistics at the level of the links; but
rather at the level of the actual messages. Data on message response from
remote systems is available as well for HL7 (not HLO).

The output is produced once a day via a taskman process.

For the below, abbreviations and information:

File Roots:

 - 772: ^HL(772,
 - 773: ^HLMA(

MSH Segment:
 
 - HL7: ^HLMA(:,"MSH",1,0)
 - HLO: ^HLB(:,1) concat ^HLM(:,2)

Abbreviations:
 
 - s = seconds
 - I/O = Incoming/Outgoing
 - I/D = Immediate/Deferred
 - M/B/F = SINGLE MESSAGE/BATCH OF MESSAGES/FILE OF BATCHES


| Column                        | How         |
| ------------                  | ----------- |
| Message Type (Sync/Async/HLO) | MSH p16     |
| Time Slot                     | $H          |
| Transmission Type(I/O)        | 773 0p3     |
| Priority(I/D)                 | 773 0p4     |
| Message Type(M/B/F)           | 773 0p5 or 772 0p14 |
| Logical Link                  | 773 0p6     |
| Subscriber                    | 773 0p8     |
| Event Driver                  | 772 0p10    |
| Message Type                  | 773 0p13    |
| Event Type                    | 773 0p14    |
| Sending Application           | MSH p3      |
| Receiving Appliction          | MSH p5      |
| Sending Site                  | MSH p4      |
| Receiving Site                | MSH p6      |
| Number of Messages            | Counter     |
| Message Length                | 772 "S"p1 + $L(MSH) |
| # of HL7 Events               | 772 "S"p2   |
| Transmission Time(s)          | 772 "S"p3   |
| CATime(s)                     | 773 "S"p4 - 772 "S"p3 |
| AATime(s)                     | 773 "S"p5 - 772 "S"p3 |
