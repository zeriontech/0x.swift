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

class SimpleERC20Token: ERC20 {
    
    let encoder: SimpleERC20Encoder
    let decoder: SimpleERC20Decoder
    let interactor: ContractInteractor
    
    public init(
        contract: EthAddress,
        network: Network,
        encoder: SimpleERC20Encoder,
        decoder: SimpleERC20Decoder
    ) {
        self.interactor = ContractInteractor(
            contract: contract,
            network: network
        )
        self.encoder = encoder
        self.decoder = decoder
    }
    
    public convenience init(contract: EthAddress, network: Network)
    {
        self.init(
            contract: contract,
            network: network,
            encoder: SimpleERC20Encoder(),
            decoder: SimpleERC20Decoder()
        )
    }
    
    func totalSupply() throws -> EthNumber {
        return try decoder.decodeNumber(
            message: interactor.call(
                function: encoder.totalSupply()
            )
        )
    }
    
    func balanceOf(owner: EthAddress) throws -> EthNumber {
        return try decoder.decodeNumber(
            message: interactor.call(
                function: encoder.balanceOf(owner: owner)
            )
        )
    }
    
    func allowance(owner: EthAddress, spender: EthAddress) throws -> EthNumber {
        return try decoder.decodeNumber(
            message: interactor.call(
                function: encoder.allowance(
                    owner: owner,
                    spender: spender
                )
            )
        )
    }
    
    func transfer(to: EthAddress, value: EthNumber, sender: EthPrivateKey) throws -> BytesScalar {
        return try interactor.send(
            sender: sender,
            function: encoder.transfer(
                to: to,
                value: value
            )
        )
    }
    
    func transferFrom(from: EthAddress, to: EthAddress, value: EthNumber, sender: EthPrivateKey) throws -> BytesScalar {
        return try interactor.send(
            sender: sender,
            function: encoder.transferFrom(
                from: from,
                to: to,
                value: value
            )
        )
    }
    
    func approve(spender: EthAddress, value: EthNumber, sender: EthPrivateKey) throws -> BytesScalar {
        return try interactor.send(
            sender: sender,
            function: encoder.approve(
                spender: spender,
                value: value
            )
        )
    }
}

extension SimpleERC20Token: ERC20Detailed {
    
    func name() throws -> String? {
        let name = try decoder.decodeString(
            message: interactor.call(
                function: encoder.name()
            )
        )
        return name.isEmpty ? nil : name
    }
    
    func symbol() throws -> String? {
        let symbol = try decoder.decodeString(
            message: interactor.call(
                function: encoder.symbol()
            )
        )
        return symbol.isEmpty ? nil : symbol
        
    }
    
    func decimals() throws -> EthNumber {
        return try decoder.decodeNumber(
            message: interactor.call(
                function: encoder.decimals()
            )
        )
    }
    
}
