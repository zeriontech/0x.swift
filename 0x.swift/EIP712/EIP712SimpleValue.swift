//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// EIP712SimpleValue.swift
//
// Created by Igor Shmakov on 15/04/2019
//

import Foundation

struct EIP712SimpleValue: EIP712Value {
    
    let parameter: EIP712Parameter
    let value: Any
    
    func encode() throws -> Data {
        
        let encoder = EIP712ParameterEncoder(parameter: parameter, value: value)
        return try encoder.encode()
    }
}
