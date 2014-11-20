# SDSC "gold" roll

## Overview

This roll bundles the Gold accounting manager.

For more information about Gold please visit the official web page:

- <a href="http://www.adaptivecomputing.com/products/open-source/gold/"
target="_blank">Gold</a> is an open source accounting system developed by <a
href="http://www.pnl.gov/" target="_blank">Pacific Northwest National Laboratory
(PNNL)</a> as part of the <a href="http://www.energy.gov/"
target="_blank">Department of Energy (DOE) Scalable Systems Software Project
(SSS)</a>.


## Requirements

To build/install this roll you must have root access to a Rocks development
machine (e.g., a frontend or development appliance).

If your Rocks development machine does *not* have Internet access you must
download the appropriate gold source file(s) using a machine that does
have Internet access and copy them into the `src/gold` directories on your
Rocks development machine.


## Dependencies

None.


## Building

To build the gold-roll, execute this on a Rocks development
machine (e.g., a frontend or development appliance):

```shell
% make 2>&1 | tee build.log
```

A successful build will create the file `gold-*.disk1.iso`.  If you built the
roll on a Rocks frontend, proceed to the installation step. If you built the
roll on a Rocks development appliance, you need to copy the roll to your Rocks
frontend before continuing with installation.


## Installation

To install, execute these instructions on a Rocks frontend:

```shell
% rocks add roll *.iso
% rocks enable roll gold
% cd /export/rocks/install
% rocks create distro
% rocks run roll gold | bash
```

## Testing

The gold-roll includes a test script which can be run to verify proper
installation of the roll documentation, binaries and module files. To
run the test scripts execute the following command(s):

```shell
% /root/rolltests/gold.t 
```
