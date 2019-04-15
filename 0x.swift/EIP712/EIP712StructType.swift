//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// EIP712StructType.swift
//
// Created by Igor Shmakov on 15/04/2019
//

import Foundation

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
