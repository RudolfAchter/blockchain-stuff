
# Chia Premine

## Chia Premine and where it stays on Blockchain

### You cannot audit the wallets

In Chia Blockchain you could theoretically have a new address for each and every transaction, which provides pseudo-anonymity on the public blockchain. Transactions cannot easily be matched to a single identity. You CAN be auditet with [Observer Keys](https://docs.chia.net/docs/09keys/keys-and-signatures/#non-observer-vs-observer-keys), but you can decide who is allowed to audit you. So wallets are not publically auditable.

### But you can follow the coins

One thing you CAN follow perfectly, are the coins itself. Each coin created has a parent. You can follow parents ultimately until "Genesis", the start of the whole blockchain. When a coin is "spent" it will be destroyed and split into children with new values transferred to the new destination (which also can be your own wallet. Think of "change" when you deal with cash.). You can perfectly trace on blockchain which coins are spent and which are not. The exact premine amount is divided into 4 coins which stay there unspent since [May 4th 2021](https://en.wikipedia.org/wiki/Star_Wars_Day) (really? Exactly 10th anniversary of Star Wars Day? 👍)

these (shortened) hashed are linked to [xchscan.com](https://xchscan.com). You can check "Parent Coin" and "Child Coins" for each transaction. As long these coins stay "unspent" and have no childs, they really were not touched

```mermaid
flowchart TD
  subgraph sub01["Chia Premine Coins"]
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

