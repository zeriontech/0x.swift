//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// EIP712Signer.swift
//
// Created by Igor Shmakov on 19/04/2019
//

import Foundation
import Web3Swift
import CryptoSwift

class EIP712Signer: EIP712Signable {
    
    let privateKey: EthPrivateKey
    
    init(privateKey: EthPrivateKey) {
        
        self.privateKey = privateKey
    }
    
    func sign(hash: EIP712Hashable) throws -> SECP256k1Signature {
        
        let hashFunction = SHA3(variant: .keccak256).calculate
        
        let signature = SECP256k1Signature(
            privateKey: privateKey,
            message: SimpleBytes(bytes: try hash.hash()),
            hashFunction: hashFunction
        )
        
        return signature
    }
}
