//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// EIP712Type.swift
//
// Created by Igor Shmakov on 15/04/2019
//

import Foundation

struct EIP712Type: EIP712Encodable {
    
    let name: String
    let parameters: [EIP712Parameter]
    
    func encode() throws -> Data {
        let encodedParameters = try parameters
            .map { try $0.encode() }
            .joined(separator: try ",".data())
        guard let encodedType = name.data() else {
            throw EIP712Error.invalidType(name: name)
        }
        return try encodedType + "(".data() + encodedParameters + ")".data()
    }
}
