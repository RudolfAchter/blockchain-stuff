# Chia Testhost for Developing things

I want to develop some little tools for myself.
But i dont want to play around with my real money in the case i mess it up.
So i need a test host connected to chia testnet.

## Deploying lxd

I use lxd on rasbian for this.

- <https://snapcraft.io/install/lxd/raspbian>

Install and configure lxd / lxc in a way it works for you.

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

## Configuring a development environment with ansible