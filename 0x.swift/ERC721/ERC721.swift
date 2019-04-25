//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ERC721.swift
//
// Created by Vadim Koleoshkin on 24/04/2019
//

import Web3Swift

protocol ERC721 {
    
    //Calls
    func balanceOf(owner: EthAddress) throws -> EthNumber
    
    func ownerOf(tokenId: EthNumber) throws -> EthAddress
    
    func getApproved(tokenId: EthNumber) throws -> EthAddress
    
    func isApprovedForAll(owner: EthAddress, operator: EthAddress) throws -> Bool
    
    // Executions
    func approve(to: EthAddress, tokenId: EthNumber, sender: EthPrivateKey) throws -> TransactionHash
    
    func setApprovalForAll(operator: EthAddress, approved: Bool, sender: EthPrivateKey) throws -> TransactionHash
    
    func transferFrom(from: EthAddress, to: EthAddress, tokenId: EthNumber, sender: EthPrivateKey) throws -> TransactionHash
    
    func safeTransferFrom(from: EthAddress, to: EthAddress, tokenId: EthNumber, sender: EthPrivateKey) throws -> TransactionHash
    
    func safeTransferFrom(from: EthAddress, to: EthAddress, tokenId: EthNumber, bytes: BytesScalar, sender: EthPrivateKey) throws -> TransactionHash
    
}
