//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// EIP712.swift
//
// Created by Igor Shmakov on 09/04/2019
//

import Foundation

class EIP712 {
    
    func encodePersonalMessage(message: String) throws -> Data {
        guard
            let messageData = message.data(using: .utf8),
            let prefixData = "\u{19}Ethereum Signed Message:\n\(message.count)".data()
            else {
                throw EIP712Error.invalidMessage
        }
        return prefixData + messageData
    }
    
    func encodeTypedData(domain: EIP712Domain, data: EIP712Representable) throws -> Data {
        guard
            let prefixData = "\u{19}u{01}".data(),
            let domainData = try? domain.hashStruct(),
            let structData = try? data.hashStruct()
            else {
                throw EIP712Error.invalidMessage
        }
        return prefixData + domainData + structData
    }
}
