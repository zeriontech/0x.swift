//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// EIP712Representable.swift
//
// Created by Igor Shmakov on 15/04/2019
//

import Foundation

protocol EIP712Representable: EIP712Encodable {
    
    func type() throws -> EIP712StructType
    func message() throws -> EIP712Encodable
}

extension EIP712Representable {
    
    func typeHash() throws -> Data {
        return try type().encode().sha3(.keccak256)
    }
    
    func encode() throws -> Data {
        return try (typeHash() + message().encode()).sha3(.keccak256)
    }
    
    func hashStruct() throws -> Data {
        return try encode()
    }
}
