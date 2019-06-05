//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ERC721Events.swift
//
// Created by Igor Shmakov on 24/05/2019
//

import Foundation
import Web3Swift

public struct ERC721Events {
    
    public struct Transfer: ABIEvent {
        
        public static let types: [ABIEventType] = [
            ABIEventType(type: EthAddress.self, indexed: true),
            ABIEventType(type: EthAddress.self, indexed: true),
            ABIEventType(type: EthNumber.self, indexed: true)
        ]
        
        public let from: EthAddress
        public let to: EthAddress
        public let tokenId: EthNumber
        public let contract: EthAddress
        
        public init(log: TransactionLog) throws {
            
            guard try Transfer.verifySignature(log: log) else {
                throw ABIEventError.wrongSignature
            }
            
            let decoder = ABIDecoder()
            
            self.contract = try log.address()
            self.from = try decoder.decode(bytes: try log.topics()[1])
            self.to = try decoder.decode(bytes: try log.topics()[2])
            self.tokenId = EthNumber(hex: try log.topics()[3])
        }
    }
    
    public struct Approval: ABIEvent {
        
        public static let types: [ABIEventType] = [
            ABIEventType(type: EthAddress.self, indexed: true),
            ABIEventType(type: EthAddress.self, indexed: true),
            ABIEventType(type: EthNumber.self, indexed: true)
        ]
        
        public let owner: EthAddress
        public let approved: EthAddress
        public let tokenId: EthNumber
        public let contract: EthAddress
        
        public init(log: TransactionLog) throws {
            
            guard try Approval.verifySignature(log: log) else {
                throw ABIEventError.wrongSignature
            }
            
            let decoder = ABIDecoder()
            
            self.contract = try log.address()
            self.owner = try decoder.decode(bytes: try log.topics()[1])
            self.approved = try decoder.decode(bytes: try log.topics()[2])
            self.tokenId = try decoder.decode(bytes: log.topics()[3])
        }
    }
    
    public struct ApprovalForAll: ABIEvent {
        
        public static let types: [ABIEventType] = [
            ABIEventType(type: EthAddress.self, indexed: true),
            ABIEventType(type: EthAddress.self, indexed: true),
            ABIEventType(type: EthNumber.self, indexed: false)
        ]
        
        public let owner: EthAddress
        public let `operator`: EthAddress
        public let approved: Bool
        public let contract: EthAddress
        
        public init(log: TransactionLog) throws {
            
            guard try Approval.verifySignature(log: log) else {
                throw ABIEventError.wrongSignature
            }
            
            let decoder = ABIDecoder()
            
            self.contract = try log.address()
            self.owner = try decoder.decode(bytes: try log.topics()[1])
            self.operator = try decoder.decode(bytes: try log.topics()[2])
            self.approved = try decoder.decode(message: log.data(), index: 0)
        }
    }
}
