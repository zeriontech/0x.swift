import XCTest
import Nimble
import Quick
import Web3Swift

@testable import Swifty0x

class TypedDataHashingTests: XCTestCase {
    
    let simpleSignTypedData = try! String(contentsOfFile: Bundle.main.path(forResource: "simple", ofType: "json")!)
    let orderSignTypedData = try! String(contentsOfFile: Bundle.main.path(forResource: "order", ofType: "json")!)
    let mailSignTypedData = try! String(contentsOfFile: Bundle.main.path(forResource: "mail", ofType: "json")!)
    
    func testMailTypeEncoding() {
        
        expect{
            let data = try EIP712TypedData(jsonString: self.mailSignTypedData)
            return data.type.encode()
        }.to(
            equal("Mail(Person from,Person to,string contents)Person(string name,address wallet)"),
            description: "Make sure type encoding is correct"
        )
    }
    
    func testMailTypeHashing() {
        
        expect{
            let data = try EIP712TypedData(jsonString: self.mailSignTypedData)
            return try data.type.hashType().toHexString()
        }.to(
            equal("a0cedeb2dc280ba39b857546d74f5549c3a1d7bdc2dd96bf881f76108e23dac2"),
            description: "Make sure type hashing is correct"
        )
    }
    
    func testMailDomainHashing() {

        expect{
            let data = try EIP712TypedData(jsonString: self.mailSignTypedData)
            return try data.domain.hash().toHexString()
        }.to(
            equal("f2cee375fa42b42143804025fc449deafd50cc031ca257e0b194a650a912090f"),
            description: "Make sure domain hashing is correct"
        )
    }
    
    func testMailDataEncoding() {
        
        let data = "a0cedeb2dc280ba39b857546d74f5549c3a1d7bdc2dd96bf881f76108e23dac2fc71e5fa27ff56c350aa531bc129ebdf613b772b6604664f5d8dbe21b85eb0c8cd54f074a4af31b4411ff6a60c9719dbd559c221c8ac3492d9d872b041d703d1b5aadf3154a261abdd9086fc627b61efca26ae5702701d05cd2305f7c52a2fc8"
        
        expect{
            let data = try EIP712TypedData(jsonString: self.mailSignTypedData)
            return data.encodedData.toHexString()
        }.to(
            equal(data),
            description: "Make sure data encoding is correct"
        )
    }
    
    func testMailStructHashing() {
        
        expect{
            let data = try EIP712TypedData(jsonString: self.mailSignTypedData)
            return try data.hash().toHexString()
        }.to(
            equal("c52c0ee5d84264471806290a3f2c4cecfc5490626bf912d01f240d7a274b371e"),
            description: "Make sure typed data hashing is correct"
        )
    }
    
    func testMailHashing() {
        
        expect{
            let data = try EIP712TypedData(jsonString: self.mailSignTypedData)
            let hash = EIP712Hash(domain: data.domain, typedData: data)
            return try hash.hash().toHexString()
        }.to(
            equal("be609aee343fb3c4b28e1df9e632fca64fcfaede20f02e86244efddf30957bd2"),
            description: "Make sure typed data hashing is correct"
        )
    }
    
    func testMailSigning() {
        
        expect{
            let data = try EIP712TypedData(jsonString: self.mailSignTypedData)
            let hash = EIP712Hash(domain: data.domain, typedData: data)
            let privateKey = EthPrivateKey(hex: "0xc85ef7d79691fe79573b1a7064c19c1a9819ebdbd1faaab1a8ec92344438aaf4")
            let signer = EIP712Signer(privateKey: privateKey)
            return try signer.signatureData(hash: hash).toHexString()
        }.to(
            equal("4355c47d63924e8a72e509b65029052eb6c299d53a04e167c5775fd466751c9d07299936d304c153f6443dfa05f40ff007d72911b6f72307f996231605b915621c"),
            description: "Make sure typed data signing is correct"
        )
    }
    
    func testMailSignatureVerification() {
        
        expect{
            let data = try EIP712TypedData(jsonString: self.mailSignTypedData)
            let hash = EIP712Hash(domain: data.domain, typedData: data)
            let signature = Data(hex: "0x4355c47d63924e8a72e509b65029052eb6c299d53a04e167c5775fd466751c9d07299936d304c153f6443dfa05f40ff007d72911b6f72307f996231605b915621c")
            let address = EthAddress(hex: "0xCD2a3d9F938E13CD947Ec05AbC7FE734Df8DD826")
            let verifier = EIP712SignatureVerifier()
            return try verifier.verify(data: hash, signature: signature, address: address)
        }.to(
            equal(true),
            description: "Make sure signature verification is correct"
        )
    }
    
    func testMailFullSigning() {
        
        expect{
            let data = try EIP712TypedData(jsonString: self.mailSignTypedData)
            let hash = EIP712Hash(domain: data.domain, typedData: data)
            let privateKey = EthPrivateKey(hex: "0xc85ef7d79691fe79573b1a7064c19c1a9819ebdbd1faaab1a8ec92344438aaf4")
            let address = EthAddress(hex: "0xCD2a3d9F938E13CD947Ec05AbC7FE734Df8DD826")
            let signer = EIP712Signer(privateKey: privateKey)
            let signature = try signer.signatureData(hash: hash)
            let verifier = EIP712SignatureVerifier()
            return try verifier.verify(data: hash, signature: signature, address: address)
        }.to(
            equal(true),
            description: "Make sure data signing is correct"
        )
    }
    
    func testSimpleHashing() {

        expect{
            let data = try EIP712TypedData(jsonString: self.simpleSignTypedData)
            let hash = EIP712Hash(domain: data.domain, typedData: data)
            return try hash.hash().toHexString()
        }.to(
            equal("b460d69ca60383293877cd765c0f97bd832d66bca720f7e32222ce1118832493"),
            description: "Make sure typed data hashing is correct"
        )
    }
    
    func testOrderHashing() {
        
        expect{
            let data = try EIP712TypedData(jsonString: self.orderSignTypedData)
            let hash = EIP712Hash(domain: data.domain, typedData: data)
            return try hash.hash().toHexString()
        }.to(
            equal("55eaa6ec02f3224d30873577e9ddd069a288c16d6fb407210eecbc501fa76692"),
            description: "Make sure typed data hashing is correct"
        )
    }
}
