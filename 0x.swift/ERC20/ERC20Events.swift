//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ERC20Events.swift
//
// Created by Igor Shmakov on 11/05/2019
//

import Foundation
import Web3Swift

public struct ERC20Events {
    
    public struct Transfer: ABIEvent {

        public static let types: [ABIEventType] = [
            ABIEventType(type: EthAddress.self, indexed: true),
            ABIEventType(type: EthAddress.self, indexed: true),
            ABIEventType(type: EthNumber.self, indexed: false)
        ]
        
        public let from: EthAddress
        public let to: EthAddress
        public let value: EthNumber
        
        public init(log: TransactionLog) throws {
            
            guard try Transfer.verifySignature(log: log) else {
                throw ABIEventError.wrongSignature
            }
            
            let decoder = ABIDecoder()
            
            self.from = try decoder.decode(bytes: try log.topics()[1])
            self.to = try decoder.decode(bytes: try log.topics()[2])
            self.value = try decoder.decode(message: log.data(), index: 0)
        }
    }
    
    public struct Approval: ABIEvent {
        
        public static let types: [ABIEventType] = [
            ABIEventType(type: EthAddress.self, indexed: true),
            ABIEventType(type: EthAddress.self, indexed: true),
            ABIEventType(type: EthNumber.self, indexed: false)
        ]
        
        public let owner: EthAddress
        public let spender: EthAddress
        public let value: EthNumber
        
        public init(log: TransactionLog) throws {
            
            guard try Approval.verifySignature(log: log) else {
                throw ABIEventError.wrongSignature
            }
            
            let decoder = ABIDecoder()
            
            self.owner = try decoder.decode(bytes: try log.topics()[1])
            self.spender = try decoder.decode(bytes: try log.topics()[2])
            self.value = try decoder.decode(message: log.data(), index: 0)
        }
    }
}
