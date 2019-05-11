//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// EthereumLog.swift
//
// Created by Igor Shmakov on 11/05/2019
//

import Foundation
import Web3Swift

public struct EthereumLog {
    
    public let logIndex: Int64?
    public let transactionIndex: Int64?
    public let transactionHash: String?
    public let blockHash: String?
    public let blockNumber: Int64
    public let address: EthAddress
    public var data: Data
    public var topics: [ABIMessage]
    public let removed: Bool
}

// TODO: Implement parsing from JSON
