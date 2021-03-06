//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ERC20Token.swift
//
// Created by Vadim Koleoshkin on 10/04/2019
//

import Web3Swift

public class ERC20Token: ERC20 {
    
    let encoder: ERC20Encoder
    let decoder: ERC20Decoder
    let interactor: ContractInteractor
    
    init(
        contract: EthAddress,
        network: Network,
        encoder: ERC20Encoder,
        decoder: ERC20Decoder
    ) {
        self.interactor = Web3ContractInteractor(
            contract: contract,
            network: network
        )
        self.encoder = encoder
        self.decoder = decoder
    }
    
    convenience init(contract: EthAddress, network: Network)
    {
        self.init(
            contract: contract,
            network: network,
            encoder: ERC20Encoder(),
            decoder: ERC20Decoder()
        )
    }
    
    func totalSupply() throws -> EthNumber {
        return try decoder.number(
            message: interactor.call(
                function: encoder.totalSupply()
            )
        )
    }
    
    func balanceOf(owner: EthAddress) throws -> EthNumber {
        return try decoder.number(
            message: interactor.call(
                function: encoder.balanceOf(owner: owner)
            )
        )
    }
    
    func allowance(owner: EthAddress, spender: EthAddress) throws -> EthNumber {
        return try decoder.number(
            message: interactor.call(
                function: encoder.allowance(
                    owner: owner,
                    spender: spender
                )
            )
        )
    }
    
    func transfer(to: EthAddress, value: EthNumber, sender: EthPrivateKey) throws -> TransactionHash {
        return try interactor.send(
            function: encoder.transfer(
                to: to,
                value: value
            ),
            value: EthNumber(hex: "0x00"),
            sender: sender
        )
    }
    
    func transferFrom(from: EthAddress, to: EthAddress, value: EthNumber, sender: EthPrivateKey) throws -> TransactionHash {
        return try interactor.send(
            function: encoder.transferFrom(
                from: from,
                to: to,
                value: value
            ),
            value: EthNumber(hex: "0x00"),
            sender: sender
        )
    }
    
    func approve(spender: EthAddress, value: EthNumber, sender: EthPrivateKey) throws -> TransactionHash {
        return try interactor.send(
            function: encoder.approve(
                spender: spender,
                value: value
            ),
            value: EthNumber(hex: "0x00"),
            sender: sender
        )
    }
}

extension ERC20Token: ERC20Detailed {
    
    func name() throws -> String? {
        let name = try decoder.string(
            message: interactor.call(
                function: encoder.name()
            )
        )
        return name.isEmpty ? nil : name
    }
    
    func symbol() throws -> String? {
        let symbol = try decoder.string(
            message: interactor.call(
                function: encoder.symbol()
            )
        )
        return symbol.isEmpty ? nil : symbol
        
    }
    
    func decimals() throws -> EthNumber {
        return try decoder.number(
            message: interactor.call(
                function: encoder.decimals()
            )
        )
    }
    
}
