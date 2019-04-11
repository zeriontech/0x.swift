//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ERC20.swift
//
// Created by Vadim Koleoshkin on 10/04/2019
//

import Web3Swift

protocol ERC20 {
    
    // Calls
    func totalSupply() throws -> EthNumber
    
    func balanceOf(owner: EthAddress) throws -> EthNumber
    
    func allowance(owner: EthAddress, spender: EthAddress) throws -> EthNumber
    
    // Executions
    //TODO: Refactor TransactionHash
    func transfer(to: EthAddress, value: EthNumber, sender: EthPrivateKey) throws -> BytesScalar
    
    func transferFrom(from: EthAddress, to: EthAddress, value: EthNumber, sender: EthPrivateKey) throws -> BytesScalar
    
    func approve(spender: EthAddress, value: EthNumber, sender: EthPrivateKey) throws -> BytesScalar

}
