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
    case incorrectParameterCount
    case notImplemented
}

public struct ABIEventType {
    
    let type: ABIType.Type
    let indexed: Bool
}

public protocol ABIEvent {
    
    static var name: String { get }
    
    static var types: [ABIEventType] { get }

    static func checkParameters(topics: [String], data: [ABIType]) throws
    
    static func signature() throws -> String
    
    var log: EthereumLog { get }
    
    init?(log: EthereumLog) throws
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
    
    public static func checkParameters(topics: [String], data: [ABIType]) throws {
        
        let indexedCount = Self.types.filter { $0.indexed == true }.count
        let unindexedCount = Self.types.filter { $0.indexed == false }.count
        
        guard topics.count == indexedCount, data.count == unindexedCount else {
            throw ABIEventError.incorrectParameterCount
        }
    }
    
    public static func signature() throws -> String {
        
        // TODO: Make signature from name and types
        throw ABIEventError.notImplemented
    }
}
