//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ContractInteractor.swift
//
// Created by Vadim Koleoshkin on 16/04/2019
//

import Foundation
import Web3Swift

protocol ContractInteractor {
    
    var network: Network { get }
    var contract: EthAddress { get }
    
    init(contract: EthAddress, network: Network)
    
    func call(function: EncodedABIFunction) throws -> ABIMessage
        
    func send(function: EncodedABIFunction, value: EthNumber, sender: PrivateKey) throws -> TransactionHash
}

class Web3ContractInteractor: ContractInteractor {
    
    let network: Network
    let contract: EthAddress
    
    enum errors: Error {
        case failedToSend
    }
    
    required init(contract: EthAddress, network: Network) {
        self.contract = contract
        self.network = network
    }
    
    func call(function: EncodedABIFunction) throws -> ABIMessage {
        return try ABIMessage(
            message: EthContractCall(
                network: network,
                contractAddress: contract,
                functionCall: function
            ).value().toHexString()
        )
    }
    
    func send(function: EncodedABIFunction, value: EthNumber, sender: PrivateKey) throws -> TransactionHash {
        
        let response = try SendRawTransactionProcedure(
            network: network,
            transactionBytes: EthContractCallBytes(
                network: network,
                senderKey: sender,
                contractAddress: contract,
                weiAmount: value,
                functionCall: function
            )
        ).call()
        
        guard let hash = response["result"].string else {
            throw errors.failedToSend
        }
        
        return EthTransactionHash(
            transactionHash: BytesFromHexString(hex: hash),
            network: network
        )
    }
}
