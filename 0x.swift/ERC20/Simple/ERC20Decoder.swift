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

class ERC20Decoder: ABIDecoder {
    
}

class ABIDecoder {
    
    func number(message: ABIMessage, index: Int = 0) throws -> EthNumber {
        return try EthNumber(
            hex: SimpleBytes(
                bytes: DecodedABINumber(
                    abiMessage: message,
                    index: index
                ).value()
            )
        )
    }
    
    func string(message: ABIMessage, index: Int = 0) throws -> String {
        return try DecodedABIString(
            abiMessage: message,
            index: index
        ).value()
    }
    
    func address(message: ABIMessage, index: Int = 0) throws -> EthAddress {
        return try EthAddress(
            bytes: SimpleBytes(
                bytes: DecodedABIAddress(
                    abiMessage: message,
                    index: index
                ).value()
            )
        )
    }
    
    func boolean(message: ABIMessage, index: Int = 0) throws -> Bool {
        return try DecodedABIBoolean(
            abiMessage: message, index: index
        ).value()
    }
    
}

