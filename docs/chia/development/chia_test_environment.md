---
tags:
    - Tech
    - Linux
    - Chia
    - Powershell
    - Ansible
    - Development
---

# Chia Test Environment

I want to develop some little tools for myself.
But i dont want to play around with my real money in the case i mess it up.
So i need a test environment connected to chia testnet

## Deploying lxd

I use lxd on rasbian (arm64 / 64 bit arm) and on my workstation (amd64) for this.

- <https://snapcraft.io/install/lxd/raspbian>

Install and configure lxd / lxc in a way it works for you. This is what i did:

- [Virtualization with lxd](virtualization_lxd.md)

## What environment am i on

To get the right packages i want to know on which environment i am working.

```bash
lsb_release -a
```

So iam on Debian 11 (wich is my current raspbian version)

```text
No LSB modules are available.
Distributor ID: Debian
Description:    Debian GNU/Linux 11 (bullseye)
Release:        11
Codename:       bullseye
```

And whats the architecture?

```bash
uname -a
```

`aarch64` so i am on a 64bit arm processor

```text
Linux cloud 5.15.32-v8+ #1538 SMP PREEMPT Thu Mar 31 19:40:39 BST 2022 aarch64 GNU/Linux
```

## Deploying Ubuntu Image for my Testhost

For the next steps i `sudo`ed to root. So i am root for all these steps.
If you prefer to not be root you should add `sudo` to all these (lxc related) commands.

So what are the right images for my host?

```bash
lxc image list images:ubuntu/jammy arch=arm64
```

my choice is `ubuntu/jammy/cloud`

```bash
lxc launch images:ubuntu/jammy/cloud chiatest
```

i don't want my testhost to start automatically (resources)

```bash
lxc config set chiatest boot.autostart false
```

OK Login to Container and Test

```bash
lxc exec chiatest /bin/bash
```

Looks good

```text
root@chiatest:~# hostname
chiatest
root@chiatest:~# whoami
root
```

## putting it all together

Fast forward launching an image when lxd / lxc is prepared

Launch a image

```bash
lxc launch images:ubuntu/focal/cloud chia-full01
```

Prepare it for ansible.

- <https://github.com/RudolfAchter/chia-test-environment/blob/main/src/lxd/prepare_lxd_guest.sh>

```bash
bash ./prepare_lxd_guest.sh
```


## Configuring a development environment with ansible

### Prerequesites

So i installed ansible on my ubuntu development machine (not "chiatest" VM. My Development Workstation)

```bash
sudo apt install ansible
#no clue why i also need this python module. but was necessary
pip install ansible
```

### Ansible Inventory and Playbook

Clone this repoository `https://github.com/RudolfAchter/chia-test-environment`

```bash
git clone https://github.com/RudolfAchter/chia-test-environment
```

Follow instructions

- <https://github.com/RudolfAchter/chia-test-environment>

Basically what the ansible playbook does

- <https://github.com/RudolfAchter/chia-test-environment/blob/main/src/ansible/playbook/chia-test.yml>
- It installs ubuntu desktop
- Installs all necessary packages for chia full node
- installs xrdp and git

So you have a virtual desktop environment where you can play around with your chia full node.
