---
tags:
    - Chia
    - Blockchain
    - Economy
    - Market
---

# Chia Prefarm (Premine)

## The Chia Prefarm and where it stays on Blockchain

### You cannot audit the wallets

In Chia Blockchain you could theoretically have a new address for each and every transaction, which provides pseudo-anonymity on the public blockchain. Transactions cannot easily be matched to a single identity. You CAN be auditet with [Observer Keys](https://docs.chia.net/docs/09keys/keys-and-signatures/#non-observer-vs-observer-keys), but you can decide who is allowed to audit you. So wallets are not publically auditable.

### But you can follow the coins

One thing you CAN follow perfectly, are the coins itself. Each coin created has a parent. You can follow parents ultimately until "Genesis", the start of the whole blockchain. When a coin is "spent" it will be destroyed and split into children with new values transferred to the new destination (which also can be your own wallet. Think of "change" when you deal with cash.). You can perfectly trace on blockchain which coins are spent and which are not. The exact premine amount is divided into 4 coins which stay there unspent since [May 4th 2021](https://en.wikipedia.org/wiki/Star_Wars_Day) (really? Exactly 10th anniversary of Star Wars Day? 👍)

these (shortened) hashed are linked to [xchscan.com](https://xchscan.com). You can check "Parent Coin" and "Child Coins" for each transaction. As long these coins stay "unspent" and have no childs, they really were not touched

```mermaid
flowchart TD
  subgraph sub01["Chia Prefarm Coins"]
    subgraph padding01[ ]

      genesis["Genesis"]
      genesis --child--> 0xdce5 & 0x1fd6

      0xdce5["<a href='https://xchscan.com/txns/0xdce550a4341e5ec31c7e3fe5c6ab9801c66ed02689725939537d8d4492465800'>0xdce5</a><br>2.625.000 XCH"]

      0xdce5 --child--> 0xeac9 & 0x8225

        0xeac9["<a href='https://xchscan.com/txns/0xeac9be36298887f751fa7f7367a27ab12c72360ebf7a78ee4fcfb96db121a3b7'>0xeac9</a><br>1.312.500 XCH<br>May 4th 2021"]
        
        0x8225["<a href='https://xchscan.com/txns/0x8225b3a9538238c170bbd79632604e075f7357621bbd846f50b1aa6d6cfa95e0'>0x8225</a><br>1.312.500 XCH<br>May 4th 2021"]


      0x1fd6["<a href='https://xchscan.com/txns/0x1fd60c070e821d785b65e10e5135e52d12c8f4d902a506f48bc1c5268b7bb45b'>0x1fd6</a><br>18.375.000 XCH"]

      0x1fd6 --child--> 0x4d00 & 0xd7a8

        0x4d00["<a href='https://xchscan.com/txns/0x4d0012503cb0b31947ed582881e59d334b667a0b4c96ac86c4f540c850055a22'>0x4d00</a><br>9.187.500 XCH<br>May 4th 2021"]
        
        0xd7a8["<a href='https://xchscan.com/txns/0xd7a81eece6b0450c9eaf3b3a9cdbff5bde0f1e51f1f18fcf50cc533296cb04b6'>0xd7a8</a><br>9.187.500 XCH<br>May 4th 2021"]

    end
  end

  classDef padding fill:none,stroke:none
  class padding01,padding02,padding03 padding
```

## Additions an Removals

to better understand how these transactions work, you have to understand how Spend Bundles and "Additions and Removals" work in Chia Network.

- <https://docs.chia.net/spend-bundles/>


## Chia wants to lock these coins with custody features

- https://youtu.be/RKNPyDGWIrM?t=24860

We want to lock up the fonds. So that we cannot dump it. We can only pull out at a certain rate.
So Chia gives a promise on this. And i trust them.

## And they kept their promise

On Oct 28 2022 Gene Hoffman tweeted that they moved the prefarm to their own custody solution based on the Technology described in [Chia wants to lock these coins with custody features](#chia-wants-to-lock-these-coins-with-custody-features)

```mermaid
flowchart LR
  subgraph sub01["Chia Prefarm Coins moving to Self Custody"]
    subgraph padding01[ ]
      direction LR
      genesis["Genesis"]
      genesis --child--> 0xdce5 & 0x1fd6

      0xdce5["<a href='https://xchscan.com/txns/0xdce550a4341e5ec31c7e3fe5c6ab9801c66ed02689725939537d8d4492465800'>0xdce5</a><br>2.625.000 XCH<br>To: xch18krkt5a9..."]

      0xdce5 --child--> 0xeac9 & 0x8225

        0xeac9["<a href='https://xchscan.com/txns/0xeac9be36298887f751fa7f7367a27ab12c72360ebf7a78ee4fcfb96db121a3b7'>0xeac9</a><br>1.312.500 XCH<br>May 4th 2021<br>To: xch1duvy5ur5..."]
        
        0x8225["<a href='https://xchscan.com/txns/0x8225b3a9538238c170bbd79632604e075f7357621bbd846f50b1aa6d6cfa95e0'>0x8225</a><br>1.312.500 XCH<br>May 4th 2021<br>To: xch1rdatypul..."]

        0x8225 --child--> 0x61d3

          0x61d3["<a href='https://xchscan.com/txns/0x61d300e453b718670655f7ec6a07a8ebfc6cf37eb6e82c5e5a21a79aaf821c25'>0x61d3</a><br>1.312.500 XCH<br>Block: 2.746.485<br>Oct 28 2022<br>To: xch1aukdy3dj..."]

      0x1fd6["<a href='https://xchscan.com/txns/0x1fd60c070e821d785b65e10e5135e52d12c8f4d902a506f48bc1c5268b7bb45b'>0x1fd6</a><br>18.375.000 XCH<br>To: xch16g76z354..."]

      0x1fd6 --child--> 0x4d00 & 0xd7a8

        0x4d00["<a href='https://xchscan.com/txns/0x4d0012503cb0b31947ed582881e59d334b667a0b4c96ac86c4f540c850055a22'>0x4d00</a><br>9.187.500 XCH<br>May 4th 2021<br>To: xch1duvy5ur5..."]

        0x4d00 --child--> 0x913a & 0xb5a

          0x913a["<a href='https://xchscan.com/txns/0x913acfb2923fade9d76d154cc49ad292d0fb5fc8bd8c9da242d92052a929a229'>0x913a</a><br>9.187.500 XCH<br>Block 2.746.467<br>Oct 28th 2022<br>To: xch1y6krqgs2..."]

          0xb5a["<a href='https://xchscan.com/txns/0xb5ac7346e45814d2dc44c15245c6dd21b2664e853cd3f9b43846d1dc9f9e4668'>0xb5a</a><br>0,00027 XCH<br>Block 2.746.467<br>Oct 28th 2022<br>To: xch1tvmngs52..."]
        
        0xd7a8["<a href='https://xchscan.com/txns/0xd7a81eece6b0450c9eaf3b3a9cdbff5bde0f1e51f1f18fcf50cc533296cb04b6'>0xd7a8</a><br>9.187.500 XCH<br>May 4th 2021<br>To: xch1rdatypul"]
    end
  end

  subgraph sub02["Chia Prefarm Wallet Addresses"]
    subgraph padding02[ ]

      genesis_wallet["Genesis Wallet"]
      genesis_wallet --2.625.000 XCH--> xch18krkt5a9  
      genesis_wallet --18.375.000 XCH--> xch16g76z354
        xch18krkt5a9["xch18krkt5a9"]
        xch16g76z354["xch16g76z354"]

        xch18krkt5a9 --1.312.500 XCH--> xch1duvy5ur5
        xch16g76z354 --9.187.500 XCH--> xch1duvy5ur5

        xch18krkt5a9 --1.312.500 XCH--> xch1rdatypul
        xch16g76z354 --9.187.500 XCH--> xch1rdatypul
        
        xch1duvy5ur5 --9.187.500 XCH--> xch1y6krqgs2
        xch1duvy5ur5 --0,00027 XCH--> xch1tvmngs52

    end
  end

  classDef padding fill:none,stroke:none
  class padding01,padding02,padding03 padding
```

## This is to be minted as an NFT

Because the prefarm is a promise and it is something that is no subject to change i mint it as an NFT for the world

