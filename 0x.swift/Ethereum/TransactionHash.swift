//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// TransactionHash.swift
//
// Created by Vadim Koleoshkin on 16/04/2019
//

import Foundation
import Web3Swift

class TransactionHash: BytesScalar {
    
    private let origin: FixedLengthBytes
    
    init(hash: String) {
        origin = FixedLengthBytes(
            origin: BytesFromHexString(hex: hash),
            length: 128
        )
    }
    
    func value() throws -> Data {
        return try origin.value()
    }
    
    
}
