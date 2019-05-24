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
    
    func string(message: ABIMessage, index: Int = 0) throws -> String {
        return try String.decode(message: message, index: index)
    }
    
    func address(message: ABIMessage, index: Int = 0) throws -> EthAddress {
        return try EthAddress.decode(message: message, index: index)
    }
    
    func boolean(message: ABIMessage, index: Int = 0) throws -> Bool {
        return try Bool.decode(message: message, index: index)
    }
    
    func decode<T: ABIType>(message: ABIMessage, index: Int = 0) throws -> T {
        return try T.decode(message: message, index: index)
    }
}

