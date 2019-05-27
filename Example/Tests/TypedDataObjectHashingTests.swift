//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// TypedDataObjectHashingTests.swift
//
// Created by Igor Shmakov on 24/05/2019
//

import XCTest
import Nimble
import Quick
import Web3Swift

@testable import Swifty0x


struct MockedEIP712Domain: EIP712Representable {
    
    let name: String
    let version: String
    let chainID: Int
    let verifyingContract: String
    
    var typeName: String {
        return "EIP712Domain"
    }
    
    var values: [EIP712Value] {
        
        var data = [EIP712Value]()
        
        data.append(EIP712SimpleValue(
            parameter: EIP712Parameter(name: "name", type: .string),
            value: name)
        )
        
        data.append(EIP712SimpleValue(
            parameter: EIP712Parameter(name: "version", type: .string),
            value: version)
        )
        
        data.append(EIP712SimpleValue(
            parameter: EIP712Parameter(name: "chainId", type: .uint(len: 256)),
            value: chainID)
        )
        
        data.append(EIP712SimpleValue(
            parameter: EIP712Parameter(name: "verifyingContract", type: .address),
            value: verifyingContract)
        )

        return data
    }
}

struct MockedPerson: EIP712Representable {
    
    let name: String
    let address: String
    
    var typeName: String {
        return "Person"
    }
    
    var values: [EIP712Value] {
        
        var data = [EIP712Value]()
        
        data.append(EIP712SimpleValue(
            parameter: EIP712Parameter(name: "name", type: .string),
            value: name)
        )

        data.append(EIP712SimpleValue(
            parameter: EIP712Parameter(name: "wallet", type: .address),
            value: address)
        )
        
        return data
    }
}

struct MockedMail: EIP712Representable {
    
    let from: MockedPerson
    let to: MockedPerson
    let contents: String
    
    var typeName: String {
        return "Mail"
    }
    
    var values: [EIP712Value] {
        
        var data = [EIP712Value]()
        
        data.append(EIP712SimpleValue(
            parameter: EIP712Parameter(name: "from", type: .object(name: "Person")),
            value: from)
        )
        
        data.append(EIP712SimpleValue(
            parameter: EIP712Parameter(name: "to", type: .object(name: "Person")),
            value: to)
        )
        
        data.append(EIP712SimpleValue(
            parameter: EIP712Parameter(name: "contents", type: .string),
            value: contents)
        )
        
        return data
    }
}

class TypedDataObjectHashingTests: XCTestCase {
    
    var data: MockedMail {
        
        let from = MockedPerson(
            name: "Cow",
            address: "0xCD2a3d9F938E13CD947Ec05AbC7FE734Df8DD826"
        )
        
        let to = MockedPerson(
            name: "Bob",
            address: "0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB"
        )
        
        let mail = MockedMail(
            from: from,
            to: to,
            contents: "Hello, Bob!"
        )
        
        return mail
    }
    
    var domain: MockedEIP712Domain {
        
        let domain = MockedEIP712Domain(
            name: "Ether Mail",
            version: "1",
            chainID: 1,
            verifyingContract: "0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC"
        )
        
        return domain
    }
    
    func testTypeEncoding() {
        
        expect{
            return self.data.encodeType().encode()
        }.to(
            equal("Mail(Person from,Person to,string contents)Person(string name,address wallet)"),
            description: "Make sure type encoding is correct"
        )
    }
    
    func testHashing() {

        expect{
            let hash = EIP712Hash(domain: self.domain, typedData: self.data)
            return try hash.hash().toHexString()
        }.to(
            equal("be609aee343fb3c4b28e1df9e632fca64fcfaede20f02e86244efddf30957bd2"),
            description: "Make sure typed data hashing is correct"
        )
    }
}
