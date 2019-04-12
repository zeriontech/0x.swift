//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// EIP712Domain.swift
//
// Created by Igor Shmakov on 09/04/2019
//

import Foundation

struct EIP712Domain: EIP712Representable {
    
    let name: String
    let version: String
    let chainID: Int
    let verifyingContract: String
    let salt: Data?
    
    func type() throws -> EIP712StructType {
 
        var parameters = [
            EIP712Parameter(name: "name", type: "string"),
            EIP712Parameter(name: "version", type: "string"),
            EIP712Parameter(name: "chainId", type: "uint256"),
            EIP712Parameter(name: "verifyingContract", type: "address")
        ]
        
        if salt != nil {
            parameters += [
                EIP712Parameter(name: "salt", type: "bytes32")
            ]
        }
        
        let type = EIP712Type(name: "EIP712Domain", parameters: parameters)
        return EIP712StructType(primary: type)
    }
    
    func message() throws -> EIP712Encodable {
        
        throw EIP712Error.notImplemented
    }
}
