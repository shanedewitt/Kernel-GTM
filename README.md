VistA/RPMS Kernel Enhancements Project
======================================
Enhancements to the VistA Kernel for GT.M and Cache. Originally, this project
focused only on GT.M, but due to redaction and omissions in VA code, various
Cache routines have been enhanced, like ZISHONT, ZOSVONT, and XUSHSH.

Originally, this project focused on the core Kernel. Now it includes the
following VistA packages:

 * Kernel
 * Kernel Toolkit
 * Capacity Management - Resource Usage Monitor
 * Capacity Management - Tools
 * Capacity Management - VistA System Monitor
 * RPC Broker
 * VistALink
 * VistALink - Security

Products & Installation
-----------------------
### Kernel

 | Patch              | Sequence             | Release Notes | Summary |
 | ------------------ | -------------------- | ------------- | ------- |
 | [XU\*8.0\*10001](https://github.com/shabiel/Kernel-GTM/releases/download/XU-8.0-10001/XU_8-0_10001.KID) | 1 | [10001](doc/rel/XU-8.0-10001.rel.md) | Kernel GTM Support Upgrade |
 | [XU\*8.0\*10002](https://github.com/shabiel/Kernel-GTM/releases/download/XU-8.0-10002/XU_8-0_10001--XU_8-0_10002.KID) | 2 | [10002](doc/rel/XU-8.0-10002.rel.md) | Bug fixes + NDF Update Support |
 | [XU\*8.0\*10004](https://github.com/shabiel/Kernel-GTM/releases/download/XU-8.0-10004/XU-8.0-10004T2.KID) | 3 | [10004](doc/rel/XU-8.0-10004.rel.md) | Bug fixes |
 | [XU\*8.0\*10005](https://github.com/shabiel/Kernel-GTM/releases/download/XU-8.0-10005/XU_8-0_10005.KID) | 4 | [10005](doc/rel/XU-8.0-10005.rel.md) | UTF-8 support/Bug fixes |
 | [XU-Multibuild (ALL)](https://github.com/shabiel/Kernel-GTM/releases/download/XU-8.0-10005/XU-8-10001-10002-10004-10005.KID) | n/a | n/a | n/a |
 | [virgin\_install.zip](https://github.com/shabiel/Kernel-GTM/releases/download/XU-8.0-10005/virgin_install.zip) | n/a | n/a | n/a |

You can install these either using a KIDS build by unzipping the routines in
the virgin\_install.zip. You should always use the KIDS build unless you have
a new system that you are building that doesn't have KIDS operational yet. In
that case, you should unzip the files in virgin\_install.zip into your routines
directory.

The Multibuild is always safe to install; any KIDS build is always safe to 
re-install.

### Toolkit

 | Patch              | Sequence             | Release Notes | Summary |
 | ------------------ | -------------------- | ------------- | ------- |
 | [XT\*7.3\*10001](https://github.com/OSEHRA-Sandbox/XINDEX/releases/download/XT-7.3-10001/XT-7p3-10001T4.KID) | 1 | [10001](https://github.com/OSEHRA-Sandbox/XINDEX/blob/master/README.rst) | XINDEX Upgrade |
 | [XT\*7.3\*10002](https://github.com/shabiel/Kernel-GTM/releases/download/XT-7.3-10002/XT-7p3-10002T1.KID) | 1 | [10002](doc/rel/XU-8.0-10005.rel.md) | XTHC https support |

### Other packages
VistALink code is ready to be packaged. RPC Broker has UTF-8 support changes
that need to be packaged. Capacity Management packages support for running
outside of the VA is currently in process.

Unit Testing
------------
See [UnitTests.md](UnitTests.md)

Future Plans
------------
I plan to port the following packages in these order:
 
 * RPMS %ZISH (done)
 * Job Examination capability for ZSY (done)
 * XOBW web service implementation for GT.M (done)
 * Resource Usage Monitor (RUM) (completed but not packaged)
 * Statistical Analysis of Global Growth (SAGG) (in progress)
