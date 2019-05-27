//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ABIType.swift
//
// Created by Igor Shmakov on 11/05/2019
//

import Foundation
import Web3Swift

public protocol ABIType {
    
    static func decode(message: ABIMessage, index: Int) throws -> Self
    
    static func decode(bytes: BytesScalar) throws -> Self
    
    static func abiType() -> String
}

extension Bool: ABIType {
    
    public static func decode(bytes: BytesScalar) throws -> Bool {
        return try NumericBoolean(bool: bytes).value()
    }
    
    
    public static func decode(message: ABIMessage, index: Int = 0) throws -> Bool {
        return try DecodedABIBoolean(
            abiMessage: message,
            index: index
        ).value()
    }
    
    public static func abiType() -> String {
        return "bool"
    }
}

extension String: ABIType {
    
    public static func decode(bytes: BytesScalar) throws -> String {
        return try UTF8String(bytes: bytes).value()
    }
    
    public static func decode(message: ABIMessage, index: Int = 0) throws -> String {
        return try DecodedABIString(
            abiMessage: message,
            index: index
        ).value()
    }
    
    public static func abiType() -> String {
        return "string"
    }
}

extension EthNumber: ABIType {
    
    public static func decode(bytes: BytesScalar) throws -> EthNumber {
        return EthNumber(hex: bytes)
    }
    
    public static func decode(message: ABIMessage, index: Int = 0) throws -> EthNumber {
        return try EthNumber(
            hex: SimpleBytes(
                bytes: DecodedABINumber(
                    abiMessage: message,
                    index: index
                ).value()
            )
        )
    }
    
    public static func abiType() -> String {
        return "uint256"
    }
}

extension EthAddress: ABIType {
    
    public static func decode(bytes: BytesScalar) throws -> EthAddress {
        return EthAddress(bytes: TrimmedZeroPrefixBytes(origin: bytes))
    }
    
    public static func decode(message: ABIMessage, index: Int = 0) throws -> EthAddress {
        return try EthAddress(
            bytes: SimpleBytes(
                bytes: DecodedABIAddress(
                    abiMessage: message,
                    index: index
                ).value()
            )
        )
    }
    
    public static func abiType() -> String {
        return "address"
    }
}
