# Lightweight Virtualization environment with lxd

A lot of developers would be using [docker](https://www.docker.com/) for a virtual chia app container and [kubernetes](https://kubernetes.io/de/) to orchestrate an environment of multiple containers.
But i want to be able to play around with a whole operating system as it would like if chia is installed on my computer. With docker i would have a very minimal and limited environment.

Also i am primarily a windows guy and want to learn more about linux (doing windows and linux parallel for over 20 years now)

So this is my lxd attempt for my home lab.

## Bridge Konfiguration

I want my vms to run directly bridged in my network. So its just like there is another computer standing next to my workstation connected to the same switch. On linux this is realized with `bridge-utils`

### Ubuntu

```bash
apt install bridge-utils
```

**/etc/netplan/01-network-manager-all.yml**

```yaml
# Let NetworkManager manage all devices on this system
#network:
#  version: 2
#  renderer: NetworkManager
```

**/etc/netplan/50-cloud-init.yaml**

```yaml
network:
    version: 2
    ethernets:
        eth0:
            dhcp4: false
            optional: true
    bridges:
        br0:
            dhcp4: true
            interfaces:
                - eth0
                #could be something other like (ens192|eno1). Take whatever your nic is named
```

Normally `sudo systemctl restart network-manager` should do. But in my case i had to reboot my workstation. Now i have a bridge interface

```text
workstation:~$ ifconfig
br0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.1.107  netmask 255.255.255.0  broadcast 192.168.1.255
        inet6 fe80::42b0:34ff:fe1a:afaf  prefixlen 64  scopeid 0x20<link>
        ether 40:b0:34:1a:af:af  txqueuelen 1000  (Ethernet)
        RX packets 2547  bytes 909907 (909.9 KB)
        RX errors 0  dropped 32  overruns 0  frame 0
        TX packets 2565  bytes 599669 (599.6 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eno1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        ether 40:b0:34:1a:af:af  txqueuelen 1000  (Ethernet)
        RX packets 2659  bytes 963525 (963.5 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2580  bytes 618238 (618.2 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 20  memory 0xf5200000-f5220000 
```

### Debian (raspbian)

- <https://wiki.debian.org/LXC/SimpleBridge>
- <https://forums.raspberrypi.com/viewtopic.php?t=218453>

This is what i did in raspbian

```bash
apt install bridge-utils
```

On my raspian there was dhcpcd (client deamon) configuring my interface. 
I had to disable this


**/etc/dhcpcd.conf**

```text
#no dhcpcd for lxc lxd bridge 
denyinterfaces eth0 br0
```

Config file for bridge interface **/etc/network/interfaces.d/br0**

```text
auto br0
iface br0 inet dhcp
        bridge_ports eth0
        bridge_fd 0
        bridge_maxwait 0
```

## Installation von lxd

### raspbian

there was no lxd packet for raspbian. But there was a snap package

- <https://stgraber.org/2017/01/18/lxd-on-debian/>

```bash
apt install btrfs-progs snapd
snap install lxd
```

### Ubuntu 20

On Ubuntu 20 you simply can do

```bash
sudo apt install lxd
```

## Initialize

For the lxd commands i do `sudo su -` first because i need to be root anyways.

First configuration of lxd happens with `lxd init` 

This is an example on my raspbian machine

```text
Would you like to use LXD clustering? (yes/no) [default=no]: 
Do you want to configure a new storage pool? (yes/no) [default=yes]: 
Name of the new storage pool [default=default]: 
Name of the storage backend to use (ceph, btrfs, dir, lvm) [default=btrfs]: 
Create a new BTRFS pool? (yes/no) [default=yes]: yes
Would you like to use an existing empty block device (e.g. a disk or partition)? (yes/no) [default=no]: yes
Path to the existing block device: /dev/sda3
Would you like to connect to a MAAS server? (yes/no) [default=no]: no
Would you like to create a new local network bridge? (yes/no) [default=yes]: yes
What should the new bridge be called? [default=lxdbr0]: 
What IPv4 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]: 
What IPv6 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]: none
Would you like the LXD server to be available over the network? (yes/no) [default=no]: no
Would you like stale cached images to be updated automatically? (yes/no) [default=yes]: 
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]: yes
config: {}
networks:
- config:
    ipv4.address: auto
    ipv6.address: none
  description: ""
  name: lxdbr0
  type: ""
  project: default
storage_pools:
- config:
    source: /dev/sda3
  description: ""
  name: default
  driver: btrfs
profiles:
- config: {}
  description: ""
  devices:
    eth0:
      name: eth0
      network: lxdbr0
      type: nic
    root:
      path: /
      pool: default
      type: disk
  name: default
projects: []
cluster: null
```


This is an example i did on my ubuntu workstation

```text 
Would you like to use LXD clustering? (yes/no) [default=no]: 
Do you want to configure a new storage pool? (yes/no) [default=yes]: 
Name of the new storage pool [default=default]: 
Name of the storage backend to use (btrfs, dir, lvm, zfs, ceph) [default=zfs]: 
Create a new ZFS pool? (yes/no) [default=yes]: 
Would you like to use an existing empty block device (e.g. a disk or partition)? (yes/no) [default=no]: 
Size in GB of the new loop device (1GB minimum) [default=30GB]: 200GB
Would you like to connect to a MAAS server? (yes/no) [default=no]: 
Would you like to create a new local network bridge? (yes/no) [default=yes]: no
Would you like to configure LXD to use an existing bridge or host interface? (yes/no) [default=no]: yes
Name of the existing bridge or host interface: br0
Would you like the LXD server to be available over the network? (yes/no) [default=no]: 
Would you like stale cached images to be updated automatically? (yes/no) [default=yes] 
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]: yes
config: {}
networks: []
storage_pools:
- config:
    size: 200GB
  description: ""
  name: default
  driver: zfs
profiles:
- config: {}
  description: ""
  devices:
    eth0:
      name: eth0
      nictype: bridged
      parent: br0
      type: nic
    root:
      path: /
      pool: default
      type: disk
  name: default
cluster: null

```

## Edit a profile to use the network bridge in lxd


```bash
lxc profile show default
```

```yaml
config: {}
description: Default LXD profile
devices:
  eth0:
    name: eth0
    nictype: bridged
    parent: br0
    type: nic
  root:
    path: /
    pool: default
    type: disk
```

If you nedd to make changes to this profile. Edit it like this

```bash
lxc profile edit default
```

## Verfügbare Images anzeigen lassen

List commands can list in different formats. Look in help.

```bash
lxc image list --help
```

```text
...
  Column shorthand chars:

      l - Shortest image alias (and optionally number of other aliases)
      L - Newline-separated list of all image aliases
      f - Fingerprint (short)
      F - Fingerprint (long)
      p - Whether image is public
      d - Description
      a - Architecture
      s - Size
      u - Upload date
      t - Type

Usage:
  lxc image list [<remote>:] [<filter>...] [flags]

Aliases:
  list, ls

Flags:
  -c, --columns   Columns (default "lfpdatsu")
      --format    Format (csv|json|table|yaml) (default "table")
...
```

For now i manually want to search the images

```bash
lxc image list images: | less
```

For my raspberry i search a special architecture (here armhf)

```bash
lxc image list images: architecture=armhf
```

## Create a new machine

### image from the cloud

```bash
lxc launch images:debian/10/armhf yourmachine
```

### image already downloaded

```bash
lxc launch ubuntu:20.04 yourmachine
```

### Open console of an machine

```bash
lxc console yourmachine
```

### Start a root shell on your machine


```bash
lxc exec yourmachine -- /bin/bash
```

```text
root@yourmachine:~#
```

Most of the time i just want to put my ssh public key onto the machine

```bash
vi .ssh/authorized_keys
```

## Configure your virtual machine

### Autostart

VM starts directly with your computer

```bash
lxc config set yourmachine boot.autostart true
```

### Security privileged machine

If a lxd VM is security privileged it is able to mount disks for example.

```bash
lxc config set snapcast-server01 security.privileged true
```

## Delete virtual Machine

```bash
#Do force if your machine currently is running
lxc delete yourmachine --force
```
