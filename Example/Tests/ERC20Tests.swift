//
// This source file is part of the 0x.swift open source project
// Copyright 2019 The 0x.swift Authors
// Licensed under Apache License v2.0
//
// ERC20Tests.swift
//
// Created by Vadim Koleoshkin on 16/04/2019
//

import Nimble
import Quick
import Web3Swift
@testable import Swifty0x

class ERC20Tests: XCTestCase {

    enum ERC20TestsErrors: Error {
        case invalidNumber
    }

    
    let token = ERC20Token(
        contract: EthAddress(
            hex: "0xe41d2489571d322189246dafa5ebde1f4699f498"
        ),
        network: AlchemyNetwork(
            chain: "mainnet",
            apiKey: "ETi2ntZoWxd6nTI1qE13Q4I1eLB8AMDl"
        )
    )
    
    func testName() {
        expect{
            try self.token.name()
        }.to(
           equal("0x Protocol Token"),
           description: "Token should be named correctly"
        )
    }
    
    func testDecimals() {
        expect{
            try self.token.decimals().value().toHexString()
        }.to(
            equal("12"),
            description: "Token should have correct decimals"
        )
    }
    
    func testSymbol() {
        expect{
            try self.token.symbol()
        }.to(
            equal("ZRX"),
            description: "Token should have correct symbol"
        )
    }
    
    func testBalanceOf() {
        expect{
            guard let number = try Decimal(
                string: HexAsDecimalString(
                    hex: self.token.balanceOf(
                        owner: EthAddress(
                            hex: "0x505e20c0Fb8252Ca7aC21d54D5432eccD4f2D076"
                        )
                    )
                ).value()
            ) else {
                throw ERC20TestsErrors.invalidNumber
            }
            return number
        }.to(
            beGreaterThan(Decimal(0))
        )
    }
}
