//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ERC721Tests.swift
//
// Created by Vadim Koleoshkin on 26/04/2019
//

import Nimble
import Quick
import Web3Swift
@testable import Swifty0x

class ERC721Tests: XCTestCase {
    
    enum ERC721TestsErrors: Error {
        case invalidNumber
    }
    
    let kitties = ERC721Token(
        contract: EthAddress(
            hex: "0x06012c8cf97bead5deae237070f9587f8e7a266d"
        ),
        network: AlchemyNetwork(
            chain: "mainnet",
            apiKey: "ETi2ntZoWxd6nTI1qE13Q4I1eLB8AMDl"
        )
    )
    
    let kittyOwner = EthAddress(
        hex: "0x0aD9Fb61a07BAC25625382B63693644497f1B204"
    )
    
    func testBalanceOf() {
        expect{
            guard let number = try Decimal(
                string: HexAsDecimalString(
                    hex: self.kitties.balanceOf(
                            owner: self.kittyOwner
                        )
                    ).value()
            ) else {
                throw ERC721TestsErrors.invalidNumber
            }
            return number
        }.to(
            beGreaterThanOrEqualTo(
                Decimal(0)
            ),
            description: "Token balance should be greater than or equal to 0"
        )
    }
    
    func testOwnerOf() {
        expect{
            try PrefixedHexString(
                bytes: self.kitties.ownerOf(
                    tokenId: EthNumber(
                        value: 371578
                    )
                )
            ).value()
        }.to(
            equal("0x0ad9fb61a07bac25625382b63693644497f1b204"),
            description: "Token should belong to owner"
        )
    }
    
    func testSupportsInterface() {
        expect{
            try self.kitties.supportsInterface(
                interfaceId: FixedLengthBytes(
                    origin: BytesFromHexString(
                        hex: "0x80ac58cd"
                    ),
                    length: 4
                )
            )
        }.to(
            equal(false),
            description: "CryptoKitties should not support interface"
        )
    }
    //TODO: Need another NFT contract
    func testGetApproved() {
//        expect{
//            try PrefixedHexString(
//                bytes: self.kitties.getApproved(
//                    tokenId: EthNumber(
//                        value: 371578
//                    )
//                )
//            ).value()
//        }.to(
//            equal("0x0ad9fb61a07bac25625382b63693644497f1b204"),
//            description: "Token should belong to owner"
//        )
    }
    
    
}
