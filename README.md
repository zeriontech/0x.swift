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

### Parsing event from receipt
```swift
let transfer = try ERC20Events.Transfer(
        log: receipt.logs()[0]
    )
print(transfer.from.toPrefixedHexString())
print(transfer.to.toPrefixedHexString())
print(transfer.value.toDecimalString())
```

### Parsing logs from receipt
```swift
let events = ABIEvent.parse(types: [
        ERC20Events.Transfer.self,
        ERC20Events.Approval.self
    ], logs: receipt.logs())
    
let transfers = events.filter( $0.signature() == ERC20Events.Transfer.signature())
```

## Working with typed data

### Hashing typed data from JSON
```swift
let data = try EIP712TypedData(jsonString: typedDataJson)
let hash = EIP712Hash(domain: data.domain, typedData: data)
```

### Constructing typed data from Swift objects
```swift
struct Order {
    
    let makerAddress: String
    let takerAddress: String
    let feeRecipientAddress: String
    let senderAddress: String
    let makerAssetAmount: Int
    let takerAssetAmount: Int
    let makerFee: Int
    let takerFee: Int
    let expirationTimeSeconds: Int
    let salt: Int
    let makerAssetData: Data
    let takerAssetData: Data
}

extension Order: EIP712Representable {
    
    var values: [EIP712Value] {
        return [
            EIP712SimpleValue(
                parameter: EIP712Parameter(name: "makerAddress", type: .address),
                value: makerAddress
            ),
            EIP712SimpleValue(
                parameter: EIP712Parameter(name: "takerAddress", type: .address),
                value: takerAddress
            ),
            EIP712SimpleValue(
                parameter: EIP712Parameter(name: "feeRecipientAddress", type: .address),
                value: feeRecipientAddress
            ),
            EIP712SimpleValue(
                parameter: EIP712Parameter(name: "senderAddress", type: .address),
                value: senderAddress
            ),
            EIP712SimpleValue(
                parameter: EIP712Parameter(name: "makerAssetAmount", type: .uint(len: 256)),
                value: makerAssetAmount
            ),
            EIP712SimpleValue(
                parameter: EIP712Parameter(name: "takerAssetAmount", type: .uint(len: 256)),
                value: takerAssetAmount
            ),
            EIP712SimpleValue(
                parameter: EIP712Parameter(name: "makerFee", type: .uint(len: 256)),
                value: makerFee
            ),
            EIP712SimpleValue(
                parameter: EIP712Parameter(name: "takerFee", type: .uint(len: 256)),
                value: takerFee
            ),
            EIP712SimpleValue(
                parameter: EIP712Parameter(name: "expirationTimeSeconds", type: .uint(len: 256)),
                value: expirationTimeSeconds
            ),
            EIP712SimpleValue(
                parameter: EIP712Parameter(name: "salt", type: .uint(len: 256)),
                value: salt
            ),
            EIP712SimpleValue(
                parameter: EIP712Parameter(name: "makerAssetData", type: .bytes),
                value: makerAssetData
            ),
            EIP712SimpleValue(
                parameter: EIP712Parameter(name: "takerAssetData", type: .bytes),
                value: takerAssetData
            ),
        ]
    }
}

let order = Order(
    makerAddress: "0xc0ffee254729296a45a3885639ac7e10f9d54979",
    takerAddress: "0x999999cf1046e68e36e1aa2e0e07105eddd1f08e",
    feeRecipientAddress: "0x0000000000000000000000000000000000000000",
    senderAddress: "0x0000000000000000000000000000000000000000",
    makerAssetAmount: 1,
    takerAssetAmount: 1,
    makerFee: 0,
    takerFee: 0,
    expirationTimeSeconds: 3600,
    salt: 0,
    makerAssetData: // ABIv2 encoded data,
    takerAssetData: // ABIv2 encoded data
)

let domain = EIP712Domain(
    name: "0x protocol",
    version: "2",
    chainID: 1,
    verifyingContract: "0x4f833a24e1f95d70f028921e27040ca56e09ab0b",
    salt: nil
)

let hash = EIP712Hash(domain: domain, typedData: order)
```

### Signing typed data
```swift
let privateKey = EthPrivateKey(hex: "SIGNER_PRIVATE_KEY")
let signer = EIP712Signer(privateKey: privateKey)
let signature = try signer.signatureData(hash: hash)
```

### Verifying typed data signature
```swift
let address = EthAddress(hex: "SIGNER_ADDRESS")
let verifier = EIP712SignatureVerifier()
return try verifier.verify(data: hash, signature: signature, address: address)
```

## Author

- Igor Shmakov [@shmakovigor](https://github.com/shmakovigor), shmakoff.work@gmail.com
- Vadim Koleoshkin [@rockfridrich](https://github.com/rockfridrich), vadim@koleoshkin.com

## License

0x.swift is available under the the Apache License 2.0. See the LICENSE file for more info.
