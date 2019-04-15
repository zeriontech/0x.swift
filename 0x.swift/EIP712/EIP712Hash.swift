//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// Hash:.swift
//
// Created by Igor Shmakov on 09/04/2019
//

import Foundation

class EIP712Hash {
    
    let typedData: EIP712Representable
    let domain: EIP712Domain
    
    init(domain: EIP712Domain, typedData: EIP712Representable) {
        
        self.domain = domain
        self.typedData = typedData
    }
    
    init(typedData: EIP712TypedData) {
        
        self.domain = typedData.decodedDomain
        self.typedData = typedData
    }

    func value() throws -> Data {
        guard
            let prefixData = "\u{19}u{01}".data(),
            let domainData = try? domain.hashStruct(),
            let structData = try? typedData.hashStruct()
        else {
            throw EIP712Error.invalidMessage
        }
        return (prefixData + domainData + structData).sha3(.keccak256)
    }
}
