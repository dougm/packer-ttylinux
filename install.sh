#!/bin/sh

/sbin/fdisk /dev/hda << EOF
n
p
1
1

w
EOF

cat <<EOF > /tmp/install.conf
# vim: syntax=config

# This is an example of the installation configuration file format used by the
# ttylinux-installer script.  This file can have any file name; it is used
# by giving a command line "--config=<name>" option to the ttylinux-installer
# script, where <name> is the name of the installation configuration file.
#
# The following ttylinux-installer script command line example, with the
# ttylinux CD-ROM in the /dev/hdc device, installs ttylinux from the CD-ROM
# onto devices as directed by the installation configuration file named
# "install.conf".
#
#      $ ttylinux-installer --config=install.conf /dev/hdc

# File Format
# -----------
#
# Blank lines and lines that begin with '#' are ignored throughout the file.
#
# Each section is indicated by a name in square brackets, similar to a ".ini"
# configuration file.  The file MUST have the [fstab] and [lilo] sections, but
# the other sections are optional.  All possible sections are in this example
# file; however, some of the sections are commented-out.

[fstab]
#
# This section defines the target system hard drive devices and file systems;
# part of the information here is used to format and mount the devices nodes
# for installation, and some of the information is literally copied to be the
# installed system's /etc/fstab file.
#
# NOTICE => these entries MUST be in order of mouting; do NOT put "/boot" or
#           any other mount directory before "/".
#
# NOTICE => the "start", "stop" and "size" values are not yet used by the
#           ttylinux installation process, but they must be in the file.
#
# In this example, /dev/hda5 is too small for ext3, so it is ext2.
#
#  +----- A "y" here indicates that the ttylinux-installer script will format
#  |      the device node according to the "type" information in the literal
#  |      /etc/fstab content.
#  |
#  |                        |<------- literal /etc/fstab content -------->|
#  V                        V                                             V
#format  start  stop  size  device     mount      type  options   dump fsck
 y       x      x     64M   /dev/hda1  /          ext3  defaults     1 1
#y       x      x     32M   /dev/hda2  swap       swap  defaults     0 0
#y       x      x     24M   /dev/hda1  /boot      ext3  defaults     1 1
#y       x      x     8M    /dev/hda5  /tmp       ext2  defaults     1 1
#y       x      x     16M   /dev/hda6  /usr/local ext3  defaults     1 1
#y       x      x     16M   /dev/hda7  /var       ext3  defaults     1 1

[host]
#
# This section defines some of the contents of the /etc/hosts file, and defines
# the host name in general.
#
# If your network interfaces all use DHCP then the HOST_IPADR setting probably
# doesn't matter, and the IP address in /etc/hosts probably will be wrong.
#
HOST_IPADR=192.168.1.20
HOST_NAME=ttylinux.ec.eng.vmware.com

[rtc]
#
# This content is copied directly into /etc/sysconfig/clock.  This defines your
# RTC settings.
#
TZ=PST
UTC=no

# [lockdown]
#
# This section causes the ttylinux-installer script to do a virtual environment-
# oriented lock-down, and defines the name of the context script.
#
# If you don't know what this is, you don't need it.
#
# For a description of the virtual environment-oriented lock-down, look in the
# ttylinux User Guide, in the source distribution top-level directory for a
# README file or in the tylinux on-line forum.  However, there may be no
# description available anywhere.
#
# CONTEXT_SCRIPT=init.sh

[eth0]
#
# This content is copied directly into /etc/sysconfig/network-scripts/ifcfg-eth0
#
ENABLE=yes
NAME=Ethernet
IPADDRESS=192.168.1.20
CIDRLEN=24
NETWORK=192.168.1.0
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
BROADCAST=192.168.1.255
DHCP=yes

# [eth1]
#
# This content is copied directly into /etc/sysconfig/network-scripts/ifcfg-eth1
#
# ENABLE=yes
# NAME=Ethernet
# IPADDRESS=192.168.1.X
# CIDRLEN=24
# NETWORK=192.168.1.0
# NETMASK=255.255.255.0
# GATEWAY=192.168.1.1
# BROADCAST=192.168.1.255
# DHCP=yes

# [eth2]
#
# This content is copied directly into /etc/sysconfig/network-scripts/ifcfg-eth2
#
# ENABLE=yes
# NAME=Ethernet
# IPADDRESS=192.168.1.X
# CIDRLEN=24
# NETWORK=192.168.1.0
# NETMASK=255.255.255.0
# GATEWAY=192.168.1.1
# BROADCAST=192.168.1.255
# DHCP=yes

# [eth3]
#
# This content is copied directly into /etc/sysconfig/network-scripts/ifcfg-eth3
#
# ENABLE=yes
# NAME=Ethernet
# IPADDRESS=192.168.1.X
# CIDRLEN=24
# NETWORK=192.168.1.0
# NETMASK=255.255.255.0
# GATEWAY=192.168.1.1
# BROADCAST=192.168.1.255
# DHCP=yes

[lilo]
#
# This content is copied directly into /etc/lilo.conf
#
# In order to have tab spaces in the actual /etc/lilo.conf file, the "."
# character is used in this file as the first character in the line; where the
# first character is ".", the "." character and following whitespace are
# replaced by a single tab character.
#
boot       = /dev/hda
install    = bmp
bitmap     = /boot/ttylinux.bmp
bmp-colors = 1,2,,2,1,
bmp-table  = 33,11,1,8
bmp-timer  = 44,20,1,2,
compact # Try merging read for adjacent sectors into a single read request.
default = ttylinux
lba32   # Use 32-bit Logical Block Address, not cylinder/head/sector.
prompt
timeout = 60
image=/boot/vmlinuz
.	label  = ttylinux
.	root   = /dev/hda1
.	append = "quiet"

[packages]
#
# NOTICE => read these notes carefully.
#
# If this section is NOT present, or commented-out, then all packages WILL be
# installed.
#
# If this section IS present, then ONLY the listed packages are installed.  Any
# wrong package name is ignored.
#
# The versions in the package names below might not match the packages in the
# ttylinux that you are installing.  Check the versions and update these
# following package names and update as needed to match the package versions
# from the ttylinux that you are installing.
#
# alsa-lib-1.0.24.1
# alsa-utils-1.0.24.2
bash-4.2
# binutils-2.22
busybox-1.21.0
dropbear-2013.58
e2fsprogs-1.42.7
# gcc-4.4.4
glibc-2.9
# glibc-devel-2.13
# gpm-1.20.6
# iptables-1.4.12
lilo-23.2
# kmodules-2.6.38.1
# make-3.82
# module-init-tools-3.16
ncurses-5.9
# ppp-2.4.5
# retawq-0.2.6c
# root_extras-nopackage
ttylinux-basefs-1.0
ttylinux-devfs-1.0
ttylinux-utils-1.5
# udev-163
# util-linux-ng-2.18


EOF

/sbin/ttylinux-installer --config=/tmp/install.conf /dev/hdc
