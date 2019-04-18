//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// EIP712ValueEncoder.swift
//
// Created by Igor Shmakov on 15/04/2019
//

import Foundation
import BigInt
import Web3Swift

class EIP712ValueEncoder {

    let type: EIP712ParameterType
    let value: Any
    
    init(type: EIP712ParameterType, value: Any) {
        
        self.type = type
        self.value = value
    }
    
    func makeABIEncodedParameter() throws -> ABIEncodedParameter {
        
        switch type {
        case .bool:
            return try encodeBool()
        case .address:
            return try encodeAddress()
        case .string:
            return try encodeString()
        case .fixedBytes:
            return try encodeFixedBytes()
        case .uint, .int:
            return try encodeInt()
        case .bytes:
            return try encodeBytes()
        case .object:
            return try encodeObject()
        }
    }
    
    func encodeBool() throws -> ABIEncodedParameter {
        
        guard let bool = value as? Bool else {
            throw EIP712Error.invalidTypedDataValue
        }
        return ABIBoolean(origin: bool)
    }
    
    func encodeAddress() throws -> ABIEncodedParameter {
        
        guard let value = value as? String else {
            throw EIP712Error.invalidTypedDataValue
        }
        return ABIAddress(address: EthAddress(hex: value))
    }
    
    func encodeString() throws -> ABIEncodedParameter {
        
        guard let value = value as? String, let data = value.data() else {
            throw EIP712Error.invalidTypedDataValue
        }
        return ABIFixedBytes(origin: SimpleBytes(bytes: data.sha3(.keccak256)))
    }
    
    func encodeFixedBytes() throws -> ABIEncodedParameter {
        
        let data: Data
        if let value = value as? String {
            data = Data(hex: value)
        } else if let value = value as? Data {
            data = value
        } else {
            throw EIP712Error.invalidTypedDataValue
        }
        return ABIFixedBytes(origin: SimpleBytes(bytes: data))
    }
    
    func encodeInt() throws -> ABIEncodedParameter {
        
        let number: Int
        if let value = value as? Int {
            number = value
        } else if let str = value as? String, let value = Int(str) {
            number = value
        } else {
            throw EIP712Error.invalidTypedDataValue
        }
        return ABIUnsignedNumber(origin: EthNumber(value: number))
    }
    
    func encodeBytes() throws -> ABIEncodedParameter {
        
        let data: Data
        if let value = value as? String {
            data = Data(hex: value)
        } else if let value = value as? Data {
            data = value
        } else {
            throw EIP712Error.invalidTypedDataValue
        }
        return ABIFixedBytes(origin: SimpleBytes(bytes: data.sha3(.keccak256)))
    }
    
    func encodeObject() throws -> ABIEncodedParameter {
        
        guard let value = value as? EIP712Representable else {
            throw EIP712Error.invalidTypedDataValue
        }
        return ABIFixedBytes(origin: SimpleBytes(bytes: try value.hash()))
    }
}
