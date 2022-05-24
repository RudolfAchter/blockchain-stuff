# Spacemesh

## Devnet

### TweedleDev 207 - Spacemesh 0.2 Preview Devnet

- Devnet Join <https://product.spacemesh.io/#/join_devnet>

#### Wallet

```text
$ account info
Local alias: Default
Address: 0xC5C4c27a63AeE36bFf650f633626f5760BaBF6F2
Balance: 0 Smidge
Nonce: 0
Projected balance: 0 Smidge
Projected nonce: 0
Projected state includes all pending transactions that haven't been added to the mesh yet
Public key: 0xcf616a9ae833662ec081066cc5c4c27a63aee36bff650f633626f5760babf6f2
Private key: 0x925b1f46c3a5d887cd04108f72acae765c4ee83d2634482d5322b794562115decf616a9ae833662ec081066cc5c4c27a63aee36bff650f633626f5760babf6f2
```

#### Smeshing Setup

```text
$ Enter an address for smesher rewards: 0xC5C4c27a63AeE36bFf650f633626f5760BaBF6F2
$ Enter proof of spacetime data directory (relative to node or absolute): post_data
$ Enter number of units. (0.000001 GiB per unit. Min units: 2, Max units: 4): 4
Available proof of spacetime compute providers:
Id 1 - NVIDIA GeForce GTX 1650 (CUDA)
Id 2 - CPU (CPU)
$ Enter proof of spacetime compute provider id number: 1
Proof of spacetime setup configuration summary
Data directory (relative to node or absolute): post_data
Size (GiB): 3.8146973e-06
Size (Bytes): 4096
Units: 4
Labels: 4096
Bits per label: 8
Labels per unit: 1024
Compute provider id: 1
Data files: 1

```

👐 Proof of spacetime setup has started and your node will start smeshing when it is complete.
⚠️ IMPORTANT: Please update the smeshing section of your node's config file with the following so your node will smesh after you restart it.

```json
{
        "smeshing": {
                "smeshing-start": true,
                "smeshing-coinbase": "0xC5C4c27a63AeE36bFf650f633626f5760BaBF6F2",
                "smeshing-opts": {
                        "smeshing-opts-datadir": "post_data",
                        "smeshing-opts-numunits": 4,
                        "smeshing-opts-numfiles": 1,
                        "smeshing-opts-provider": 1,
                        "smeshing-opts-throttle": true
                }
        }
}

```
