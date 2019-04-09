//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// EIP712Struct.swift
//
// Created by Igor Shmakov on 09/04/2019
//

import Foundation
import CryptoSwift

protocol EIP712Encodable {
    
    func encode() throws -> Data
}

struct EIP712Parameter: EIP712Encodable {
    
    let name: String
    let type: String
    
    func encode() throws -> Data {
        guard let data = "\(type) \(name)".data else {
            throw EIP712Error.invalidParameter(name: name)
        }
        return data
    }
}

struct EIP712Type: EIP712Encodable {
    
    let name: String
    let parameters: [EIP712Parameter]
    
    func encode() throws -> Data {
        let encodedParameters = try parameters
            .map { try $0.encode() }
            .joined(separator: ",".data!)
        guard let encodedType = name.data else {
            throw EIP712Error.invalidType(name: name)
        }
        return encodedType + "(".data! + encodedParameters + ")".data!
    }
}

struct EIP712StructType: EIP712Encodable {
    
    let types: [EIP712Type]
    var primaryType: EIP712Type? {
        return types.first
    }
    
    init(primary: EIP712Type, referenced: [EIP712Type] = []) {
        types = [primary] + referenced.sorted { $0.name < $1.name }
    }
    
    func encode() throws -> Data {
        return try types.reduce(Data()) { try $0 + $1.encode()}
    }
}

struct EIP712Value {
    
    let value: EIP712Encodable
}

protocol EIP712Struct: EIP712Encodable {
    
    func type() throws -> EIP712StructType
    func values() throws -> [EIP712Encodable]
}

extension EIP712Struct {
    
    func encodeValues() throws -> Data {
        return try values().reduce(Data()) { try $0 + $1.encode()}
    }
    
    func typeHash() throws -> Data {
        return try type().encode().sha3(.keccak256)
    }
    
    func encode() throws -> Data {
        return try (typeHash() + encodeValues()).sha3(.keccak256)
    }
    
    func hashStruct() throws -> Data {
        return try encode()
    }
}
