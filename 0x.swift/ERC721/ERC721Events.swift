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
        
        public init(log: TransactionLog) throws {
            
            try Transfer.verifySignature(log: log)
            
            self.from = EthAddress(bytes: TrimmedZeroPrefixBytes(origin: try log.topics()[1]))
            self.to = EthAddress(bytes: TrimmedZeroPrefixBytes(origin: try log.topics()[2]))
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
        
        public init(log: TransactionLog) throws {
            
            try Approval.verifySignature(log: log)
            
            self.owner = EthAddress(bytes: TrimmedZeroPrefixBytes(origin: try log.topics()[1]))
            self.approved = EthAddress(bytes: TrimmedZeroPrefixBytes(origin: try log.topics()[2]))
            self.tokenId = EthNumber(hex: try log.topics()[3])
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
        
        public init(log: TransactionLog) throws {
            
            try Approval.verifySignature(log: log)
            
            self.owner = EthAddress(bytes: TrimmedZeroPrefixBytes(origin: try log.topics()[1]))
            self.operator = EthAddress(bytes: TrimmedZeroPrefixBytes(origin: try log.topics()[2]))
            self.approved = try Bool.decode(message: log.data(), index: 0)
        }
    }
}
