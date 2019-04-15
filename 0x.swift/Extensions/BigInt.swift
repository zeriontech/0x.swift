//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// BigInt.swift
//
// Created by Igor Shmakov on 15/04/2019
//

import Foundation
import BigInt

extension BigInt {
    
    func getTypedData(size: Int) throws -> Data {
        
        let encodedIntSize = size / 8
        if let serialized = serialize(bitWidth: encodedIntSize) {
            return serialized
        } else {
            throw EIP712Error.integerOverflow
        }
    }
    
    func serialize(bitWidth: Int) -> Data? {
        let valueData = twosComplement()
        if valueData.count > bitWidth {
            return nil
        }
        
        var data = Data()
        if sign == .plus {
            data.append(Data(repeating: 0, count: bitWidth - valueData.count))
        } else {
            data.append(Data(repeating: 255, count: bitWidth - valueData.count))
        }
        data.append(valueData)
        return data
    }
    
    func twosComplement() -> Data {
        if sign == .plus {
            return magnitude.serialize()
        }
        
        let serializedLength = magnitude.serialize().count
        let max = BigUInt(1) << (serializedLength * 8)
        return (max - magnitude).serialize()
    }
}

extension BigUInt {
    
    func getTypedData(size: Int) throws -> Data {
        
        let encodedIntSize = size / 8
        var data = Data()
        let serialized = serialize()
        if serialized.count > encodedIntSize {
            throw EIP712Error.integerOverflow
        }
        
        data.append(Data(repeating: 0, count: encodedIntSize - serialized.count))
        data.append(serialized)
        return data
    }
}
