//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// EIP712Parameter.swift
//
// Created by Igor Shmakov on 15/04/2019
//

import Foundation

struct EIP712Parameter: EIP712Encodable {
    
    let name: String
    let type: String
    
    func encode() throws -> Data {
        guard let data = "\(type) \(name)".data() else {
            throw EIP712Error.invalidParameter(name: name)
        }
        return data
    }
}
