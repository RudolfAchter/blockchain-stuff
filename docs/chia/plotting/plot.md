# Chia Plotting with MadMax (2023 Version)

This is provided **as is**. **No warranty**

This is my updated example for plotting with [MadMax Plotter](https://github.com/madMAx43v3r/chia-plotter) on a machine with plenty of RAM (more than 110 GiB) on RamDisk. If you wanna go big you REALLY want the temporary stuff to be written in RAM. The final Plots then you write to `FINAL_DISK` which is the biggest and cheapest HDD you can find. If you have a different computer which you just temporary use for plotting it should be enough to just build and install MadMax instead of the whole Chia Full Node. You just need your Pool Contract Address and Farmer Public Key from your full Node. With just MadMax and your public keys you can even go plotting safely on your friends computer without revealing your wallet private Keys so they cannot control your Chia Wallet or your plot NFT.
Please make sure to **not reveal any private keys** to anyone other than you! Do not install any private keys on computers that are not yours!

If you haven't created a Chia Full Node and are not Member of a plotting Pool then first follow the guides from chia:

- <https://docs.chia.net/introduction>
- <https://github.com/Chia-Network/chia-blockchain/wiki/Pooling-User-Guide>

My Script does the Plotting with MadMax Software on command line. But if you don't understand Chia Plotting first go with [Plotting Basics](https://docs.chia.net/plotting-basics) first to get the basics.

To get your `POOL_CONTRACT_ADDRESS` and `FARMER_PUBLIC_KEY` do this on your Full Node:

`POOL_CONTRACT_ADDRESS`

```bash
chia plotnft show | grep "Pool contract"
```

`FARMER_PUBLIC_KEY`

```bash
chia keys show | grep "Farmer public key"
```

Per Default it simply starts a "nice" Background process.
If you want to run it in foreground use it with `plot.sh foreground`

But First edit the File and **edit the configuration variables** on top to your needs.

You can use the File [plot.sh](plot.sh)

Or just Copy Paste what you need from here

```bash
#!/bin/bash

# Install / build MadMax Plotter as described here:
# https://github.com/madMAx43v3r/chia-plotter

# Configure these Directories
CHIA_DIR=$HOME/chia
POOL_CONTRACT_ADDRESS=xch1_yourPoolContractAddress
FARMER_PUBLIC_KEY=yourPublicFarmerKey

# FAST_DISK
# Best Option to have Ramdisk as FAST_DISK
# 75% IOPs are written here
# i tested so far..
# 115 GiB Ramdisk for k32 plots
# 230 GiB Ramdisk for k33 plots
# wanna make a Ramdisk on Linux?
# add this line to your /etc/fstab
# modify size to your needs
# tmpfs                           /mnt/ramdisk    tmpfs   defaults,size=115G      0 0
FAST_DISK=/mnt/ramdisk/plot 

# TMP_DISK
# Something fast with more Space than FAST_DISK
# Typically your SSD
# 220 GiB SSD Space for k32 plots
# 440 Gib SSD Space for k33 plots
TMP_DISK=$CHIA_DIR/tmp 
LOGFILE=$CHIA_DIR/chia_plot.log
SCRIPT_PIDFILE=$CHIA_DIR/plot.sh.pid
PLOT_PIDFILE=$CHIA_DIR/chia_plot.pid
FINAL_DISK=/mnt/your_big_storage/plot/pool

# chia_plot_k34 now supports k32 up to k34
COMMAND=chia_plot_k34
# Size you want to plot
KSIZE=33

if [ ! -d $CHIA_DIR];then
    mkdir -p $CHIA_DIR
fi

if [ ! -d $FAST_DISK ];then
        mkdir -p $FAST_DISK
fi

if [ ! -d $TMP_DISK ];then
        mkdir -p $TMP_DISK
fi

start(){

        echo "Starting Plot "`date +%Y-%m-%d_%H-%M-%S` >> $LOGFILE

        #Empty temporary dirs
        rm $FAST_DISK/*
        rm $TMP_DISK/*
        nice -n 10 $COMMAND -k $KSIZE -n 100 -2 $FAST_DISK/ -t $TMP_DISK/ -d $FINAL_DISK/ -c $POOL_CONTRACT_ADDRESS -f $FARMER_PUBLIC_KEY 2>&1 >> $LOGFILE & echo $! > $PLOT_PIDFILE &
}

foreground(){
        rm $FAST_DISK/*
        rm $TMP_DISK/*
        nice -n 10 $COMMAND -k $KSIZE -n 100 -2 $FAST_DISK/ -t $TMP_DISK/ -d $FINAL_DISK/ -c $POOL_CONTRACT_ADDRESS -f $FARMER_PUBLIC_KEY

}


case "$1" in
"start")
        #sudo mount-chia.sh
        start & echo $! > $SCRIPT_PIDFILE &
        ;;
"foreground")
        #sudo mount-chia.sh
        foreground
        ;;
"suspend")
        SCRIPT_PID=`cat $SCRIPT_PIDFILE`
        PLOT_PID=`cat $PLOT_PIDFILE`
        kill -s SIGSTOP $PLOT_PID
        ;;
"continue")
        SCRIPT_PID=`cat $SCRIPT_PIDFILE`
        PLOT_PID=`cat $PLOT_PIDFILE`
        kill -CONT $PLOT_PID
        ;;
"stop")
        SCRIPT_PID=`cat $SCRIPT_PIDFILE`
        PLOT_PID=`cat $PLOT_PIDFILE`
        #kill $SCRIPT_PID
        kill -s SIGKILL $PLOT_PID
        kill -s SIGKILL $PLOT_PID2
        ;;
"gracefulstop")
        SCRIPT_PID=`cat $SCRIPT_PIDFILE`
        PLOT_PID=`cat $PLOT_PIDFILE`
        #kill $SCRIPT_PID
        kill -s SIGINT $PLOT_PID
        ;;
"-h")
        echo "usage:"
        echo "plot.sh (start|suspend|continue|stop|gracefulstop)"
        ;;
```
