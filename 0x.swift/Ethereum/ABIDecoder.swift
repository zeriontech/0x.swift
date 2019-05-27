//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ABIDecoder.swift
//
// Created by Igor Shmakov on 11/05/2019
//

import Foundation
import Web3Swift

class ABIDecoder {
    
    func number(message: ABIMessage, index: Int = 0) throws -> EthNumber {
        return try EthNumber.decode(message: message, index: index)
    }
    
    func number(bytes: BytesScalar) throws -> EthNumber {
        return try EthNumber.decode(bytes: bytes)
    }
    
    func string(message: ABIMessage, index: Int = 0) throws -> String {
        return try String.decode(message: message, index: index)
    }
    
    func string(bytes: BytesScalar) throws -> String {
        return try String.decode(bytes: bytes)
    }
    
    func address(message: ABIMessage, index: Int = 0) throws -> EthAddress {
        return try EthAddress.decode(message: message, index: index)
    }
    
    func address(bytes: BytesScalar) throws -> EthAddress {
        return try EthAddress.decode(bytes: bytes)
    }
    
    func boolean(message: ABIMessage, index: Int = 0) throws -> Bool {
        return try Bool.decode(message: message, index: index)
    }
    
    func boolean(bytes: BytesScalar) throws -> Bool {
        return try Bool.decode(bytes: bytes)
    }
    
    func decode<T: ABIType>(message: ABIMessage, index: Int = 0) throws -> T {
        return try T.decode(message: message, index: index)
    }
    
    func decode<T: ABIType>(bytes: BytesScalar) throws -> T {
        return try T.decode(bytes: bytes)
    }
}

