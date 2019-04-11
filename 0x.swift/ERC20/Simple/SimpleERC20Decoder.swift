//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ERC20Decoder.swift
//
// Created by Vadim Koleoshkin on 10/04/2019
//

import Web3Swift

class SimpleERC20Decoder: ABIDecoder {
    
}

class ABIDecoder {
    
    func decodeNumber(message: ABIMessage) throws -> EthNumber {
        return try EthNumber(
            hex: DecodedABINumber(
                abiMessage: message,
                index: 0
            ).value().toHexString()
        )
    }
    
    func decodeString(message: ABIMessage) throws -> String {
        return try DecodedABIString(abiMessage: message, index: 0).value()
    }
    
}

