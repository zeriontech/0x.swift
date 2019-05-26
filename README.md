# 0x.swift

[![Version](https://img.shields.io/cocoapods/v/0x.swift.svg?style=flat)](https://cocoapods.org/pods/0x.swift)
[![License](https://img.shields.io/cocoapods/l/0x.swift.svg?style=flat)](https://cocoapods.org/pods/0x.swift)
[![Platform](https://img.shields.io/cocoapods/p/0x.swift.svg?style=flat)](https://cocoapods.org/pods/0x.swift)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

0x.swift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod '0x.swift'
```

## Interacting with ERC20 token

### Create token instance
```swift
let network = AlchemyNetwork( 
            chain: "mainnet",
            apiKey: "ETi2ntZoWxd6nTI1qE13Q4I1eLB8AMDl"
        )

let zrxToken = ERC20Token(
        //ZRX Token
        contract: EthAddress(
            hex: "0xe41d2489571d322189246dafa5ebde1f4699f498" 
        ),
        //JSON RPC network (Alchemy, Infura, Local or Private)
        network: network
    )
```
### Check decimal
```swift
let decimals = try zrxToken.decimals().value().toDecimal()
```
### Check owner balance
```swift
let balance : Decimal = try zrxToken.balanceOf(
        owner: EthAddress(
            hex: "0x606af0bd4501855914b50e2672c5926b896737ef"
        )
    ).value().toNormalizedDecimal(
        power: 18
    )
```

### Sending tokens 
```swift
let sendingTxHash = try zrxToken.transfer(
    to: EthAddress(
        hex: "0x42b9dF65B219B3dD36FF330A4dD8f327A6Ada990"
    ), 
    value: EthNumber(
        decimals: "1"
    ), 
    sender: EthPrivateKey(
        hex: "SENDER_PRIVATE_KEY"
    )
)

let receipts = try sendingTxHash.receipt(
        network: network
    )
```

### Parsing logs from receipt
```swift
let transfer = try ERC20Events.Transfer(
        log: receipt.logs()[0]
    )
print(transfer.from.toPrefixedHexString())
print(transfer.to.toPrefixedHexString())
print(transfer.value.toDecimalString())
```

### SigningTypedData
```swift
//TODO: Add example of hashing 0x order
```

## Author

- Igor Shmakov [@shmakovigor](https://github.com/shmakovigor), shmakoff.work@gmail.com
- Vadim Koleoshkin [@rockfridrich](https://github.com/rockfridrich), vadim@koleoshkin.com

## License

0x.swift is available under the the Apache License 2.0. See the LICENSE file for more info.
