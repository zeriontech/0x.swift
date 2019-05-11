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
        
        public let log: EthereumLog
        public let from: EthAddress
        public let to: EthAddress
        public let value: EthNumber
        
        public init?(log: EthereumLog) throws {
            
            let decoder = ABIDecoder()
            let signature: String = try decoder.decode(message: log.topics[0])
            
            guard try Transfer.signature() == signature else {
                throw ABIEventError.malformedEvent
            }
            
            guard let decoded = try? decoder.decode(data: log.data, types: Transfer.dataTypes) else {
                throw ABIEventError.malformedEvent
            }

            self.log = log
            self.from = try decoder.decode(message: log.topics[1])
            self.to = try decoder.decode(message: log.topics[2])
            self.value = try decoder.decode(message: decoded[0])
        }
    }
}
