# Chia Blockchain Database

The initial sync of the blockchain database lasts a few days. If you can download a copy from a trustwothy source you could get up and running faster. Do you remember Bittorrent? It's for effectively distributing large files over the internet. I seed a torrent of a Chia Database Snapshot. **[Use these files at your own risk!](https://twitter.com/hoffmang/status/1540773480983138304)**. You can check the history of the files here:

- <https://github.com/RudolfAchter/blockchain-stuff/tree/main/docs/files>

Also you should **check the checksum of the files you downloaded.**

```bash
shasum -a256 yourFile
```

Current Version 2022-06-25:

- [blockchain_v2_mainnet.sqlite.torrent](../files/blockchain_v2_mainnet.sqlite.torrent)

| File                                                                                          | Version    | Size | Comment                                                                                                  |
| --------------------------------------------------------------------------------------------- | ---------- | ---- | -------------------------------------------------------------------------------------------------------- |
| [blockchain_v2_mainnet.sqlite.torrent](../files/blockchain_v2_mainnet.sqlite.torrent)         | 2022-06-25 | 396K | Torrent file for uncompressed blockchain-database                                                        |
| blockchain_v2_mainnet.sqlite                                                                  | 2022-06-25 | 79G  | The file you get when using above torrent. And also the file you get when uncompressing the .tgz version |
| [blockchain_v2_mainnet.sqlite.tgz.torrent](../files/blockchain_v2_mainnet.sqlite.tgz.torrent) | 2022-06-25 | 212K | Torrent file for compressed database (you need to uncompress)                                            |
| blockchain_v2_mainnet.sqlite.tgz                                                              | 2022-06-25 | 42G  | The blockchain database compressed as .tgz                                                               |

Checksums

| File                                                                                       | Checksum                                                         |
| --------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- |
| [blockchain_v2_mainnet.sqlite.torrent](../files/blockchain_v2_mainnet.sqlite.torrent)         | c17b0974d4f99974d572006bed73b68bfdcfcb20a1d84b01a16743360190c160 |
| blockchain_v2_mainnet.sqlite                                                                  | 2a6083498f851738df08341f4efef380dfa72ed4738d9c44c68ad087349d4a63 |
| [blockchain_v2_mainnet.sqlite.tgz.torrent](../files/blockchain_v2_mainnet.sqlite.tgz.torrent) | d6608426355f096c9516ab211707daa6f95284bfc7b6c3adb1b032985e7d0f43 |
| blockchain_v2_mainnet.sqlite.tgz                                                              | b2c7d4eb75aea7f9e587d118bc6015584cb76723c0d6dae4cf259dedc214f2e1 |

To unzip the `.tgz` you need gzip. Do this

```bash
tar -xzf blockchain_v2_mainnet.sqlite.tgz
```

Need a bittorrent Client? Bram Cohen invented the protocol, but nowadays current Bittorrent Clients do not have much to do with Bram. Some Clients are cluttered with bloatware, adware, payware.

A Free OpenSource Bittorrent Client of my choice is [qBittorrent](https://www.qbittorrent.org/). Available for Linux, Windows and Mac
