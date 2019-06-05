//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ABIEvent.swift
//
// Created by Igor Shmakov on 11/05/2019
//

import Foundation
import Web3Swift
import CryptoSwift

enum ABIEventError: Error {
    
    case malformedEvent
    case wrongSignature
}

public struct ABIEventType {
    
    let type: ABIType.Type
    let indexed: Bool
}

public protocol ABIEvent {
    
    static var name: String { get }
    
    static var types: [ABIEventType] { get }

    static func signature() throws -> Data

    var contract: EthAddress { get }
    
    init(log: TransactionLog) throws
}

extension ABIEvent {
    
    public static var name: String {
        
        return String(describing: self)
    }
    
    public static var dataTypes: [ABIType.Type] {
        
        return Self.types.enumerated()
            .filter { Self.types[$0.offset].indexed == false }
            .compactMap { $0.element.type }
    }
    
    public static func verifySignature(log: TransactionLog) throws -> Bool {
        
        let eventSignature = try Self.signature()
        let logSignature = try log.signature().value()
        return eventSignature == logSignature
    }
    
    public static func signature() throws -> Data {
        
        let signatureString = name + "(\(types.map { $0.type.abiType() }.joined(separator: ",")))"
        return try signatureString.data().sha3(.keccak256)
    }
    
    public static func parse(types: [ABIEvent.Type], logs: [TransactionLog]) -> [ABIEvent] {
     
        return logs.flatMap { log in types.compactMap { type in try? type.init(log: log) }}
    }
}
