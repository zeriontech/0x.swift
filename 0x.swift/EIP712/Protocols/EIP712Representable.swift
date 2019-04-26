//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// EIP712Representable.swift
//
// Created by Igor Shmakov on 15/04/2019
//

import Foundation
import Web3Swift

protocol EIP712Representable: EIP712Hashable {
    
    var typeName: String { get }
    var values: [EIP712Value] { get }
}

extension EIP712Representable {
    
    var typeName: String {
        return String(describing: Swift.type(of: self))
    }
    
    func typeDependencies() -> [EIP712Type] {
        
        let types = values
            .compactMap { $0.value as? EIP712Representable }
            .flatMap { [$0.type()] + $0.typeDependencies() }
        
        var uniqueTypes = [EIP712Type]()
        for type in types {
            if !uniqueTypes.contains(where: { $0.name == type.name }) {
                uniqueTypes.append(type)
            }
        }
        return uniqueTypes
    }
    
    func type() -> EIP712Type {
        
        return EIP712Type(name: typeName, parameters: values.map { $0.parameter })
    }
    
    func encodeType() ->  EIP712StructType {
        
        let primary = type()
        let referenced = typeDependencies().filter { $0.name != primary.name }
        return EIP712StructType(primary: primary, referenced: referenced)
    }
    
    func hashType() throws -> Data {
        
        return try encodeType().hashType()
    }
    
    func encodeData() throws -> Data {
        
        var parameters: [ABIEncodedParameter] = [ABIFixedBytes(origin: SimpleBytes(bytes: try hashType()))]
        parameters += try values.map { try $0.makeABIEncodedParameter() }
        return try EncodedABITuple(parameters: parameters).value()
    }
    
    func hash() throws -> Data {

        return try encodeData().sha3(.keccak256)
    }
}
