# packer ttylinux template

[ttylinux](http://ttylinux.net/) has a very small disk and memory footprint, and
very quick boot time.  This packer template uses the smallest of the ttylinux
family, [PC-i486](http://ttylinux.net/dloadPC-i486.html).  The ttylinux iso is a
live image, booted with dhcp enabled and the provisioner installs onto the given
virtual disk.

## ttylinux installer

The install.sh script does the following:

* Creates a disk partition

* Extracts the embedded install.conf

* Runs /sbin/ttylinux-installer

The install.conf is based on the example that comes with ttylinux

## ttylinux.iso

Originally from: http://ttylinux.net/Download/ttylinux-pc_i486-16.1.iso.gz

However:

* pc_i486-16.1 was deleted from the site when pc_i486-16.2 was released and the
  pc_i486-16.2 installer doesn't work

* packer would need to unzip the iso.gz

# ESXi requirements

## ssh enabled

This can be done via the console or kickstart with:

    vim-cmd hostsvc/enable_ssh
    vim-cmd hostsvc/start_ssh

## Firewall rules enabled

Any ports that packer needs must be open, such as:

* incoming `vnc_port_min` .. `vnc_port_max`

* outgoing ports for iso file downloads

* outgoing `http_port_min` .. `http_port_max`

Use 'esxcli network firewall' to configure rules on an existing system and/or
via kickstart.

## GuestIPHack enabled

This setting enables an io filter in the vmkernel to look for ARP responses
where it can get the ip address for a VM without VMware tools being installed.

    esxcli system settings advanced set -o /Net/GuestIPHack -i 1

Note when building most images, an ARP request happens when the kickstart or
preseed file is downloaded from packer's HTTP server.  This is not the case with
ttylinux, so the boot_command works around this by running an nslookup in the
live image.

# ESXi template variables

* remote_type - esx5

* remote_host - hostname or ip address of the ESX machine

* remote_port - ssh port on the ESX machine, defaults to 22

* remote_username - ssh user on the ESX machine

* remote_password - ssh user on the ESX machine

* remote_datastore - vmfs volume, "datastore1" for example

* disk_type_id - vmkfstools diskformat param, "thin" or "sesparse" for example

* vmx_data.ethernet0.networkName - "VM Network" for example

Example:

    packer build -var remote_host=10.118.67.109 template.json
