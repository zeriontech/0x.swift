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

enum ABIEventError: Error {
    
    case malformedEvent
}

public struct ABIEventType {
    
    let type: ABIType.Type
    let indexed: Bool
}

public protocol ABIEvent {
    
    static var name: String { get }
    
    static var types: [ABIEventType] { get }

    static func signature() throws -> String
    
    init?(log: TransactionLog) throws
}

extension ABIEvent {
    
    public static var name: String {
        
        return String(describing: type(of: self))
    }
    
    public static var dataTypes: [ABIType.Type] {
        
        return Self.types.enumerated()
            .filter { Self.types[$0.offset].indexed == false }
            .compactMap { $0.element.type }
    }
    
    public static func verifySignature(log: TransactionLog) throws {
        
        let signature = String(data: try log.signature().value(), encoding: .utf8)
        
        guard try Self.signature() == signature else {
            throw ABIEventError.malformedEvent
        }
    }
    
    public static func signature() throws -> String {
        
        return name + "(\(types.map { $0.type.rawType() }.joined(separator: ",")))"
    }
}
