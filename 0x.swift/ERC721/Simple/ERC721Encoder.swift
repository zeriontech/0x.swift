//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ERC721Encoder.swift
//
// Created by Vadim Koleoshkin on 24/04/2019
//

import Foundation
import Web3Swift

class ERC721Encoder: ABIEncoder {
    
    func balanceOf(owner: EthAddress) -> EncodedABIFunction {
        return encode(
            function: "balanceOf(address)",
            parameters: [
                ABIAddress(
                    address: owner
                )
            ]
        )
    }
    
    func ownerOf(tokenId: EthNumber) -> EncodedABIFunction {
        return encode(
            function: "ownerOf(uint256)",
            parameters: [
                ABIUnsignedNumber(
                    origin: tokenId
                )
            ]
        )
    }
    
    func getApproved(tokenId: EthNumber) -> EncodedABIFunction {
        return encode(
            function: "getApproved(uint256)",
            parameters: [
                ABIUnsignedNumber(
                    origin: tokenId
                )
            ]
        )
    }
    
    func isApprovedForAll(owner: EthAddress, _operator: EthAddress) -> EncodedABIFunction {
        return encode(
            function: "isApprovedForAll(address,address)",
            parameters: [
                ABIAddress(
                    address: owner
                ),
                ABIAddress(
                    address: _operator
                )
            ]
        )
    }
    
    func approve(to: EthAddress, tokenId: EthNumber) -> EncodedABIFunction {
        return encode(
            function: "approve(address,uint256)",
            parameters: [
                ABIAddress(
                    address: to
                ),
                ABIUnsignedNumber(
                    origin: tokenId
                ),
            ]
        )
    }
    
    func setApprovalForAll(_operator: EthAddress, approved: Bool) -> EncodedABIFunction {
        return encode(
            function: "setApprovalForAll(address,bool)",
            parameters: [
                ABIAddress(
                    address: _operator
                ),
                ABIBoolean(
                    origin: approved
                ),
            ]
        )
    }
    
    func transferFrom(from: EthAddress, to: EthAddress, tokenId: EthNumber) -> EncodedABIFunction {
        return encode(
            function: "transferFrom(address,address,uint256)",
            parameters: [
                ABIAddress(
                    address: from
                ),
                ABIAddress(
                    address: to
                ),
                ABIUnsignedNumber(
                    origin: tokenId
                ),
            ]
        )
    }
    
    func safeTransferFrom(from: EthAddress, to: EthAddress, tokenId: EthNumber) -> EncodedABIFunction {
        return encode(
            function: "safeTransferFrom(address,address,uint256)",
            parameters: [
                ABIAddress(
                    address: from
                ),
                ABIAddress(
                    address: to
                ),
                ABIUnsignedNumber(
                    origin: tokenId
                ),
            ]
        )
    }
    
    func safeTransferFrom(from: EthAddress, to: EthAddress, tokenId: EthNumber, bytes: BytesScalar) -> EncodedABIFunction {
        return encode(
            function: "safeTransferFrom(address,address,uint256,bytes)",
            parameters: [
                ABIAddress(
                    address: from
                ),
                ABIAddress(
                    address: to
                ),
                ABIUnsignedNumber(
                    origin: tokenId
                ),
                ABIVariableBytes(
                    origin: bytes
                )
            ]
        )
    }
}

extension ERC721Encoder {
    
    func supportsInterface(interfaceId: FixedLengthBytes) -> EncodedABIFunction {
        return encode(
            function: "supportsInterface(bytes4)",
            parameters: [
                ABIFixedBytes(
                    origin: interfaceId
                )
            ]
        )
    }
}

extension ERC721Encoder {
    
    func name() -> EncodedABIFunction {
        return encode(function: "name()")
    }
    
    func symbol() -> EncodedABIFunction {
        return encode(function: "symbol()")
    }
    
    func tokenURI(tokenId: EthNumber) -> EncodedABIFunction {
        return encode(
            function: "tokenURI(uint256)",
            parameters: [
                ABIUnsignedNumber(
                    origin: tokenId
                )
            ]
        )
    }
    
}

extension ERC721Encoder {
    
    func totalSupply() -> EncodedABIFunction {
        return encode(
            function: "totalSupply()"
        )
    }
    
    func tokenOfOwnerByIndex(owner: EthAddress, index: EthNumber) -> EncodedABIFunction {
        return encode(
            function: "tokenOfOwnerByIndex(address,uint256)",
            parameters: [
                ABIAddress(
                    address: owner
                ),
                ABIUnsignedNumber(
                    origin: index
                )
            ]
        )
    }
    
    func tokenByIndex(index: EthNumber) -> EncodedABIFunction {
        return encode(
            function: "tokenByIndex(uint256)",
            parameters: [
                ABIUnsignedNumber(
                    origin: index
                )
            ]
        )
    }
}
