//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ERC721Token.swift
//
// Created by Vadim Koleoshkin on 24/04/2019
//

import Foundation
import Web3Swift

class ERC721Token: ERC721 {
    
    let encoder: ERC721Encoder
    let decoder: ABIDecoder
    let interactor: ContractInteractor
    
    init(
        contract: EthAddress,
        network: Network,
        encoder: ERC721Encoder,
        decoder: ABIDecoder
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
            encoder: ERC721Encoder(),
            decoder: ABIDecoder()
        )
    }
    
    func balanceOf(owner: EthAddress) throws -> EthNumber {
        return try decoder.number(
            message: interactor.call(
                function: encoder.balanceOf(owner: owner)
            )
        )
    }
    
    func ownerOf(tokenId: EthNumber) throws -> EthAddress {
        return try decoder.address(
            message: interactor.call(
                function: encoder.ownerOf(tokenId: tokenId)
            )
        )
    }
    
    func getApproved(tokenId: EthNumber) throws -> EthAddress {
        return try decoder.address(
            message: interactor.call(
                function: encoder.getApproved(tokenId: tokenId)
            )
        )
    }
    
    func isApprovedForAll(owner: EthAddress, _operator: EthAddress) throws -> Bool {
        return try decoder.boolean(
            message: interactor.call(
                function: encoder.isApprovedForAll(owner: owner, _operator: _operator)
            )
        )
    }
    
    func approve(to: EthAddress, tokenId: EthNumber, sender: EthPrivateKey) throws -> TransactionHash {
        return try interactor.send(
            function: encoder.approve(
                to: to,
                tokenId: tokenId
            ),
            value: EthNumber(hex: "0x00"),
            sender: sender
        )
    }
    
    func setApprovalForAll(_operator: EthAddress, approved: Bool, sender: EthPrivateKey) throws -> TransactionHash {
        return try interactor.send(
            function: encoder.setApprovalForAll(
                _operator: _operator,
                approved: approved
            ),
            value: EthNumber(hex: "0x00"),
            sender: sender
        )
    }
    
    func transferFrom(from: EthAddress, to: EthAddress, tokenId: EthNumber, sender: EthPrivateKey) throws -> TransactionHash {
        return try interactor.send(
            function: encoder.transferFrom(
                from: from,
                to: to,
                tokenId: tokenId
            ),
            value: EthNumber(hex: "0x00"),
            sender: sender
        )
    }
    
    func safeTransferFrom(from: EthAddress, to: EthAddress, tokenId: EthNumber, sender: EthPrivateKey) throws -> TransactionHash {
        return try interactor.send(
            function: encoder.safeTransferFrom(
                from: from,
                to: to,
                tokenId: tokenId
            ),
            value: EthNumber(hex: "0x00"),
            sender: sender
        )
    }
    
    func safeTransferFrom(from: EthAddress, to: EthAddress, tokenId: EthNumber, bytes: BytesScalar, sender: EthPrivateKey) throws -> TransactionHash {
        return try interactor.send(
            function: encoder.safeTransferFrom(
                from: from,
                to: to,
                tokenId: tokenId,
                bytes: bytes
            ),
            value: EthNumber(hex: "0x00"),
            sender: sender
        )
    }
}

extension ERC721Token: ERC165 {
    func supportsInterface(interfaceId: FixedLengthBytes) throws -> Bool {
        return try decoder.boolean(
            message: interactor.call(
                function: encoder.supportsInterface(
                    interfaceId: interfaceId
                )
            )
        )
    }
}

extension ERC721Token: ERC721Metadata {
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
    
    func tokenURI(tokenId: EthNumber) throws -> String? {
        let tokenURI = try decoder.string(
            message: interactor.call(
                function: encoder.tokenURI(
                    tokenId: tokenId
                )
            )
        )
        return tokenURI.isEmpty ? nil : tokenURI
    }
}

extension ERC721Token: ERC721Enumerable {
    func totalSupply() throws -> EthNumber {
        return try decoder.number(
            message: interactor.call(
                function: encoder.totalSupply()
            )
        )
    }
    
    func tokenOfOwnerByIndex(owner: EthAddress, index: EthNumber) throws -> EthNumber {
        return try decoder.number(
            message: interactor.call(
                function: encoder.tokenOfOwnerByIndex(owner: owner, index: index)
            )
        )
    }
    
    func tokenByIndex(index: EthNumber) throws -> EthNumber {
        return try decoder.number(
            message: interactor.call(
                function: encoder.tokenByIndex(index: index)
            )
        )
    }
}
