//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// EIP712ParameterEncoder.swift
//
// Created by Igor Shmakov on 15/04/2019
//

import Foundation
import BigInt
import Web3Swift

class EIP712ParameterEncoder: EIP712Encodable {

    let parameter: EIP712Parameter
    let value: Any
    
    init(parameter: EIP712Parameter, value: Any) {
        
        self.parameter = parameter
        self.value = value
    }
    
    func parseIntSize(type: String, prefix: String) -> Int {
        
        guard type.starts(with: prefix) else {
            return -1
        }
        guard let size = Int(type.dropFirst(prefix.count)) else {
            if type == prefix {
                return 256
            }
            return -1
        }
        if size < 8 || size > 256 || size % 8 != 0 {
            return -1
        }
        return size
    }
    
    func parseValue(parameter: EIP712Parameter, value: Any) throws -> Data {
        
        if parameter.type == "bool" {
            guard let bool = value as? Bool else {
                throw EIP712Error.invalidTypedDataValue(name: parameter.name)
            }
            let byte: UInt8 = bool ? 0x01 : 0x00
            return Data([byte]).leftPadded(size: 32)
        }
        
        if parameter.type == "address" {
            guard let value = value as? String, value.isValidEthereumAddress() else {
                throw EIP712Error.invalidTypedDataValue(name: parameter.name)
            }
            return Data(hex: value)
        }
        
        if parameter.type == "string" {
            guard let value = value as? String else {
                throw EIP712Error.invalidTypedDataValue(name: parameter.name)
            }
            return try value.sha3(.keccak256).data()
        }
        
        if parameter.type == "bytes" {
            if let value = value as? Data {
                return value.sha3(.keccak256)
            } else if let value = value as? String {
                return Data(hex: value).sha3(.keccak256)
            } else {
                throw EIP712Error.invalidTypedDataValue(name: parameter.name)
            }
        }
        
        if parameter.type.hasPrefix("int") {
            let size = parseIntSize(type: parameter.type, prefix: "int")
            guard size > 0 else {
                throw EIP712Error.invalidTypedDataValue(name: parameter.name)
            }
            if let value = value as? Int64 {
                return value.getTypedData(size: size).leftPadded(size: 32)
            } else if let value = value as? String, let bigInt = BigInt(value) {
                return try bigInt.getTypedData(size: size).leftPadded(size: 32)
            } else {
                throw EIP712Error.invalidTypedDataValue(name: parameter.name)
            }
        }
        
        if parameter.type.hasPrefix("uint") {
            let size = parseIntSize(type: parameter.type, prefix: "uint")
            guard size > 0 else {
                throw EIP712Error.invalidTypedDataValue(name: parameter.name)
            }
            if let value = value as? UInt64 {
                return value.getTypedData(size: size).leftPadded(size: 32)
            } else if let value = value as? String, let bigInt = BigUInt(value) {
                return try bigInt.getTypedData(size: size).leftPadded(size: 32)
            } else {
                throw EIP712Error.invalidTypedDataValue(name: parameter.name)
            }
        }
        
        if parameter.type.hasPrefix("bytes") && parameter.type != "bytes" {
            if let value = value as? String {
                return Data(hex: value).rightPadded(size: 32)
            } else if let value = value as? Data {
                return value.rightPadded(size: 32)
            } else {
                throw EIP712Error.invalidTypedDataValue(name: parameter.name)
            }
        }
        
        throw EIP712Error.invalidTypedDataValue(name: parameter.name)
    }
    
    func encode() throws -> Data {
        
        return try parseValue(parameter: parameter, value: value)
    }
}
