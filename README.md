## Description
A Crystal interface for getting operating system information. The name
comes from the Unix 'uname' command.

## Installation
Add this to your shard.yml file:
```
dependencies:
  uname:
    github: djberg96/crystal-uname
```
## Synopsis
```crystal
require "uname"

# Get full information about your system.
p System.uname

# Get individual bits of information about your system.
p System.sysname
p System.nodename
p System.release
p System.version
p System.machine

p System.model      # Darwin only
p System.domainname # Linux only
```

## Supported Platforms
* Linux
* Darwin

## Future Plans
Add MS Windows support

## Copyright
(C) 2021, Daniel J. Berger
All Rights Reserved

## Author
Daniel J. Berger
