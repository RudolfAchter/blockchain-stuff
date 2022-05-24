# ZKSync als Layer2 Lösung für Storj Ethereum

Mit ZKSync Lassen sich Transaction Fees auf Ehtereum dramatisch reduzieren.

- <https://wallet.zksync.io/>

Ich brauche das um meinen Storj Node rentabel zu machen

- [Storj Node Dokumentation Start](https://docs.storj.io/node/)

## zkSync Swap

Es gibt genau einen zkSync Swap auf dem ich meine Storj Token gegen etwas anderes tauschen kann.

- [ZigZag Exchange für zkSync](https://trade.zigzag.exchange/?market=STORJ-ETH&network=zksync)

## zkSync to Centralised Exchange

Und es gibt genau einen Exchange auf dem ich meine Storj Token zu Geld machen kann.

- [ByBit unterstützt zkSync](https://www.bybit.com/)

21.04.2022 : Und Stand heute ist auf ByBit zkSync offline 🤣. ABER: auf [ZigZag](https://trade.zigzag.exchange/?market=STORJ-ETH&network=zksync) kann ich STORJ für ETH Swappen und dann auf [Orbiter](https://www.orbiter.finance/?source=ZkSync&dest=Polygon) ETH vom zkSync Netzwerk nach Polygon schicken. ETH kann ich dann vom Polygon Netzwerk aus zum Crypto.com Exchange einzahlen. Easy Peasy... :

```mermaid
flowchart LR
    subgraph zksync["zkSync L2 Netzwerk"]
        subgraph padding01[ ]
            zksync_wallet["ZKSync\nWallet 0xd9a6"] --STORJ--> zigzag["ZigZag\nSwap"] --ETH--> zksync_wallet --ETH--> 
            orbiter["Orbiter\nBridge"]
        end
    end

    orbiter --ETH--> polygon_wallet

    subgraph polygon["Polygon Netzwerk"]
        subgraph padding02[ ]
            polygon_wallet["ZKSync\nWallet 0xd9a6"]
        end
    end

    polygon_wallet --ETH--> cryptocom_wallet

    subgraph cryptocom["Crypto.com"]
        subgraph padding03[ ]
            cryptocom_wallet["Crypto.com\nETH Wallet\n(Polygon) 0xea3b"]

            cryptocom_wallet --ETH--> cryptocom_exchange
            cryptocom_exchange --USDT--> cryptocom_wallet
            cryptocom_wallet --USDT--> cryptocom_creditcard

            cryptocom_exchange["Crypto.com\nExchange"]

            cryptocom_creditcard["Crypto.com\nKreditkarte"]
        end
    end
    classDef padding fill:none,stroke:none
    class padding01,padding02,padding03 padding
```